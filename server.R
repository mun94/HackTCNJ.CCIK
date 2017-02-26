

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
    
 

})

