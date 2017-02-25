
library(twitteR)
library(RCurl)
library(shiny)

pageWithSidebar(
  headerPanel('Creative Name'),
  sidebarPanel(
    textInput("topic","Please enter a topic",value="")
    ),
  mainPanel(
    plotOutput("wordcloud")
  )
)
