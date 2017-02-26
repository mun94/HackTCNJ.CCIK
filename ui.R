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
<<<<<<< HEAD
    #twitter handle, required if checkbox is checked
    textInput("lat", label = "latitude:", value = 40.75),
    textInput("long", label = "longitude:", value = -74),
    textInput("twitterHandle","Please enter your Twitter Handle",value="")
=======
    actionButton("submit", "Submit")
>>>>>>> dab5264f658407fd861f997ec55ac5c945be7ae3
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
<<<<<<< HEAD
    plotOutput("wordcloud"),
    plotOutput("map")
    #output histogram
=======
    #output histogram
    # plotOutput("histogram")
>>>>>>> dab5264f658407fd861f997ec55ac5c945be7ae3
    #output time series
    #output summary states
    #output geo heat maps
  )
)
