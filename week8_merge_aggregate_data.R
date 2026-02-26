# Week 8: Merging and Aggregating Data
# Soc 412/512, Winter 2026
# Aaron Gullickson


# Load libraries ----------------------------------------------------------

library(tidyverse)


# Load data ---------------------------------------------------------------

# load world bank data
world_bank <- read_csv("example_data/world_bank.csv", 
                       n_max = 651, 
                       na = "..",
                       skip = 1, 
                       col_names = c("country_name", "country_code", 
                                     "series_name", "series_code", "year2018",
                                     "year2019"))

# load vdem data
vdem <- read_csv("example_data/V-Dem-CY-Full+Others-v13.csv.gz") |>
  select(country_name, country_text_id, year, v2x_libdem) |>
  filter(year == 2018 | year ==2019)

# load ACS data
acs <- read_fwf("example_data/usa_00131.dat.gz",
                col_positions = fwf_cols(STATEFIP = c(37, 38),
                                         SEX      = c(53, 53),
                                         AGE      = c(54, 56),
                                         HCOVANY  = c(66, 66),
                                         EDUCD    = c(69, 71)),
                col_types = cols(.default = "i")) |>
  mutate(
    sex = factor(SEX, levels = c(1, 2), labels = c("Male", "Female")),
    age = ifelse(AGE == 999, NA, AGE),
    health_ins = factor(HCOVANY, levels = c(1, 2), 
                        labels=c("Not covered", "Covered")),
    degree = factor(case_when(
      EDUCD <= 1 | EDUCD == 999 ~ NA, # Clean out missing values
      EDUCD < 62 ~ "LHS",
      EDUCD < 81 ~ "HS",
      EDUCD < 101 ~ "AA",
      EDUCD < 114 ~ "BA",
      TRUE ~ "Grad"),
      levels = c("LHS", "HS", "AA", "BA", "Grad")),
    state = factor(STATEFIP, 
                   levels = c(1, 2, 4, 5, 6, 8, 9, 10, 12, 13, 15, 16,
                              17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 
                              27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 
                              37, 38, 39, 40, 41, 42, 44, 45, 46, 47,
                              48, 49, 50, 51, 53, 54, 55, 56),
                   labels = state.name)) |>
  select(state, sex, age, health_ins, degree) |>
  filter(!is.na(state))

# Reshaping data ----------------------------------------------------------

# clean up annoying world bank structure
world_bank <- world_bank |>
  # clean up names and tidy
  mutate(series_code = case_when(
    series_code == "NY.GDP.MKTP.CD" ~ "gdp_capita",
    series_code == "SP.DYN.LE00.IN" ~ "life_exp",
    series_code == "EN.ATM.CO2E.PC" ~ "co2_capita"
  )) |>
  select(-series_name) |>
  # pivot longer to get country-year-variable rows
  pivot_longer(cols = starts_with("year"), names_to = "year",
               names_prefix = "year") |>
  mutate(year = as.numeric(year)) |>
  # now pivot wider to get back traditional long format of country-year
  pivot_wider(values_from = value, names_from = series_code)

# pivot wider to country format
world_bank <- world_bank |>
  pivot_wider(values_from = c(gdp_capita, life_exp, co2_capita),
              names_from = year, names_sep = ".")

# pivot back to long
world_bank <- world_bank |>
  pivot_longer(cols = ends_with("2018") | ends_with("2019"), 
               names_sep = "\\.",
               names_to = c(".value", "year")) |>
  mutate(year = as.numeric(year))



# Aggregating Data --------------------------------------------------------

cov_state_degree <- acs |>
  filter(!is.na(degree)) |>
  group_by(state, degree) |>
  summarize(p_covered = mean(health_ins == "Covered"),
            n = n(),
            .groups = "drop")



