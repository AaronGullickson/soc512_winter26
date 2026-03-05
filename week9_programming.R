# Week 9: Programming
# Soc 412/512, Winter 2026
# Aaron Gullickson


# Load libraries ----------------------------------------------------------

library(tidyverse)
library(tictoc)


# Load data ---------------------------------------------------------------

tracts <- read_csv("example_data/R13598833_SL140.csv",
                   col_types = cols(.default = "i", 
                                    Geo_QName = "c",
                                    Geo_NAME = "c",
                                    Geo_STUSAB = "c",
                                    Geo_FIPS = "c")) |>
  mutate(pop_race_indigenous = SE_B04001_005 + SE_B04001_007,
         county_id = Geo_STATE * 1000 + Geo_COUNTY,
         county_name = str_remove(Geo_QName, paste0(Geo_NAME, ", ")),
         tract_id = as.numeric(Geo_FIPS)) |>
  rename(pop_total = SE_B04001_001,
         pop_race_white = SE_B04001_003,
         pop_race_black = SE_B04001_004,
         pop_race_asian = SE_B04001_006,
         pop_race_other = SE_B04001_008,
         pop_race_multi = SE_B04001_009,
         pop_race_latino = SE_B04001_010) |>
  select(tract_id, starts_with("county_"), starts_with("pop_")) |>
  filter(pop_total > 0)


# Example case ------------------------------------------------------------


# pick a test case
tracts_lane <- tracts |>
  filter(county_name == "Lane County, Oregon")

# start with denominator values
props <- tracts_lane |>
  select(starts_with("pop_race_")) |>
  colSums() |>
  prop.table()

entropy_county <- sum(props * log(1 / props))
pop_county <- sum(tracts_lane$pop_total)

# now the numerator
#tracts_lane |>
#  mutate(prop_race_white = pop_race_white / pop_total,
#         prop_race_black - prop_race_black / pop_total, 
#         ...,
#         entropy = prop_race_white * log(1 / prop_race_white) +
#           prop_race_black * log(1 / prop_race_black) + 
#           ...)

entropy_tracts <- tracts_lane |> 
  pivot_longer(cols = starts_with("pop_race_"), names_prefix = "pop_race_",
               names_to = "race", values_to = "pop_race") |>
  mutate(prop = pop_race / pop_total,
         e = prop * log(1 / prop)) |>
  group_by(tract_id) |>
  summarize(entropy_tract = sum(e, na.rm = TRUE), 
            pop_tract = sum(pop_race), 
            .groups = "drop")

theil_h <- 1 - sum(entropy_tracts$entropy_tract * entropy_tracts$pop_tract) /
  (entropy_county * pop_county)


# Create a function -------------------------------------------------------

calculate_theil_h <- function(tracts_county, round = FALSE) {
  
  # start with denominator values
  props <- tracts_county |>
    select(starts_with("pop_race_")) |>
    colSums() |>
    prop.table()
  
  entropy_county <- sum(props * log(1 / props), na.rm = TRUE)
  pop_county <- sum(tracts_county$pop_total)

  entropy_tracts <- tracts_county |> 
    pivot_longer(cols = starts_with("pop_race_"), names_prefix = "pop_race_",
                 names_to = "race", values_to = "pop_race") |>
    mutate(prop = pop_race / pop_total,
           e = prop * log(1 / prop)) |>
    group_by(tract_id) |>
    summarize(entropy_tract = sum(e, na.rm = TRUE), 
              pop_tract = sum(pop_race), 
              .groups = "drop")
  
  theil_h <- 1 - sum(entropy_tracts$entropy_tract * entropy_tracts$pop_tract) /
    (entropy_county * pop_county)
  
  if(round) {
    return(round(theil_h, 3))
  } else {
    return(theil_h)
  }
}

tracts |>
  filter(county_name == "Cook County, Illinois") |>
  calculate_theil_h()

tracts |>
  filter(county_name == "Travis County, Texas") |>
  calculate_theil_h()

tracts |>
  filter(county_name == "Multnomah County, Oregon") |>
  calculate_theil_h()

tracts |>
  filter(county_name == "Milwaukee County, Wisconsin") |>
  calculate_theil_h()

tracts |>
  filter(county_name == "Wayne County, Michigan") |>
  calculate_theil_h(round = TRUE)

tracts |>
  filter(county_name == "Bullock County, Alabama") |>
  calculate_theil_h()

# Iterate over counties ---------------------------------------------------

# try a for loop
county_names <- unique(tracts$county_name)

tic()
theil_h <- NULL
for(name in county_names) {
  x <- tracts |>
    filter(county_name == name) |>
    calculate_theil_h()
  theil_h <- c(theil_h, x)
}
toc()

theil_h <- tibble(county_name = county_names, theil_h)

# now map it
theil_h <- tracts |>
  group_by(county_name) |>
  group_split() |>
  map_dbl(calculate_theil_h)

tic()
theil_h <- tracts |>
  group_by(county_name) |>
  group_split() |>
  map(function(x) {
    tibble(
      county_id = unique(x$county_id),
      county_name = unique(x$county_name),
      theil_h = calculate_theil_h(x)
    )
  }) |>
  bind_rows()
toc()



            