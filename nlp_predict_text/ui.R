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
         actionButton("okButton","Enter"),
         tags$br(),
         tags$br(),
         em("Help"),
         helpText("Steps to use this app:"),
         helpText("1. Enter Name of your city (ie. Toronto)."),
         helpText("2. Press Enter."),
         helpText("3. Have fun...")
         
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       # conditionalPanel(condition = "!output.setupComplete",
       #                  box( title = "loading")),
       h3(textOutput("typedTxt")),
       plotOutput("distPlot")
    )
  )
))
