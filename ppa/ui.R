
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Pubmed Publication Authorship"),

  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "author1",
                  label = "First Author",
                  choices = c("Gawande AA",
                              "Oz MC",
                              "Kevorkian J")),
      selectInput(inputId = "author2",
                label = "Second Author",
                choices = c("Gawande AA",
                            "Oz MC",
                            "Kevorkian J")),
      actionButton(inputId = "search", label="Make it so ...")
  ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("comparison")
    )
  )
))
