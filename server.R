library(twitteR)
library(RCurl)
library(shiny)
library(wordcloud)
library(tm)

shinyServer(function(input, output) {
  
  clean_corpus=function(topic){
    topic_tweets=searchTwitter(topic,lang="en",n=500,resultType = "recent")
    topic_corpus=Corpus(VectorSource(topic_tweets))
    topic_corpus=tm_map(topic_corpus,removePunctuation)
    topic_corpus=tm_map(topic_corpus,content_transformer(tolower))
    topic_corpus=tm_map(topic_corpus,removewords,stopwords("english"))
    topic_corpus=tm_map(topic_corpus,removeNumbers)
    topic_corpus=tm_map(topic_corpus,stripWhitespace)
    return(topic_corpus)
  }
  
  output$wordcloud <- renderPlot({
    topic_tweets=searchTwitter(c(input$topic),lang="en",n=500,resultType = "recent")
    him_corpus=corpus(VectorSource(topic_tweets))
    him_corpus=tm_map(him_corpus,removePunctuation)
    him_corpus=tm_map(him_corpus,removeNumbers)
    him_corpus
  })
})