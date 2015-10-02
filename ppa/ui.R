library(shiny)

authors <- read.csv("authors.csv",stringsAsFactors = FALSE)
author_vec <- authors$search_name
names(author_vec) <- authors$display_name

# names(authors$search_name) <- authors$display_name
shinyUI(fluidPage(

  # Application title
  titlePanel("Pubmed Publication Authorship"),

  sidebarLayout(
    sidebarPanel(
    selectInput(inputId = "author1",
                label = "First Author",
                choices = author_vec),   
      selectInput(inputId = "author2",
                label = "Second Author",
                choices = author_vec),
      actionButton(inputId = "search", label="Make it so ...")
  ),

    mainPanel(
      plotOutput("comparison")
    )
  )
))
