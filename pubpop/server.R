library(rentrez)
library(ggplot2)
library(shiny)

shinyServer(function(input, output) {

    dat <- eventReactive(input$go, {
        
        pubcount <- function(year, term) {
            
            query <- paste(term, "AND (", year, "[PDAT])")
            entrez_search(db = "pubmed", query)$count
            
        } 
        
        year <- 2006:2016
        
        pubs <- sapply(year, pubcount, term = input$term)
        
        dat <- data.frame(year, pubs)
        
    })
    
    output$yearplot <- renderPlot({

      ggplot(dat(), aes(year,pubs)) +
          geom_line()
      
  })
    
    output$yeartable <- DT::renderDataTable({
        
        dat()
        
    })
  
})
