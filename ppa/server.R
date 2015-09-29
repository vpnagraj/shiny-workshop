library(shiny)

shinyServer(function(input, output) {
    
    observeEvent(input$search, {
                 
    output$comparison <- renderPlot({

      library(rentrez)
      author <- input$author1
      myterm <- paste(author, "[Author]", sep="")
      
      
      q <- entrez_search("pubmed", myterm, retmax = 9999)
      q$ids
      q$count
      
      df <- data.frame(Author=author, Total.Publications = as.numeric(q$count))
      
      author2 <- input$author2
      myterm2 <- paste(author2, "[Author]", sep="")
      
      q2 <- entrez_search("pubmed", myterm2, retmax = 9999)
      
      df2 <- data.frame(Author=author2, Total.Publications = as.numeric(q2$count))
      
      combo_df <- rbind(df,df2)
      
      library(ggplot2)
      
      g <- 
          ggplot(combo_df, aes(x=Author, y=Total.Publications)) +
          geom_bar(stat = "identity") +
          ggtitle("Pubmed Publication Authorship Comparison")
      g
  })

})
})
