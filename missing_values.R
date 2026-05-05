# Imputing Missing Values

library(mice)
library(tidyverse)
library(modelsummary)
library(survey)

load("stat_data/addhealth.RData")

imputation <- addhealth |>
  select(-c(cluster, sweight)) |>
  mice(m = 1)

addhealth_complete <- complete(imputation, 1) |>
  as_tibble()


imputations <- addhealth |>
  #select(-c(cluster, sweight)) |>
  mice(m = 5)

fit1 <- with(imputations, 
             lm(nominations ~ parent_income))
model1 <- pool(fit1)

fit2 <- with(imputations, 
            lm(nominations ~ parent_income + pseudo_gpa + 
                 gender + smoker))
model2 <- pool(fit2)



modelsummary(list(model1, model2),
             stars = TRUE)

design <- svydesign(id =~ cluster, weights =~ sweight, data = addhealth)
svyglm(nominations ~ parent_income, design = design)

b <- se <- NULL
for(i in 1:5) {
  
  design <- svydesign(id =~ cluster, weights =~ sweight, 
                      data = complete(imputations, i))
  model <- svyglm(nominations ~ parent_income + pseudo_gpa + 
                    gender + smoker, 
                  design = design)
  
  b <- cbind(b, coef(model))
  se <- cbind(se, summary(model)$coefficients[,2])
}

b.pool <- apply(b, 1, mean)
within.var <- apply(se^2, 1, mean)
between.var <- apply(b, 1, var)
se.pool <- sqrt(within.var + between.var + between.var / 5)

tibble(term = names(b.pool), estimate = b.pool, se = se.pool,
       tstat = estimate / se, pvalue = (1-pnorm(abs(tstat)))*2)

model <- lm(nominations ~ parent_income + pseudo_gpa + gender + smoker,
            data = complete(imputations, 1))
