#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(DT)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  formula<- reactive({
    if(length(input$var1) == 0){
      f <- FALSE
    }
    else{
      f <- paste0("Fertility~",input$var1[1])
      if(length(input$var1)>1){
        for(i in 2:length(input$var1)){
          f <- paste(f,input$var1[i],sep = "+")
        }
      }
    }
    if(f!=FALSE)
      model <- lm(f, data = swiss)
  })
  predframe <- reactive({
    prediction <- predict(formula(), interval = "confidence")
    a <- data.frame( x = unname(swiss[input$var2]), Fertility = prediction[,1], lwr = prediction[,2], upr = prediction[,3])
    a
  })
  #tableCoeffs
  output$plot <- renderPlotly({
    q <- ggplot(data = swiss, aes(y = Fertility))
    q <- q + geom_point(aes_string(x = input$var2))
    if(input$confint && length(input$var1) > 0 ){
      predframe = predframe()
      q <- q + geom_ribbon(data=predframe,aes(ymin=lwr,ymax=upr, x = x),alpha=0.3) + geom_line(data=predframe,aes(y = Fertility, x = x),size = 1.5, colour = "lightblue") 
    }
    q
  })
  output$model <- renderTable({
    table <- signif(summary(formula())$coefficients, digits = 4)
    table <- cbind(rownames(table),table)
    table
  })
  output$datatable = DT::renderDataTable({
    swiss
  })
})
