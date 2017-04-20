library(tidyverse)
library(babynames)
library(shiny)

shinyServer(function(input, output) {
  
  dat <- eventReactive(input$go, {
    
    name1 <-
      babynames %>%
      filter(name == input$name1) %>%
      filter(sex == input$sex)
    
    name2 <-
      babynames %>%
      filter(name == input$name2) %>%
      filter(sex == input$sex)
    
    list(name1,name2)
    
    
  })
  output$plot <- renderPlot({
    
    rbind(dat()[[1]], dat()[[2]]) %>%
      ggplot(aes(year, prop, group = name)) +
      geom_line(aes(col = name)) +
      xlab("Year") +
      ylab("Proportion of Population") +
      theme_minimal()
    
    
  })
  
  output$sumname1 <- DT::renderDataTable({
    
    dat()[[1]] %>%
      arrange(desc(prop)) %>%
      head(5)
    
  })
  
  output$sumname2 <- DT::renderDataTable({
    
    dat()[[2]] %>%
      arrange(desc(prop)) %>%
      head(5)
    
  })
  
})