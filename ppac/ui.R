
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Pubmed Publication Authorship Comparison"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
        selectInput(inputId = "author1",
                    label="First Author",
                    choices = c("Gawande AA", "Carson BS", "Oz MC")),
        selectInput(inputId = "author2",
                    label="Second Author",
                    choices = c("Gawande AA", "Carson BS", "Oz MC")),
        actionButton(inputId = "search",
                     label = "Go!")
    ),

    # Show a plot of the generated distribution
    mainPanel(
        plotOutput("comparisonplot")
    )
  )
))
