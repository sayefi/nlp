#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(stringr)

source("predict_text.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
     
     rv <- reactiveValues()
     rv$setupComplete <- FALSE
     rv$words<-NULL
     
     
     observe({
          
          # if(input$btn_data){
               
               ## Simulate the data load
               # Sys.sleep(5)
               load("my_ngram1t4c_01_20_2018.Rdata")
               ## set my condition to TRUE
               rv$setupComplete <- TRUE
          # }
          
          ## the conditional panel reads this output
          output$setupComplete <- reactive({
               return(rv$setupComplete)
          })
          
          # outputOptions(output, 'setupComplete', suspendWhenHidden=FALSE)
     })
     
     # observeEvent(input$okButton,{
     #      output$typedTxt<-input$inputTxt
     # })
   
     # inputTxt<-reactive{
     #      inputTxt<-input$inTxt
     #      # output$typedTxt<-inputTxt
     # }
     # output$typedTxt<-input$inputTxt
     
     getWords<-reactive({
          inputTxt<-input$inTxt
          listWords<-NULL
          output$typedTxt<-renderText(paste("You Typed: ",inputTxt))
          
          if(length(grep("[a-z]* $",inputTxt,value=F))==1)
          {
               tokens<-getTokens(inputTxt)
               res<-predict_text_linear(tokens,lambda=c(0.5^8,0.5^4,0.5^2,0.5))
               # if(dim(res)[1]>1)
               # {
               listWords<-res$nextToken
               rv$words<-listWords
               # }

               # print(head(listWords,5))
          } else {

               partword<-word(inputTxt,-1)
               # print(paste("Partial word",partword))
               # print(head(rv$words,5))
               listWords<-grep(paste0("^",partword),rv$words,value=T)
               # print(head(listWords,5))
          }
          
          head(listWords,5)
          
     })
     
     
     
     output$nextToken<-renderTable(getWords(),colnames = FALSE)
     
     
     # observeEvent(input$inTxt,{
     #      inputTxt<-input$inTxt
     #      output$typedTxt<-renderText(paste("You Typed: ",inputTxt))
     #      
     #      if(length(grep("[a-z]* $",inputTxt,value=F))==1)
     #      {
     #           tokens<-getTokens(inputTxt)
     #           res<-predict_text_linear(tokens,lambda=c(0.5^8,0.5^4,0.5^2,0.5))
     #           if(dim(res)[1]>1)
     #           {
     #                listWords<-res$nextToken
     #           }
     #           
     #           print(head(listWords,5))
     #      } else {
     #           
     #           partword<-word(inputTxt,-1)
     #           print(paste("Partial word",partword))
     #           print(head(listWords,5))
     #           listWords<-grep(paste0("^",partword),listWords,value=T)
     #           print(head(listWords,5))
     #      }
     #      
     #      output$nextToken<-renderTable({
     #           head(listWords,5)
     #      })
     #      
     #      # output$nextToken<-renderText({
     #      #      head(listwords,5)
     #      #      })
     #      
     #      # output$nextToken<-renderPrint({
     #      #      
     #      #      head(listwords, 5) 
     #      #      printTxt=""
     #      #      for(i in 1:5)
     #      #           paste(printTxt,listwords[i], sep = "<br>")
     #      #      
     #      #      printTxt
     #      #      # })
     #      # })
     #      
     #      
     # })
     
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
