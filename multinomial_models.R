library(tidyverse)
library(nnet)
library(modelsummary)

load("example_data/wbreport.RData")

wbreport |>
  group_by(college) |>
  summarize(mean_age = mean(agectr))


wbreport |>
  group_by(foreign) |>
  summarize(prop_college = mean(college == "Yes"))

model_college <- multinom(racereport ~ college,
                          data = wbreport, trace = FALSE)

model_age <- update(model_college, .~. + agectr + agectrsq)

model_foreign <- update(model_age, .~. + foreign)

modelsummary(list(model_college, model_age, model_foreign),
             stars = TRUE, 
             shape = term + response ~ model)
