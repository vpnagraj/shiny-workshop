# install and load reentrez package for pubmed query
# install.packages("rentrez")
library(rentrez)

# specify author
author <- "Gawande AA"

# build query string
myterm <- paste(author, "[Author]", sep="")

# run query
q <- entrez_search(db = "pubmed", myterm, retmax ="9999")

q$ids
q$count

# make a data frame out of the author and count
df <- data.frame(Author=author, Count=as.numeric(q$count))

# specify another author
author2 <- "Oz MC"

# build another query string
myterm2 <- paste(author2, "[Author]", sep="")

# another query
q2 <- entrez_search(db = "pubmed", myterm2, retmax ="9999")

q2$count

df2 <- data.frame(Author=author2, Count=as.numeric(q2$count))

combo_df <- rbind(df,df2)

library(ggplot2)

g <-
    ggplot(combo_df, aes(x=Author, y=Count)) +
    geom_bar(stat="identity") +
    ggtitle("Pubmed Publication Authorship Comparison")
g


