
library(twitteR)
library(RCurl)
library(shiny)

pageWithSidebar(
  headerPanel('Creative Name'),
  sidebarPanel(
    textInput("topic","Please enter a topic",value=""),
    #friends/ generic
    checkboxInput("useFriends", "Display Information Regarding Friends?", FALSE),
    #dates
    dateRangeInput("dateRange",
                   label = "Date range input: yyyy-mm-dd",
                   start = Sys.Date() - 7, end = Sys.Date()
    ),
    #twitter handle, required if checkbox is checked
    textInput("twitterHandle","Please enter your Twitter Handle",value="")
    ),
  mainPanel(
    tabsetPanel(
      tabPanel("Summary"),
      tabPanel("Plot",
               # plotOutput("histogram")
        column(8, plotOutput("histogram")),
        column(12, plotOutput("histogram"))
        )
      )
    )
    # plotOutput("wordcloud")
    #output histogram
    # plotOutput("histogram")
    #output time series
    #output summary states
    #output geo heat maps
  )
)
