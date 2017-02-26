  # consumer_key = "xfOvD7jRSGqkjHVnbVBR7c6qb"
  # consumer_secret = "MWYPCFdNKw10q0bf2mVlDm5afLYy85rmyYyVDcG2b5yRUGM0Xn"
  # access_token = "3258902236-XBx1ysoykMewfgYmKyELLczrOzJopzPes1HO59X"
  # access_secret = "e2KZD5x3qyp6zMMYaYQjxydX04x7nKwXhnlSOEISMwQA3"
  # setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
  # 

  library(twitteR)
  library(RCurl)
  library(shiny)
  library(wordcloud)
  library(tm)
  library(stringr)
  
  shinyServer(function(input, output) {
    
    clean_corpus=function(topic){
      
      topic_tweets=searchTwitter(topic,lang="en",n=500,resultType = "recent")
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
    
    regular_corpus=function(topic){
      topic_tweets=searchTwitter(topic,lang="en",n=500,resultType = "recent")
      dataframe<-twListToDF(topic_tweets)
      return(dataframe)
    }
    
    output$wordcloud <- renderPlot({
      wordcloud(clean_corpus(c(input$topic)), colors=brewer.pal(8, "Dark2"))
    })
    
    output$histogram <- renderPlot({
      x <- faithful[,2] #insert sentiment data
      bins <- seq(min(x), max(x), length.out = 20)
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
})