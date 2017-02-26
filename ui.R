library(twitteR)
library(RCurl)
library(shiny)

pageWithSidebar(
  headerPanel('Creative Name'),
  sidebarPanel(
    textInput("topic","Please enter a topic",value=""),
    #dates
    dateRangeInput("dateRange",
                   label = "Date range input: yyyy-mm-dd",
                   start = Sys.Date() - 7, end = Sys.Date()
    ),
    #twitter handle, required if checkbox is checked
    textInput("lat", label = "latitude:", value = 40.75),
    textInput("long", label = "longitude:", value = -74),
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
  
    #output time series
    #output summary states
    #output geo heat maps
  )
)
