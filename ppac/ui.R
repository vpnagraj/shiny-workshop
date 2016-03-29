dat <- read.csv("authors.csv", stringsAsFactors = FALSE)

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Pubmed Publication Authorship Comparison"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
        selectInput(inputId = "author1",
                    label="First Author",
                    choices = dat$search_name),
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
