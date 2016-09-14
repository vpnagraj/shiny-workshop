# install.packages("rentrez")

library(rentrez)

# install.packages("ggplot2")

library(ggplot2)

# install.packages("highcharter")

library(highcharter)

pubs <- entrez_search(db = "pubmed", term = "zika AND (2016[PDAT])", retmax = 9999)

pubs$count

pubcount <- function(year, term) {
    
    query <- paste(term, "AND (", year, "[PDAT])")
    entrez_search(db = "pubmed", query)$count
    
} 

pubcount(2016,"zika")
pubcount(1999, "ebola")

year <- 2006:2016
year

pubs <- sapply(year, pubcount, term = "zika")

pubs

dat <- data.frame(year, pubs)
View(dat)

ggplot(dat, aes(year,pubs)) +
    geom_line()

hchart(dat, "line", x = year, y = pubs)

foo <- 10
foo

bar <- foo * 2
bar

foo <- 40
foo

bar

bar <- foo * 2
bar
