####################
# Soc 412/512      #
# Tidyverse        #
# Week 3           #
# Winter 2026      #
# Aaron Gullickson #
####################

library(tidyverse)


# Using Tibbles -----------------------------------------------------------

my_df <- data.frame(
  name = c("Martha", "Bilbo", "Vern", "Geoffrey", "Wilma"),
  age = c(54, 111, 67, 14, 78),
  gender = c('Female', 'Male', 'Male', 'Male', 'Female'),
  like_soccer = c(FALSE, TRUE, TRUE, FALSE, FALSE)
)

