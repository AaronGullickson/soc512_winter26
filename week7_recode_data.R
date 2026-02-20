# Week 7: Selecting, Filtering, and Recoding Data
# Soc 412/512, Winter 2026
# Aaron Gullickson

# Load libraries ----------------------------------------------------------

library(tidyverse)


# Read in ACS data --------------------------------------------------------

acs <- read_fwf("example_data/usa_00131.dat.gz",
                col_positions = fwf_cols(SEX     = 53,
                                         AGE     = c(54, 56),
                                         MARST   = 57,
                                         RACE    = 58,
                                         HISPAN  = 62,
                                         HCOVANY = 66,
                                         EDUCD   = c(69, 71),
                                         SEI     = c(72, 73)),
                col_types = cols(.default = "i"))


# Recode Data -------------------------------------------------------------

# mutate, case_when, and if_else are the workhorses here

# recode sex variable
acs <- acs |>
  mutate(sex = case_when(SEX == 1 ~ "Male", SEX == 2 ~ "Female"),
         sex = factor(sex))

# check yourself before you wreck yourself!
table(acs$SEX, acs$sex, exclude = NULL)

# code education
acs <- acs |>
  mutate(educ = case_when(EDUCD <= 1 | EDUCD == 999 ~ NA,
                          EDUCD <= 61 ~ "Less than HS",
                          EDUCD <= 65 ~ "HS Diploma",
                          EDUCD <= 100 ~ "Some College",
                          EDUCD <= 113 ~ "Bachelors",
                          EDUCD <= 116 ~ "Grad Degree"),
         educ = factor(educ, 
                       levels = c("Less than HS", "HS Diploma", "Some College",
                                  "Bachelors", "Grad Degree"))
    
  )

table(acs$EDUCD, acs$educ, exclude = NULL)


# encode missing values in SEI score using if_else
acs <- acs |>
  mutate(sei = if_else(SEI == 0, NA, SEI))

summary(acs$sei)

table(acs$SEI == 0, is.na(acs$sei), exclude = NULL)

# lets create 10 year age groups with cut

# just testing out side of mutate
#x <- cut(acs$AGE, 
#         right = FALSE,
#         breaks = seq(from = 0, to = 100, by = 5),
#         labels = paste(seq(from = 0, to = 95, by = 5), 
#                        seq(from = 4, to = 99, by = 5),
#                        sep = "-"))

acs <- acs |>
  mutate(
    age_group = cut(
      AGE, 
      right = FALSE,
      breaks = seq(from = 0, to = 100, by = 5),
      labels = paste(
        seq(from = 0, to = 95, by = 5), 
        seq(from = 4, to = 99, by = 5),
        sep = "-"
      )
    )
  )

table(acs$AGE, acs$age_group, exclude = NULL)

# Marital Status

acs <- acs |> 
  mutate(marst = case_when(MARST <= 2 ~ "Married",
                           MARST <= 4 ~ "Separated/Divorced",
                           MARST == 5 ~ "Widowed",
                           MARST == 6 ~ "Never Married"),
         marst = factor(marst, 
                        levels= c("Never Married", "Married",
                                  "Separated/Divorced", "Widowed")))

table(acs$MARST, acs$marst, exclude = NULL)

# Filter, Select, and Save ------------------------------------------------

# filter will allow us to subset by observations
# lets remove missing values on SEI
acs <- acs |>
  filter(!is.na(sei))

# select will allow us to subset by variables
acs <- acs |> 
  select(sex, educ, sei, age_group, marst)

# rename marst to mar_stat
acs <- acs |>
  rename(mar_stat = marst)

# save the final analytical data
save(acs, file = "example_data/acs.RData")


