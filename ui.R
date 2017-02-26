library(twitteR)
library(RCurl)
library(shiny)

pageWithSidebar(
  headerPanel('Shoot For the Mun'),
  sidebarPanel(
    textInput("topic","Please enter a topic",value="HACKTCNJ"),
    checkboxInput("useRecent", "Use recent tweets?", value=TRUE),
    actionButton("submit", "Submit")
    ),
  mainPanel(
    tabsetPanel(
      tabPanel("Wordcloud",
               plotOutput("wordcloud")),
      tabPanel("Histogram",
               plotOutput("histogram")),
      tabPanel("Time Series",
             plotOutput("timeseries")),
      tabPanel("Time Series Pie Charts",
             plotOutput("piechart1"), plotOutput("piechart2"),
             plotOutput("piechart3"), plotOutput("piechart4"),
             plotOutput("piechart5"), plotOutput("piechart6"),
             plotOutput("piechart7"))
            
      )
  
    #output histogram
    # plotOutput("histogram")
    #output time series
    #output summary states
    #output geo heat maps
  )
)
