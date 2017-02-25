  library(twitteR)
  library(RCurl)
  library(shiny)
  library(wordcloud)
  library(tm)
  
  shinyServer(function(input, output) {
    
    clean_corpus=function(topic){
      topic_tweets=searchTwitter(topic,lang="en",n=500,resultType = "recent")
      topic_text=sapply(topic_tweets,function(x) x$getText())
<<<<<<< HEAD
=======
      topic_text=str_replace_all(topic_text,"[^[:graph:]]", " ") 
>>>>>>> 75d34d618f9c0862c139919c056ddd01cf733734
      #tweets_text <- sapply(topic_tweets,function(row) iconv(row, "latin1", "ASCII", sub=""))
      topic_corpus=Corpus(VectorSource(topic_text))
      topic_corpus=tm_map(topic_corpus,removePunctuation)
      topic_corpus=tm_map(topic_corpus,content_transformer(tolower))
      topic_corpus=tm_map(topic_corpus,removeWords,stopwords("english"))
      topic_corpus=tm_map(topic_corpus,removeNumbers)
      topic_corpus=tm_map(topic_corpus,stripWhitespace)
      return(topic_corpus)
    }
    
<<<<<<< HEAD
=======
    regular_corpus=function(topic){
      topic_tweets=searchTwitter(topic,lang="en",n=500,resultType = "recent")
      dataframe<-twListToDF(topic_tweets)
      return(dataframe)
    }
    
>>>>>>> 75d34d618f9c0862c139919c056ddd01cf733734
    output$wordcloud <- renderPlot({
      topic_tweets=searchTwitter(c(input$topic),lang="en",n=500,resultType = "recent")
      him_corpus=corpus(VectorSource(topic_tweets))
      him_corpus=tm_map(him_corpus,removePunctuation)
      
    })
<<<<<<< HEAD
=======
    
    output$histogram <- renderPlot({
      x <- faithful[,2] #insert sentiment data
      bins <- seq(min(x), max(x), length.out = 20)
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
>>>>>>> 75d34d618f9c0862c139919c056ddd01cf733734
})