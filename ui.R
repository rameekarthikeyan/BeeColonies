library(shiny)
library(plotly)
shinyUI(fluidPage(
  titlePanel("App for summarizing percentage of Honey Bee colonies lost per quarter"),
  tabsetPanel(
    tabPanel("Introduction",
      strong("Documentation"),
      br(),
      em("Description:"),
      p("This is a simple app which summarizes the percentage of Honey Bee Colonies lost per quarter through out USA for the year 2016. It also provides additional information of the highest loss happened in that quarter and the state where it happened."),
      em("Data:"),
      a("https://www.nass.usda.gov/Surveys/Guide_to_NASS_Surveys/Bee_and_Honey/"),
      p("The data is taken from the USDA website (above) for the period of January 1, 2015 to March 2016."),
      em("How it works:"),
      p("Data is downloaded and stored in local directory and then it is loaded to R. Subset of the data is identified by user inputs of quarter."),
      em("Instructions for using the app:"),
      p("Click the tab 'Honey Bee Colonies Lost'. Initially when the app is loaded, map is rendered after a few minutes. Click 'play' button to have the animation displayed or slide to select the quarter. Once the map for the selected quarter is rendered, hover over the states to get their respective percentages.")),
      tabPanel("Honey Bee Colonies Lost",
      sidebarLayout(
      sidebarPanel(
      sliderInput("slider1", label = strong("Slide to select the quarter"), min = 1 , max = 5,value= 1, step = 1, animate = animationOptions(interval = 5000, loop = FALSE, playButton = NULL, pauseButton = NULL))
            ),
      mainPanel(
      h5("Average percentage of honey bee colonies lost this quarter across USA"),
      verbatimTextOutput("otext1"),
      h5("Highest percentage of honey bee colonies lost this quarter is in state"),
      verbatimTextOutput("otext2"),
     
      
      plotlyOutput("plotmap")
      
      )))
    )
  )
)