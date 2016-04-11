library(readr)
library(dplyr)
library(ggplot2)
library(lubridate)

# read data from gh
moma <- read_csv("https://raw.githubusercontent.com/MuseumofModernArt/collection/master/Artworks.csv")

summary(moma)
str(moma)

# create subset of nworks by year
moma_by_year <-
    moma %>%
    filter(!is.na(DateAcquired)) %>%
    mutate(year.acquired = year(DateAcquired)) %>%
    group_by(year.acquired) %>%
    summarise(nworks = n())

# plot with ggplot
ggplot(moma_by_year, aes(year.acquired, nworks)) +
    geom_line(stat="identity")

# create subset of nworks by year for single department
moma_by_year <-
    moma %>%
    filter(!is.na(DateAcquired)) %>%
    filter(Department == "Painting & Sculpture") %>%
    mutate(year.acquired = year(DateAcquired)) %>%
    group_by(year.acquired) %>%
    summarise(nworks = n())

# plot with ggplot
ggplot(moma_by_year, aes(year.acquired, nworks)) +
    geom_line(stat="identity")

# save(moma, file = "moma.rda")
