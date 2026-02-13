# Read Data into R
# Soc 412/512, Winter 2026
# Aaron Gullickson

# Load libraries ----------------------------------------------------------

library(tidyverse)
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

# lets deal with IPUMS data
#SEX                          P  53              1     X       
#AGE                          P  54-56           3     X       
#MARST                        P  57              1     X       
#RACE                         P  58              1     X 

acs_data <- read_fwf("example_data/usa_00131.dat.gz",
                     col_positions = fwf_cols(sex = 53,
                                              age = c(54, 56),
                                              marst = 57,
                                              race = 58,
                                              cluster = c(24, 36)),
                     col_types = cols(.default = "i", cluster = "d"))

acs_data <- acs_data |>
  mutate(sex = case_when(
    sex == 1 ~ "Male",
    sex == 2 ~ "Female"
  ))

save(acs_data, file = "example_data/acs.RData")

# Read in binary data -----------------------------------------------------

load("example_data/acs.RData")

# excel format
read_excel("example_data/data.xlsx")

