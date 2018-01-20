#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
     
     rv <- reactiveValues()
     rv$setupComplete <- FALSE
     
     observe({
          
          # if(input$btn_data){
               
               ## Simulate the data load
               Sys.sleep(5)
               ## set my condition to TRUE
               rv$setupComplete <- TRUE
          # }
          
          ## the conditional panel reads this output
          output$setupComplete <- reactive({
               return(rv$setupComplete)
          })
          
          outputOptions(output, 'setupComplete', suspendWhenHidden=FALSE)
     })
     
     # observeEvent(input$okButton,{
     #      output$typedTxt<-input$inputTxt
     # })
   
     # inputTxt<-reactive{
     #      inputTxt<-input$inTxt
     #      # output$typedTxt<-inputTxt
     # }
     # output$typedTxt<-input$inputTxt
     
     observeEvent(input$inTxt,{
          inputTxt<-input$inTxt
          output$typedTxt<-renderText(paste("You Typed: ",inputTxt))
     })
     
  # output$distPlot <- renderPlot({
  #   
  #   # generate bins based on input$bins from ui.R
  #   x    <- faithful[, 2] 
  #   bins <- seq(min(x), max(x), length.out = input$bins + 1)
  #   
  #   # draw the histogram with the specified number of bins
  #   hist(x, breaks = bins, col = 'darkgray', border = 'white')
  #   
  # })
  
})
