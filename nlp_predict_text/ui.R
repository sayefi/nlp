#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Predictive Texting using text mining and n-grams"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
         textInput("inTxt",
                   "Start typing here:",""),
         # actionButton("okButton","Enter"),
         em("Hint: Type a word and hit space to start prediction..."),
         checkboxInput("onWordCloud", label = "Show word cloud", value = FALSE),
         tags$br(),
         helpText("Text Predictions:"),
         tableOutput("nextToken")
         # ,

         # helpText("1. Enter Name of your city (ie. Toronto)."),
         # helpText("2. Press Enter."),
         # helpText("3. Have fun...")
         # 
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       # conditionalPanel(condition = "!output.setupComplete",
       #                  box( title = "loading")),
       # h3(textOutput("typedTxt")),
       plotOutput("distPlot")
       # tabsetPanel(
       #      tabPanel("Table",tableOutput("nextToken"))
       # ),
       # h3(printOutput("nextToken")),
       # shiny::dataTableOutput("nextToken"),
       

    )
  )
))
