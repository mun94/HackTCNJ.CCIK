
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

  shinyServer(function(input, output) {
    
    clean_corpus=function(topic,type,sample){
      if(type=="Corpus"){
      topic_tweets=searchTwitter(topic,lang="en",n=sample,resultType = "popular")
      topic_text=sapply(topic_tweets,function(x) x$getText())
      topic_text=str_replace_all(topic_text,"[^[:graph:]]", " ") 
      #tweets_text <- sapply(topic_tweets,function(row) iconv(row, "latin1", "ASCII", sub=""))
      topic_corpus=Corpus(VectorSource(topic_text))
      topic_corpus=tm_map(topic_corpus,removePunctuation)
      topic_corpus=tm_map(topic_corpus,content_transformer(tolower))
      topic_corpus=tm_map(topic_corpus,removeWords,stopwords("english"))
      topic_corpus=tm_map(topic_corpus,removeNumbers)
      topic_corpus=tm_map(topic_corpus,stripWhitespace)
      topic_corpus=tm_map(topic_corpus,removeWords,c(input$topic))
      return(topic_corpus)
      }
      else if(type=="Regular"){
        topic_tweets=searchTwitter(topic,lang="en",n=500,resultType = "popular")
        dataframe<-twListToDF(topic_tweets)
        return(dataframe)
      }
    }
    
    output$wordcloud <- renderPlot({
      wordcloud(clean_corpus(c(input$topic),"Corpus",500), scale=c(4,0.5), colors=brewer.pal(8, "Dark2"))
    })
    sentimentData <- renderPlot({
      tweets = regular_corpus(c(input$topic))
      tweets_text <- sapply(tweets, function(x) x$getText())
      tweets_text_corpus <- Corpus(VectorSource(tweets_text))
      tweets_text_corpus <- tm_map(tweets_text_corpus, content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')), mc.cores=1)
      sentiment <- analyzeSentiment(tweets_text_corpus)
    })
    output$histogram <- renderPlot({
      x <- faithful[,2] #insert sentiment data
      bins <- seq(min(x), max(x), length.out = 20)
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
    
    output$map=renderPlot({
      lat=c()
      long=c()
      a=c()
      lat[1]=as.numeric(input$lat)
      lat[2]=as.numeric(input$lat)-10
      lat[3]=as.numeric(input$lat)+10
      lat[4]=as.numeric(input$lat)
      lat[5]=as.numeric(input$lat)
      long[1]=as.numeric(input$long)
      long[2]=as.numeric(input$long)
      long[3]=as.numeric(input$long)
      long[4]=as.numeric(input$long)-10
      long[5]=as.numeric(input$long)+10
      for(i in 1:5){
        a[i]=mean(twListToDF(searchTwitter(input$topic,geocode =c(lat[i],long[i],'10mi'), resultType = "popular"))$retweetCount)
      }
      filled.contour(lat,lon,a)
    })

})

