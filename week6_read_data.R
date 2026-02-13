# Read Data into R
# Soc 412/512, Winter 2026
# Aaron Gullickson

# Load libraries ----------------------------------------------------------

# the tidyverse will include readr package which is what we use for reading
# in csv and fwf text files. 
library(tidyverse)
# haven will give us the ability to read in data from a variety of stat
# packages like stata DTA files. readxl will allow us to read in excel files.
library(haven)
library(readxl)

# CSV Files ---------------------------------------------------------------

my_data <- read_csv("example_data/data.csv")

# sometimes you have to use extra arguments to clear out meta-information
# in the CSV
my_data <- read_csv("example_data/messy_data.csv", 
                    comment = "*", skip = 3)


# Fixed width Files -------------------------------------------------------

# the best fwf option is fwf_cols which allows you to intuitively specify
# starting and ending position of each variable
read_fwf("example_data/data_fwf.txt", 
         col_positions = fwf_cols(name = c(1,5),
                                  location = c(6, 15),
                                  #race = c(16, 20),
                                  gender = c(21, 26),
                                  yrsed = c(27, 28)))

# lets deal with IPUMS data - here is a snippet from the codebook of 
# variables I want
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
                     # we use col_types and the cols() command to 
                     # force all values to default to integer to deal with
                     # leading zeroes and then we specify a double for 
                     # cluster because its too big
                     col_types = cols(.default = "i", cluster = "d"))

# encode the sex variable and then save the data
acs_data <- acs_data |>
  mutate(sex = case_when(
    sex == 1 ~ "Male",
    sex == 2 ~ "Female"
  ))

# save the data with the save command - list all the objects you want and
# then specify the RData file path as an explicitly named argument. Remember to 
# use relative paths.
save(acs_data, file = "example_data/acs.RData")

# Read in binary data -----------------------------------------------------

# RData is a binary data type 
load("example_data/acs.RData")

# excel format  - we use the read_excel function from the readxl package
read_excel("example_data/data.xlsx")

