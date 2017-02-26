library(twitteR)
library(RCurl)
library(shiny)

pageWithSidebar(
  headerPanel('Creative Name'),
  sidebarPanel(
    textInput("topic","Please enter a topic",value="HACKTCNJ"),
    #dates
    dateRangeInput("dateRange",
                   label = "Date range input: yyyy-mm-dd",
                   start = Sys.Date() - 7, end = Sys.Date()
    ),
    checkboxInput("useRecent", "Use recent tweets?", value=TRUE),
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
  
    #output histogram
    # plotOutput("histogram")
    #output time series
    #output summary states
    #output geo heat maps
  )
)
