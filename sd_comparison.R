library(tidyverse)

load("stat_data/movies.RData")

movies |>
  group_by(genre) |>
  summarise(mean = mean(runtime),
            sd = sd(runtime))
