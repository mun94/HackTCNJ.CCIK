

  library(twitteR)
  library(RCurl)
  library(shiny)
  library(wordcloud)
  library(tm)
  library(stringr)
  library(plyr)
  library(SentimentAnalysis)
  library(NLP)
  library(slam)
  library(leaflet)

  #Initialize empty global list of tweets

  shinyServer(function(input, output) {
    
    #Searches twitter and inputs in global list
    tweet_vector <- eventReactive(input$submit,{
      if(input$useRecent){
        searchTwitter(c(input$topic),lang="en",n=500,resultType = "recent")
      } else {
        searchTwitter(c(input$topic),lang="en",n=500,resultType = "popular")
      }
    })
    
    clean_corpus=function(tweet_vector, type, topic){
      # get_tweets()
      if(type=="Corpus"){
        topic_text=sapply(tweet_vector,function(x) x$getText())
        topic_text=str_replace_all(topic_text,"[^[:graph:]]", " ") 
        topic_corpus=Corpus(VectorSource(topic_text))
        topic_corpus=tm_map(topic_corpus,removePunctuation)
        topic_corpus=tm_map(topic_corpus,content_transformer(tolower))
        topic_corpus=tm_map(topic_corpus,removeWords,stopwords("english"))
        topic_corpus=tm_map(topic_corpus,removeNumbers)
        topic_corpus=tm_map(topic_corpus,stripWhitespace)
        topic_corpus=tm_map(topic_corpus,removeWords,tolower(c(topic)))
        return(topic_corpus)
      }
      else if(type=="Regular"){
        dataframe<-twListToDF(tweet_vector)
        return(dataframe)
      }
    }
    
    output$wordcloud <- renderPlot({
      wordcloud(clean_corpus(tweet_vector(), "Corpus", c(input$topic)), scale=c(4,0.5), colors=brewer.pal(8, "Dark2"))
    })
    
   output$histogram <- renderPlot({
     tweets_text_corpus=clean_corpus(tweet_vector(),"Corpus", c(input$topic)) 
     sentimentData <- analyzeSentiment(tweets_text_corpus)
     x <- sentimentData$SentimentGI #insert sentiment data
     hist(x, col = 'darkgray', border = 'white')
   })
    
   avg_sentiment <- eventReactive(input$submit, {
     long_time_ago="2016-01-01"
     until_timeline="2017-02-19"
     until_timeline_num <- strsplit(until_timeline, "\\-")[[1]]
     until_timeline_v <- unique(tolower(until_timeline_num))
     until_timeline_yr <- as.numeric(until_timeline_v[1])
     until_timeline_m <- as.numeric(until_timeline_v[2])
     until_timeline_d <- as.numeric(until_timeline_v[3])
     
     avg_sentiment = list(length=7)
     tot_num_tweet = 0
     days_week = 7
     # It will look at whether the term that people (in a specific region) used is related to a negative or positive sentence on each day.
     for(i in 1:days_week){  # i is the current day
       day_index = i + until_timeline_d
       begin_day_str = formatC(day_index, width=2, flag="0")
       until_d = paste("2017-02", begin_day_str, sep="-")
       print(until_d)
       tweets <- searchTwitter(input$topic, n=100, since=long_time_ago, until=until_d) # API Call on each day
       if (length(tweets) != 0){
         tweets.matrix <- twListToDF(tweets)
         tweets_text <- sapply(tweets, function(x) x$getText())
         tweets_text_corpus <- Corpus(VectorSource(tweets_text))
         tweets_text_corpus <- tm_map(tweets_text_corpus, content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')), mc.cores=1)
         sentiment <- analyzeSentiment(tweets_text_corpus)
         avg_sentiment[i] = mean(sentiment[,2]) # Find the avg sentiment of each day
         # print(avg_sentiment[i])
         tot_num_tweet = tot_num_tweet + length(tweets_text)
       } else {
         avg_sentiment[i] = 0
         # print(avg_sentiment[i])
       }
       # print(tot_num_tweet)
     }
     return(avg_sentiment)
   })
   
  output$timeseries <- renderPlot({
    #avg_sentiment=timeseries_helper(input$topic)
    #avg_sentiment=as.data.frame(avg_sentiment)
    # Graph
    plot(x=c(1,2,3,4,5,6,7),y=avg_sentiment()[1:7], type="o", col="blue", ylim=c(-1,1), axes=FALSE, ann=FALSE)
    # Make x axis using Day1 to Day7
    axis(1, las=1, at=1:7, lab=c("Day 1", "Day 2", "Day 3", "Day 4", "Day 5", "Day 6", "Day 7"))
    # Make y axis with horizontal labels that display -1, 0, and 1 as -, neural, and +, repsectively.
    axis(2, las=1, at=-1:1, lab=c("Negatve", "Neutral", "Positive"))
    # Create box around plot
    box()
  })
  
  ratio_sentiment_num = eventReactive(input$submit, {
    # Look at how many people use the topic daily.
    location = '34.0499,-118.2408,200mi' # The location of LA
    long_time_ago="2016-01-01"
    until_timeline="2017-02-19"
    until_timeline_num <- strsplit(until_timeline, "\\-")[[1]]
    until_timeline_v <- unique(tolower(until_timeline_num))
    until_timeline_yr <- as.numeric(until_timeline_v[1])
    until_timeline_m <- as.numeric(until_timeline_v[2])
    until_timeline_d <- as.numeric(until_timeline_v[3])
    
    ratio_sentiment = list()
    tot_num_tweet = 0
    # It will look at whether the term that people (in a specific region) used is related to a negative or positive sentence on each day.
    days_week = 7
    for(i in 1:days_week){
      day_index = i + until_timeline_d
      begin_day_str = formatC(day_index, width=2, flag="0")
      until_d = paste("2017-02", begin_day_str, sep="-")
      print(until_d)
      tweets <- searchTwitter(input$topic, n=100, since=long_time_ago, until=until_d)
      if (length(tweets) != 0){
        tweets.matrix <- twListToDF(tweets)
        tweets_text <- sapply(tweets, function(x) x$getText())
        tweets_text_corpus <- Corpus(VectorSource(tweets_text))
        tweets_text_corpus <- tm_map(tweets_text_corpus, content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')), mc.cores=1)
        sentiment <- analyzeSentiment(tweets_text_corpus)
        # Find the ratio of the sentiment of each day
        ratio_sentiment <- c(ratio_sentiment, length(sentiment[,2][sentiment[,2]<0 & !is.na(sentiment[,2])]) , 
                             length(sentiment[,2][sentiment[,2]>0 & !is.na(sentiment[,2])]) ,  
                             length(sentiment[,2][sentiment[,2]==0 & !is.na(sentiment[,2])]) )
        tot_num_tweet = tot_num_tweet + length(tweets_text)
      } else {
        ratio_sentiment = c(ratio_sentiment, 0, 0, 0)
      }
    }
    ratio_sentiment_num <- as.numeric(unlist(ratio_sentiment))
  })
  
  output$piechart1 <- renderPlot({
    pie(ratio_sentiment_num()[1:3], main="Sentiment Pie Day 1", col=rainbow(3), labels=c("Negative", "Positive","Neutral"))
  })
  output$piechart2 <- renderPlot({
    pie(ratio_sentiment_num()[4:6], main="Sentiment Pie Day 2", col=rainbow(3), labels=c("Negative", "Positive","Neutral"))
  })
  
  output$piechart3 <- renderPlot({
    pie(ratio_sentiment_num()[7:9], main="Sentiment Pie Day 3", col=rainbow(3), labels=c("Negative", "Positive","Neutral"))
  })
  
  output$piechart4 <- renderPlot({
    pie(ratio_sentiment_num()[10:12], main="Sentiment Pie Day 4", col=rainbow(3), labels=c("Negative", "Positive","Neutral"))
  })
  
  output$piechart5 <- renderPlot({
    pie(ratio_sentiment_num()[13:15], main="Sentiment Pie Day 5", col=rainbow(3), labels=c("Negative", "Positive","Neutral"))
  })
  
  output$piechart6 <- renderPlot({
    pie(ratio_sentiment_num()[16:18], main="Sentiment Pie Day 6", col=rainbow(3), labels=c("Negative", "Positive","Neutral"))
  })
  
  output$piechart7 <- renderPlot({
    pie(ratio_sentiment_num()[19:21], main="Sentiment Pie Day 7", col=rainbow(3), labels=c("Negative", "Positive","Neutral"))
  })

})

