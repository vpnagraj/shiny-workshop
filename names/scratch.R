# install.packages("babynames")
library(babynames)
# install.packages("tidyverse")
library(tidyverse)

babynames

babynames %>%
  View()

babynames %>%
  filter(name == "Ida")

babynames %>%
  filter(name == "Bert" | name == "Ernie") %>%
  filter(sex == "M")

babynames %>%
  filter(name == "Bert" | name == "Ernie") %>%
  filter(sex == "M") %>%
  ggplot(aes(year, prop, group = name)) +
  geom_line(aes(col = name)) 

babynames %>%
  filter(name == "Bert" | name == "Ernie") %>%
  filter(sex == "M") %>%
  ggplot(aes(year, prop, group = name)) +
  geom_line(aes(col = name)) +
  xlab("Year") +
  ylab("Proportion") +
  theme_minimal()
