# interactions
# SOC 412/512, Winter 2026

load("stat_data/earnings.RData")

model_interact <- lm(wages ~ gender*nchild, data = earnings)

model_men <- lm(wages ~ nchild, data = subset(earnings, gender == "Male"))
model_women <- lm(wages ~ nchild, data = subset(earnings, gender == "Female"))

# now add age as predictor
model_interact_age <- lm(wages ~ gender*nchild + age, data = earnings)

model_men_age <- lm(wages ~ nchild + age, data = subset(earnings, gender == "Male"))
model_women_age <- lm(wages ~ nchild + age, data = subset(earnings, gender == "Female"))


model_interact_everything <- lm(wages ~ gender*(nchild + age), data = earnings)
