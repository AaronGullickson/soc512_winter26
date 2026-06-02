# Marginal effects and average adjusted predictions
# SOC 413/513
# May 28, 2026

load("stat_data/politics.RData")
library(marginaleffects)
library(tidyverse)
library(modelsummary)

tab <- table(politics$educ, politics$globalwarm)
prop.table(tab, 1)

model1 <- glm(globalwarm ~ educ, data = politics, 
              family = binomial) 

# predicted probabilities
df_predict <- tibble(educ = levels(politics$educ))
logit_pred <- predict(model1, newdata = df_predict)
odds_pred <- exp(logit_pred)
prob_pred <- odds_pred/(1 + odds_pred)
bind_cols(df_predict, prob = prob_pred)


# add covariates
model2 <- glm(globalwarm ~ educ + gender + age + I(age^2) + race + workstatus + party, 
              data = politics, family = binomial)
modelsummary(list(model1, model2), stars = TRUE)

# average adjusted probabilities
df_predict <- tibble(educ = levels(politics$educ),
                     gender = "Male",
                     age = mean(politics$age),
                     race = "White",
                     workstatus = "Working",
                     party = "Republican")
logit_pred <- predict(model2, newdata = df_predict)
odds_pred <- exp(logit_pred)
prob_pred <- odds_pred/(1 + odds_pred)
bind_cols(df_predict, prob = prob_pred)

# average predictions - counterfactual
politics_fake <- politics
politics_fake$educ <- "Less than HS"
logit_pred <- predict(model1, newdata = politics_fake)
odds_pred <- exp(logit_pred)
prob_pred <- odds_pred/(1 + odds_pred)
mean(prob_pred)

logit_pred <- predict(model2, newdata = politics_fake)
odds_pred <- exp(logit_pred)
prob_pred <- odds_pred/(1 + odds_pred)
app_lhs <- mean(prob_pred)

politics_fake <- politics
politics_fake$educ <- "Graduate degree"
logit_pred <- predict(model2, newdata = politics_fake)
odds_pred <- exp(logit_pred)
prob_pred <- odds_pred/(1 + odds_pred)
app_grad <- mean(prob_pred)

# average marginal effect (AME) between graduate and less than HS
app_grad - app_lhs

app <- avg_predictions(model1, variables = "educ") |>
  as_tibble() |>
  mutate(model = "unadjusted")

app <- avg_predictions(model2, variables = "educ") |>
  as_tibble() |>
  mutate(model = "adjusted") |>
  bind_rows(app)

ggplot(app, aes(x = educ, y = estimate, ymin = conf.low, ymax = conf.high,
                group = model, color = model, fill = model))+
  geom_ribbon(alpha = 0.5, color = NA)+
  geom_point()+
  geom_line()+
  labs(y = "prob. of belief in anthro climate change",
       x = "highest degree")+
  scale_y_continuous(labels = scales::percent)+
  theme_bw()

avg_slopes(model2, variables = "educ")


model1 <- glm(globalwarm ~ age + I(age^2), data = politics, 
              family = binomial) 
app <- avg_predictions(model1, variables = list(age = 18:90)) |>
  as_tibble() |>
  mutate(model = "unadjusted")

app <- avg_predictions(model2, variables = list(age = 18:90)) |>
  as_tibble() |>
  mutate(model = "adjusted") |>
  bind_rows(app)

ggplot(app, aes(x = age, y = estimate, ymin = conf.low, ymax = conf.high,
                group = model, color = model, fill = model))+
  geom_ribbon(alpha = 0.5, color = NA)+
  #geom_point()+
  geom_line(size = 1.25, alpha = 0.7)+
  labs(y = "prob. of belief in anthro climate change",
       x = "age")+
  scale_y_continuous(labels = scales::percent)+
  theme_bw()
