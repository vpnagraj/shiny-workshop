library(shiny)
library(shinythemes)
search_terms <- read.csv("pmsearchterms.csv", stringsAsFactors = FALSE, row.names = NULL)

shinyUI(fluidPage( theme = shinytheme('flatly'),

  # Application title
  titlePanel("PUBPOP"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
        # textInput("term", label = "pubmed search term", value = ""),
        selectInput("term", label = "pubmed search term", choices = search_terms$term),
        actionButton("go", label = "search pubmed")
    ),

    # Show a plot of the generated distribution
    mainPanel(
        plotOutput("yearplot"),
        DT::dataTableOutput("yeartable")
    )
  )
))
