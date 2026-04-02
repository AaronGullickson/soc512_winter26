# nonlinearity
# SOC 513, Spring 2026

library(tidyverse)
library(broom)

load("stat_data/politics.RData")
load("stat_data/popularity.RData")
load("stat_data/crimes.RData")

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
