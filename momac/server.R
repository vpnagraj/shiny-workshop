library(shiny)
library(readr)
library(dplyr)
library(ggplot2)
library(lubridate)


moma <- read_csv("https://raw.githubusercontent.com/MuseumofModernArt/collection/master/Artworks.csv")

shinyServer(function(input, output) {
  
  dat <- reactive({
      
      moma_by_year <-
          moma %>%
          filter(!is.na(DateAcquired)) %>%
          filter(Department == input$department) %>%
          mutate(year.acquired = year(DateAcquired)) %>%
          group_by(year.acquired) %>%
          summarise(nworks = n())
      
  })
  
  output$yearplot <- renderPlot({

      ggplot(dat(), aes(year.acquired, nworks)) +
          geom_line(stat="identity")

  })
  
  output$yeartable <- renderDataTable({
      
        arrange(dat(), desc(nworks))
      
  })

})
