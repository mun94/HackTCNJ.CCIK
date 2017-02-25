  library(twitteR)
  library(RCurl)
  library(shiny)
  library(wordcloud)
  library(tm)
  
  shinyServer(function(input, output) {
    
    clean_corpus=function(topic){
      topic_tweets=searchTwitter(topic,lang="en",n=500,resultType = "recent")
      topic_text=sapply(topic_tweets,function(x) x$getText())
      #tweets_text <- sapply(topic_tweets,function(row) iconv(row, "latin1", "ASCII", sub=""))
      topic_corpus=Corpus(VectorSource(topic_text))
      topic_corpus=tm_map(topic_corpus,removePunctuation)
      topic_corpus=tm_map(topic_corpus,content_transformer(tolower))
      topic_corpus=tm_map(topic_corpus,removeWords,stopwords("english"))
      topic_corpus=tm_map(topic_corpus,removeNumbers)
      topic_corpus=tm_map(topic_corpus,stripWhitespace)
      return(topic_corpus)
    }
    
    output$wordcloud <- renderPlot({
      topic_tweets=searchTwitter(c(input$topic),lang="en",n=500,resultType = "recent")
      him_corpus=corpus(VectorSource(topic_tweets))
      him_corpus=tm_map(him_corpus,removePunctuation)
      
    })
})
