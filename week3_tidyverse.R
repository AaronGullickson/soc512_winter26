####################
# Soc 412/512      #
# Tidyverse        #
# Week 3           #
# Winter 2026      #
# Aaron Gullickson #
####################


# Load libraries and data -------------------------------------------------

library(tidyverse)
load("stat_data/earnings.RData")



# Using Tibbles -----------------------------------------------------------

my_df <- data.frame(
  name = c("Martha", "Bilbo", "Vern", "Geoffrey", "Wilma"),
  age = c(54, 111, 67, NA, 78),
  gender = c('Female', 'Male', 'Male', 'Male', 'Female'),
  like_soccer = c(FALSE, TRUE, TRUE, FALSE, FALSE)
)

my_tibble <- tibble(
  name = c("Martha", "Bilbo", "Vern", "Geoffrey", "Wilma"),
  age = c(54, 111, 67, NA, 78),
  gender = c('Female', 'Male', 'Male', 'Male', 'Female'),
  like_soccer = c(FALSE, TRUE, TRUE, FALSE, FALSE)
)

as_tibble(my_df)

earnings

# glimpsing your data with base data.frame
head(earnings)
tail(earnings)

# Piping ------------------------------------------------------------------

# tidyverse syntax for piping
# %>%

# base R syntax for piping
# |>

# vector of numbers
# log naturale each value in the vector
# sum up logged values
# round to two decimal places

round(sum(log(c(39, 42, 23, 17, 81, 144))), 2)

x <- c(39, 42, 23, 17, 81, 144)
logx <- log(x)
sum_logx <- sum(logx)
round(sum_logx, 2)


final_result <- c(39, 42, 23, 17, 81, 144) |> 
  # first we log the values
  log() |>
  # then we sum them all up
  sum() |>
  # then we round to 2 digits
  round(digits = 2)


# Real data cleaning example ----------------------------------------------

# Get mean wages by gender, race, and whether respondent has children

# create has_children variable
earnings$has_children <- earnings$nchild>0

# subset earnings to those under 45 years of age and just the variables 
# we want
earnings_sub <- subset(earnings, age<45, 
                       select=c("wages", "gender", "race", "has_children"))

# calculate mean earnings by gender, race, and children status
earnings_agg <- aggregate(wages~gender+race+has_children, data=earnings_sub, mean)

# reorder the aggregate earnings from lowest to highest wage
earnings_agg <- earnings_agg[order(earnings_agg$wages),]

