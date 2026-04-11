# nonlinearity
# SOC 513, Spring 2026

library(tidyverse)
library(broom)
library(modelsummary)
library(marginaleffects)

load("stat_data/politics.RData")
load("stat_data/popularity.RData")
load("stat_data/crimes.RData")
load("stat_data/earnings.RData")

# look for some linear relationships

ggplot(crimes, aes(x = poverty_rate, y = property_rate))+
  geom_point()+
  geom_smooth(method = "lm", se = FALSE)+
  geom_smooth(se = FALSE, color = "red")+
  geom_smooth(se = FALSE, span = 1, color = "darkgreen")+
  theme_bw()

model <- lm(property_rate ~ poverty_rate, data = crimes)
augment(model)

ggplot(augment(model), 
       aes(x = .fitted, y = .resid))+
  geom_point()+
  geom_hline(yintercept = 0, linetype = 2)+
  geom_smooth(se = FALSE)+
  geom_smooth(method = "lm", se = FALSE, color = "red")+
  theme_bw()

# log some stuff!

model1 <- lm(log(wages) ~ gender, data = earnings)
model2 <- lm(log(wages) ~ gender * education, data = earnings)
#model2 <- update(model1, . ~ . + age + nchild)
#model3 <- update(model2, . ~ . + education)
#model4 <- update(model2, . ~ . + gender*education)

modelsummary(list(model1, model2),
             stars = TRUE,
             gof_map = c("r.squared", "nobs"))

model1_linear <- lm(wages ~ gender, data = earnings)
model2_linear <- lm(wages ~ gender * education, data = earnings)

modelsummary(list(model1_linear, model2_linear), 
             stars = TRUE)


model_age <- lm(wages ~ I(age - 40) + I((age-40)^2), data = earnings)
model_age2 <- lm(wages ~ age + I(age^2), data = earnings)
model_age3 <- lm(wages ~ poly(age, 2), data = earnings)

wages_predict <- predict(model_age, newdata = data.frame(age = 18:65))
ggplot(tibble(age = 18:65, wages = wages_predict),
       aes(x = age, y = wages))+
  geom_line()+
  scale_y_continuous(labels = scales::dollar)+
  theme_bw()


coefs <- coef(model_age)

marginal_effects <- coefs[2] + 2 * coefs[3] * (18:65 - 40)

ggplot(earnings, aes(x = age, y = wages))+
  geom_jitter(alpha = 0.01)+
  geom_smooth(method = "lm", se = FALSE,
              formula = "y ~ I(x)+I(x^2)")+
  geom_smooth(method = "lm", se = FALSE, color = "red")+
  theme_bw()

marginal_effect <- slopes(model_age, variables = "age", by = "age") |>
  as_tibble()

avg_slopes(model_age, variables = "age")


mean(coefs[2] + 2 * coefs[3] * (earnings$age - 40))

# Splines

earnings <- earnings |>
  mutate(spline_age30 = ifelse(age < 30, 0, age - 30),
         spline_age35 = ifelse(age < 35, 0, age - 35),
         spline_age40 = ifelse(age < 40, 0, age - 40),
         spline_age45 = ifelse(age < 45, 0, age - 45))

model_spline30 <- lm(wages ~ age + spline_age30, data = earnings)
model_spline35 <- lm(wages ~ age + spline_age35, data = earnings)
model_spline40 <- lm(wages ~ age + spline_age40, data = earnings)
model_spline45 <- lm(wages ~ age + spline_age45, data = earnings)
model_all_the_splines <- lm(wages ~ age + spline_age30 + spline_age35 + 
                              spline_age40 + spline_age45, data = earnings)


modelsummary(list(model_spline30, model_spline35, 
                  model_spline40, model_spline45,
                  model_all_the_splines),
             stars = TRUE,
             gof_map = c("r.squared", "nobs"))


fake_df <- tibble(
  age = 18:65,
  spline_age30 = ifelse(age < 30, 0, age - 30),
  spline_age35 = ifelse(age < 35, 0, age - 35),
  spline_age40 = ifelse(age < 40, 0, age - 40),
  spline_age45 = ifelse(age < 45, 0, age - 45)
) |>
  mutate(wages_spline30 = predict(model_spline30, newdata = fake_df),
         wages_spline35 = predict(model_spline35, newdata = fake_df),
         wages_spline40 = predict(model_spline40, newdata = fake_df),
         wages_spline45 = predict(model_spline45, newdata = fake_df),
         wages_all = predict(model_all_the_splines, newdata = fake_df))

ggplot(earnings, aes(x = age, y = wages))+
  geom_jitter(alpha = 0.01)+
  #geom_line(data = fake_df, aes(y = wages_spline30), 
  #          color = "cyan", linewidth = 1)+
  geom_line(data = fake_df, aes(y = wages_spline35), 
            color = "wheat", linewidth = 1)+
  #geom_line(data = fake_df, aes(y = wages_spline40), 
  #          color = "tomato", linewidth = 1)+
  #geom_line(data = fake_df, aes(y = wages_spline45), 
  #          color = "navy", linewidth = 1)+
  geom_line(data = fake_df, aes(y = wages_all), 
            color = "pink", linewidth = 1)+
  geom_vline(xintercept = c(30, 35, 40, 45), linetype =2,
             color = "red")+
  theme_bw()


earnings <- earnings |>
  mutate(age_grp = cut(age, 
                       breaks = c(18, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65),
                       right = FALSE))

model_age_grp <- lm(wages ~ age_grp, data = earnings)

fake_df <- tibble(
  age = c(18 + 0.5, 20 + 2, 25 + 2, 30 + 2, 35 + 2, 40 + 2, 45 + 2, 50 + 2, 55 + 2, 60 + 2),
  age_grp = cut(age, 
                breaks = c(18, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65),
                right = FALSE)
) 

fake_df <- fake_df |>
  mutate(wages = predict(model_age_grp, newdata = fake_df))

ggplot(earnings, aes(x = age, y = wages))+
  geom_jitter(alpha = 0.05)+
  geom_line(data = fake_df, color = "navy", linewidth = 1)+
  geom_point(data = fake_df, color = "navy", size = 2)+
  theme_bw()
