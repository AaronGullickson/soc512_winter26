# Read Data into R
# Soc 412/512, Winter 2026
# Aaron Gullickson

# Load libraries ----------------------------------------------------------

library(readr)
library(haven)
library(readxl)

# CSV Files ---------------------------------------------------------------

my_data <- read_csv("example_data/data.csv")

my_data <- read_csv("example_data/messy_data.csv", 
                    comment = "*", skip = 3)

