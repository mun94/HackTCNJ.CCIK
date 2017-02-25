library(twitteR)
library(RCurl)
library(shiny)
library(wordcloud)
library(tm)

shinyServer(function(input, output) {
  
  output$wordcloud <- renderPlot({
    topic_tweets=searchTwitter(c(input$topic),lang="en",n=500,resultType = "recent")
    him_corpus=corpus(VectorSource(topic_tweets))
    him_corpus=tm_map(him_corpus,removePunctuation)

  })
  
  output$histogram <- renderPlot({
    x <- faithful[,2] #insert sentiment data
    bins <- seq(min(x), max(x), length.out = 20)
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
    
  
})