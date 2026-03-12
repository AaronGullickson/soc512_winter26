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
    stars = TRUE,
    fmt = 2,
    coef_map = c("(Intercept)" = "Intercept",
                 "genderFemale" = "Female",
                 "educationHS Diploma" = "HS diploma",
                 "educationAA Degree" = "AA degree",
                 "educationBachelors Degree" = "Bachelors degree",
                 "educationGraduate Degree" = "Graduate degree",
                 "age" = "Age",
                 "nchild" = "Number of children"),
    notes = "Standard error shown in parenthesis. Model 4 includes occupational grouping variable.",
    gof_map = c("nobs", "r.squared")
  )

# using predict to get counterfactual estimates
predict(model1, newdata = tibble(gender = c("Male", "Female"))) |>
  diff()

# make everyone men
earnings_cf_men <- earnings |>
  mutate(gender = "Male")

# make everyone women
earnings_cf_women <- earnings |>
  mutate(gender = "Female")

amm_men <- predict(model2, newdata = earnings_cf_men) |>
  mean()

amm_women <- predict(model2, newdata = earnings_cf_women) |>
  mean()

ame <- amm_women - amm_men
ame

coef(model2)["genderFemale"]

# education model
model_educ <- lm(wages ~ education, data = earnings)

cont <- matrix(0, 5, 4)
cont[col(cont)<row(cont)] <- 1
rownames(cont) <- c("LHS","HS","AA","BA","Grad")
colnames(cont) <- c("HS vs LHS", "AA vs HS", "BA vs AA", "Grad vs BA")

contrasts(earnings$education) <- cont
model_educ <- lm(wages ~ education, data = earnings)

model_interact <- lm(wages ~ education * gender, data = earnings)


