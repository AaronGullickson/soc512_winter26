#########################
# Measuring Association 

# Setup --------------------------------------------------------------------

# load libraries
library(tidyverse)
library(wesanderson)

# Load some data
load("stat_data/titanic.RData")
load("stat_data/movies.RData")
load("stat_data/politics.RData")

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


# Mean Differences --------------------------------------------------------

# movie runtime by genre
tapply(movies$runtime, movies$genre, mean)
tapply(movies$runtime, movies$genre, median)

# use group_by and summarize with piping
movies_agg <- movies |>
  group_by(genre) |>
  # summarize can calculate multiple summary stats 
  summarize(runtime_mean = mean(runtime),
            runtime_median = median(runtime),
            runtime_sd = sd(runtime),
            received_award = mean(awards > 0)) |>
  # arrange orders results by a variable
  arrange(received_award)
movies_agg

# calculate a standard comparative boxplot
ggplot(movies, 
       aes(x = reorder(genre, runtime, median),
           y = runtime))+
  geom_boxplot(fill = "skyblue", 
               outlier.color = "red")+
  coord_flip()+
  labs(x = NULL, y = "movie runtime (minutes)")+
  theme_bw()

# a violin plot is the same but replace geom_boxplot with geom_violin
ggplot(movies, 
       aes(x = reorder(genre, runtime, median),
           y = runtime))+
  geom_violin(fill = "skyblue")+
  coord_flip()+
  labs(x = NULL, y = "movie runtime (minutes)")+
  theme_bw()

# you can plot conditional means from the aggregated data but use lollipops
# not bars
ggplot(movies_agg, 
       aes(x = reorder(genre, runtime_mean, mean),
           y = runtime_mean))+
  geom_point()+
  geom_segment(aes(yend = runtime_mean, y = 0))+
  #geom_col()+
  coord_flip()+
  labs(x = NULL, y = "movie runtime (minutes)")+
  theme_bw()

# you can combine boxplot and violins, order matters!
ggplot(movies, 
       aes(x = reorder(maturity_rating, runtime, median),
           y = runtime))+
  geom_boxplot()+
  geom_violin(fill = "skyblue", alpha = 0.3)+
  coord_flip()+
  labs(x = NULL, y = "movie runtime (minutes)")+
  theme_bw()

# sometimes it might be useful to plot individual points with semi-transparency
# over a boxplot
ggplot(movies, 
       aes(x = reorder(maturity_rating, runtime, median),
           y = runtime))+
  geom_boxplot()+
  geom_jitter(alpha = 0.05)+
  coord_flip()+
  labs(x = NULL, y = "movie runtime (minutes)")+
  theme_bw()
