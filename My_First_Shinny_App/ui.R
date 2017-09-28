#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Swiss Fertility and Socioeconomic Indicators (1888) Data"),
  h2("Test your model!"),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      h4("Variables to include in linear regression model"),
      checkboxGroupInput("var1","Variables:",c("Males involved in Agriculture" = "Agriculture",
                                               "% of Draftees with the highest mark" = "Examination",
                                               "% of education beyond primary school" = "Education",
                                               "% of Catholic" = "Catholic",
                                               "% of Infant mortality" = "Infant.Mortality"
                                               ),
                         selected = "Agriculture"
                         ),
      h4("Select your independant variable for plotting"),
      radioButtons("var2","Variables:",c("Males involved in Agriculture" = "Agriculture",
                                         "% of Draftees with the highest mark" = "Examination",
                                         "% of education beyond primary school" = "Education",
                                         "% of Catholic" = "Catholic",
                                         "% of Infant mortality" = "Infant.Mortality"
                                         )
                   ),
      checkboxInput("confint","Plot prediction?",TRUE),
      submitButton("Submit")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h4("Swiss App"),
      h5("This simple app uses the Swiss Fertility and Socioeconomic Indicators data set from 1988. The user can use different covariants to determine the 
         best predictors for Fertility. Additionally Fertility can be plotted vs the predictor the user chooses. First select which variables to include, 
         afterwards select which variable should be plotted against fertility, and finally please submit your query by clicking the submit button.\n 
         Results from the predictions will be found at the bottom of this page bellow the plot"),
      tabsetPanel(type = "tabs",
        tabPanel("Results",
          plotlyOutput("plot"),
          tableOutput("model")
        ),
        tabPanel("Data",
          DT::dataTableOutput("datatable")
        )
      )
    )
  )
))
