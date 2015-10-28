library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel(""),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
        selectInput(inputId = "author1",
                    label = "First Author",
                    choices = c("Gawande AA", "Oz MC", "Carson BS")),
        selectInput(inputId = "author2",
                    label = "Second Author",
                    choices = c("Gawande AA", "Oz MC", "Carson BS")),
        actionButton(inputId = "search",
                     label="Make it so ...")
        
    ),

    # Show a plot of the generated distribution
    mainPanel(
        plotOutput("comparison")
    )
  )
))
