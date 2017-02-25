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
})
