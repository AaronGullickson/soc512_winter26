# categorical variables in models
# SOC 412/512, Winter 2026

load("stat_data/earnings.RData")
library(tidyverse)
library(modelsummary)

model1 <- lm(wages ~ gender, data = earnings)
summary(model1)

earnings |>
  group_by(gender) |>
  summarize(mean_wages = mean(wages)) |>
  pivot_wider(values_from = mean_wages, names_from = gender) |>
  mutate(wage_gap = Female - Male)

model2 <- update(model1, .~. + education)

earnings |>
  group_by(gender, education) |>
  count() |>
  ungroup() |>
  group_by(gender) |>
  mutate(prop = n / sum(n)) |>
  ggplot(aes(x = gender, y = prop, 
             fill = fct_rev(education)))+
  geom_col()+
  scale_fill_viridis_d()

model3 <- update(model2, .~. + age + nchild)
model4 <- update(model3, .~. + occup)

list(model1, model2, model3, model4) |>
  modelsummary(
    #stars = c(":)" = 0.05),
    stars = TRUE
  )


