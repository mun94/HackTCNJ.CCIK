

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
      topic_tweets=searchTwitter(topic,lang="en",n=sample,resultType = "recent")
      topic_text=sapply(topic_tweets,function(x) x$getText())
      topic_text=str_replace_all(topic_text,"[^[:graph:]]", " ") 
      #tweets_text <- sapply(topic_tweets,function(row) iconv(row, "latin1", "ASCII", sub=""))
      topic_corpus=Corpus(VectorSource(topic_text))
      topic_corpus=tm_map(topic_corpus,removePunctuation)
      topic_corpus=tm_map(topic_corpus,content_transformer(tolower))
      topic_corpus=tm_map(topic_corpus,removeWords,stopwords("english"))
      topic_corpus=tm_map(topic_corpus,removeNumbers)
      topic_corpus=tm_map(topic_corpus,stripWhitespace)
      topic_corpus=tm_map(topic_corpus,removeWords,c(topic))
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
   output$histogram <- renderPlot({
     tweets_text_corpus=clean_corpus(c(input$topic),"Corpus",500) 
     sentimentData <- analyzeSentiment(tweets_text_corpus)
     x <- sentimentData$SentimentGI #insert sentiment data
     hist(x, col = 'darkgray', border = 'white')
   })
    
 

})

