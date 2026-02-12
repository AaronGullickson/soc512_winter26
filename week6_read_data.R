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


# Fixed width Files -------------------------------------------------------


read_fwf("example_data/data_fwf.txt", 
         col_positions = fwf_cols(name = c(1,5),
                                  location = c(6, 15),
                                  #race = c(16, 20),
                                  gender = c(21, 26),
                                  yrsed = c(27, 28)))
