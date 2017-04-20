library(shiny)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("flatly"), 
                  
                  titlePanel("NAMES"),
                  
                  sidebarLayout(
                    sidebarPanel(
                      textInput(inputId = "name1", label = "Name 1"),
                      textInput(inputId = "name2", label = "Name 2"),
                      radioButtons(inputId = "sex", label = "Sex", choices = c("M", "F")),
                      actionButton("go", "Submit")
                    ),
                    
                    mainPanel(
                      plotOutput("plot")
                    )
                  ),
                  fluidRow(
                    column(4, DT::dataTableOutput("sumname1")),
                    column(4, DT::dataTableOutput("sumname2"), offset = 2)
                  )
))