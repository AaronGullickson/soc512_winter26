# Measuring Association 


# Setup --------------------------------------------------------------------

# load libraries
library(ggplot2)
library(wesanderson)

# Load some data
load("stat_data/titanic.RData")
load("stat_data/movies.RData")


# Fun with Two-Way Tables --------------------------------------------------

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
  #scale_fill_manual(values = c("royalblue1",
  #                             "tomato",
  #                             "palegoldenrod"))+
  #scale_fill_brewer(palette = "BuGn")+
  #scale_fill_viridis_d()+
  scale_fill_manual(values = wes_palette("Darjeeling1"))+
  theme_bw()

# odds ratios
tab

# first to second OR
(200*158)/(119*123)

# second to third OR 
(119*528)/(181*158)

# first to third OR
(200*528)/(181*123)

2.158912*2.197077
