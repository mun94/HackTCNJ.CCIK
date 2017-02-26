
library(twitteR)
library(RCurl)
library(shiny)
library(shinyIncubator)

pageWithSidebar(
  headerPanel('Creative Name'),
  sidebarPanel(
    textInput("topic","Please enter a topic",value=""),
    #dates
    dateRangeInput("dateRange",
                   label = "Date range input: yyyy-mm-dd",
                   start = Sys.Date() - 7, end = Sys.Date()
    ),
    actionButton("submit", "Submit")
    ),
  mainPanel(
    tabsetPanel(
      tabPanel("Summary Statistics"),
      tabPanel("Histogram",
               plotOutput("histogram")),
      tabPanel("Wordcloud",
             plotOutput("wordcloud"))
      )
    
    # plotOutput("wordcloud")
    # plotOutput("histogram")
    #output histogram
    # plotOutput("histogram")
    #output time series
    #output summary states
    #output geo heat maps
  )
)
