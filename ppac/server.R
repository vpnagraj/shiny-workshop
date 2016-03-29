

library(shiny)

shinyServer(function(input, output) {

  observeEvent(input$search, {
  output$comparisonplot <- renderPlot({
      
      # install and load rentrez package
      # install.packages("rentrez)
      library(rentrez)
      
      # specify author
      author <- input$author1
      
      # build query string
      myterm <- paste(author, "[Author]", sep="")
      
      # run query
      q <- entrez_search("pubmed", myterm, retmax=9999)
      
      q$ids
      q$count
      
      # make a dataframe out of the author and count
      
      df <- data.frame(Author=author, Total.Publications = as.numeric(q$count))
      
      # specify author
      author2 <- input$author2
      
      # build query string
      myterm2 <- paste(author2, "[Author]", sep="")
      
      # run query
      q2 <- entrez_search("pubmed", myterm2, retmax=9999)
      
      df2 <- data.frame(Author=author2, Total.Publications = as.numeric(q2$count))
      
      combo_df <- rbind(df,df2)
      
      # load ggplot2
      library(ggplot2)
      
      # make a barplot
      
      g <-
          ggplot(combo_df, aes(x=Author,y=Total.Publications)) +
          geom_bar(stat="identity") +
          ggtitle("Pubmed Publication Authorship Comparison")
      
      g

  })

})

})
