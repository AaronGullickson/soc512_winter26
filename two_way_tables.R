# Fun with Two-Way Tables

# load libraries
library(ggplot2)

# Load some data
load("stat_data/titanic.RData")
load("stat_data/movies.RData")

# two way table survivorship and passenger class
tab <- table(titanic$pclass, titanic$survival)

# whoops forgot to specify row or column!
prop.table(tab)

prop.table(tab, 1)

ggplot(titanic, aes(x = survival, 
                    y = after_stat(prop), 
                    group = 1))+
  geom_bar()+
  facet_wrap(~pclass)+
  #facet_grid(sex~pclass)+
  labs(x = NULL, y = NULL)+
  scale_y_continuous(labels = scales::percent)+
  theme_bw()

ggplot(titanic, aes(x = survival, y = after_stat(prop),
                    group = pclass, fill = pclass))+
  geom_bar(position = "dodge")+
  labs(x = NULL, y = NULL, fill = "passenger\nclass")+
  scale_y_continuous(labels = scales::percent)+
  theme_bw()
