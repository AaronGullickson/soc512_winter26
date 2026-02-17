# Week 7: Selecting, Filtering, and Recoding Data
# Soc 412/512, Winter 2026
# Aaron Gullickson

# Load libraries ----------------------------------------------------------

library(tidyverse)


# Read in ACS data --------------------------------------------------------

acs <- read_fwf("example_data/usa_00131.dat.gz",
                col_positions = fwf_cols(SEX     = c(53, 53),
                                         AGE     = c(54, 56),
                                         MARST   = c(57, 57),
                                         RACE    = c(58, 58),
                                         HISPAN  = c(62, 62),
                                         HCOVANY = c(66, 66),
                                         EDUCD   = c(69, 71),
                                         SEI     = c(72, 73)),
                col_types = cols(.default = "i"))


# Recode Data -------------------------------------------------------------

# mutate, case_when, and if_else are the workhorses here

# recode sex variable
acs <- acs |>
  mutate(sex = case_when(SEX == 1 ~ "Male",
                         SEX == 2 ~ "Female"),
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



# Filter, Select, and Save ------------------------------------------------

# filter will allow us to subset by observations


# select will allow us to subset by variables
acs <- acs |> 
  select(sex, educ)


# save the final analytical data
save(acs, file = "example_data/acs.RData")
