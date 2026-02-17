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


