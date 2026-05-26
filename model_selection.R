# Model Selection
# Soc 413/513, UO, Spring 2026


# Load stuff --------------------------------------------------------------

library(tidyverse)
library(broom)
library(BMA)
library(modelsummary)

load("stat_data/movies.RData")

model_null <- lm(rating_imdb ~ 1, data = movies)
model_full <- update(model_null, .~. + year + runtime + maturity_rating + genre)
model_noyear <- update(model_null, .~. + runtime + maturity_rating + genre)
model_runtime <- update(model_null, .~. + runtime)
model_interact <- update(model_full, .~. + runtime * maturity_rating)

modelsummary(list(model_null, model_runtime, model_noyear, model_full, model_interact),
             stars = TRUE, 
             gof_map = c("nobs", "r.squared", "adj.r.squared", "bic", "F"))

model_yearcat <- update(model_null, .~. + as.factor(year) + runtime + maturity_rating + genre)

model_runtimesq <- update(model_runtime, .~. + I(runtime^2))
model_runtimecubed <- update(model_runtimesq, .~. + I(runtime^3))

model_runtimesq2 <- update(model_runtimesq, .~. + genre)


modelsummary(list(model_runtime, model_runtimesq, model_runtimecubed,
                  model_runtimesq2),
             stars = TRUE, 
             fmt = 6,
             gof_map = c("nobs", "r.squared", "adj.r.squared", "bic", "F"))

movies$runtime_sq <- movies$runtime^2
movies$runtime_cubed <- movies$runtime^3

models_bma <- bic.glm(rating_imdb ~ year + runtime  + runtime_sq + runtime_cubed +
                        maturity_rating,
                      data = movies, glm.family = gaussian)
