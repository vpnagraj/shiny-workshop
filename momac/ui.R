library(shiny)
library(shinythemes)
library(readr)
library(dplyr)
library(ggplot2)
library(lubridate)

moma <- read_csv("https://raw.githubusercontent.com/MuseumofModernArt/collection/master/Artworks.csv")

shinyUI(fluidPage(theme = shinytheme("flatly"),

  # Application title
  titlePanel("MOMA Collections By Year"),

  sidebarLayout(
    sidebarPanel(
        selectInput("department", label = "Department", choices = unique(moma$Department))
    ),
    mainPanel(
        plotOutput("yearplot"),
        dataTableOutput("yeartable")
    )
  )
))
