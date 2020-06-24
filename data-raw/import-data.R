

# Packages ----------------------------------------------------------------

library(devtools)
library(tidyverse)
library(here)
library(readxl)
library(janitor)
library(sf)
library(scales)
library(tigris)
library(opencage)

load_all()


# SETTINGS ----------------------------------------------------------------

# Turn off scientific notation

options(scipen = 999)

# Define years so I can import all data

obtn_years <- c(2019:2020)

# MISC DATA ---------------------------------------------------------------

obtn_oregon_counties <- counties(state = "OR") %>%
  arrange(NAME) %>%
  pull(NAME)

use_data(obtn_oregon_counties,
         overwrite = TRUE)

# DATA BY COUNTY ----------------------------------------------------------


# * Median Income -----------------------------------------------------------

dk_import_median_income_data <- function(data_year) {
  read_excel(here("data-raw", str_glue("{data_year}-obtn-by-county.xlsx")),
             sheet = "Median Income") %>%
    clean_names() %>%
    mutate(geography = str_trim(geography)) %>%
    set_names(c("geography", "value")) %>%
    mutate(year = data_year) %>%
    drop_na(geography)
}



obtn_data_median_income <- map_df(obtn_years, dk_import_median_income_data)

use_data(obtn_data_median_income,
         overwrite = TRUE)


# * ALICE Data --------------------------------------------------------------

dk_import_alice_data <- function(data_year) {
  read_excel(here("data-raw", str_glue("{data_year}-obtn-by-county.xlsx")),
             sheet = "ALICE") %>%
    clean_names() %>%
    mutate(geography = str_trim(geography)) %>%
    pivot_longer(-geography,
                 names_to = "level") %>%
    mutate(level = case_when(
      level == "poverty_hh" ~ "Below Poverty Level",
      level == "alice_hh" ~ "Below ALICE Threshold",
      level == "above_alice_hh" ~ "Above ALICE Threshold"
    )) %>%
    mutate(level = factor(level, levels = c("Below Poverty Level", "Below ALICE Threshold", "Above ALICE Threshold"))) %>%
    mutate(level = fct_rev(level)) %>%
    mutate(value = value / 100) %>%
    mutate(year = data_year) %>%
    drop_na(geography)
}


obtn_alice_data <- dk_import_alice_data(2020)



use_data(obtn_alice_data,
         overwrite = TRUE)

# Thresholds


median_household_income_2016 <- read_excel(here("data-raw", "2016 Median Household Income.xlsx")) %>%
  clean_names() %>%
  set_names("geography", "median_income") %>%
  mutate(geography = str_remove(geography, " County, Oregon")) %>%
  filter(geography %in% obtn_oregon_counties)


obtn_alice_data_thresholds <- read_excel(here("data-raw", "alice-data-2016.xlsx"),
                                         sheet = "County") %>%
  clean_names() %>%
  select(us_county,
         alice_threshold_hh_under_65,
         alice_threshold_hh_65_years_and_over) %>%
  rename("geography" = "us_county") %>%
  left_join(median_household_income_2016, by = "geography")

use_data(obtn_alice_data_thresholds,
         overwrite = TRUE)

# * Economic Mobility -------------------------------------------------------


obtn_economic_mobility <- read_excel(here("data-raw", "Economic Mobility Data for Oregon Counties 2.10.20.xlsx"),
                                     range = "A1:D37") %>%
  clean_names() %>%
  rename("geography" = "name") %>%
  mutate(geography = str_remove(geography, " County, OR")) %>%
  mutate(geography = str_trim(geography)) %>%
  pivot_longer(-geography,
               names_to = "family_income_percentile") %>%
  mutate(family_income_percentile = case_when(
    str_detect(family_income_percentile, "75th") ~ "75th Percentile",
    str_detect(family_income_percentile, "50th") ~ "50th Percentile",
    str_detect(family_income_percentile, "25th") ~ "25th Percentile"
  )) %>%
  arrange(geography, family_income_percentile)

use_data(obtn_economic_mobility,
         overwrite = TRUE)





# * Race/Ethnicity ----------------------------------------------------------

race_ethnicity_order <- rev(c("White",
                              "Latino",
                              "African American",
                              "Asian",
                              "Am Indian/Alaska Native",
                              "Native Hawaiian/Pacific Islander",
                              "Multiracial",
                              "Other Race"))

dk_import_race_ethnicity_data <- function(data_year) {
  read_excel(here("data-raw", str_glue("{data_year}-obtn-by-county.xlsx")),
             sheet = "Race Ethnicity") %>%
    clean_names() %>%
    # filter(geography != "Rural") %>%
    # filter(geography != "Urban") %>%
    # filter(geography != "Oregon") %>%
    gather("population", "pct", -geography) %>%
    mutate(population = case_when(
      population == "percentage_of_population_white_non_latino" ~ "White",
      population == "percentage_of_population_black_non_latino" ~ "African American",
      population == "percentage_of_population_asian_non_latino" ~ "Asian",
      population == "percentage_of_population_american_indian_or_alaska_native_non_latino" ~ "Am Indian/Alaska Native",
      population == "percentage_of_population_native_hawaiian_pacific_islander_non_latino" ~ "Native Hawaiian/Pacific Islander",
      population == "percentage_of_population_multi_racial_non_latino" ~ "Multiracial",
      population == "percentage_of_population_other_race_non_latino" ~ "Other Race",
      population == "percentage_of_population_latino" ~ "Latino"
    )) %>%
    rename("value" = "pct") %>%
    mutate(year = data_year)
}

obtn_race_ethnicity <- map_df(obtn_years, dk_import_race_ethnicity_data) %>%
  group_by(population) %>%
  mutate(tertile_numeric = ntile(value, 3)) %>%
  mutate(tertile_numeric = as.numeric(tertile_numeric)) %>%
  ungroup() %>%
  mutate(tertile_text = case_when(
    tertile_numeric == 3 ~ "Top third",
    tertile_numeric == 2 ~ "Middle third",
    tertile_numeric == 1 ~ "Bottom third"
  )) %>%
  mutate(tertile_text = fct_rev(tertile_text))


use_data(obtn_race_ethnicity,
         overwrite = TRUE)


# * Employment Industries -------------------------------------------------

dk_import_employment_industries_data <- function(data_year) {
  read_excel(here("data-raw", str_glue("{data_year}-obtn-by-county.xlsx")),
             sheet = "Employment Industries") %>%
    clean_names() %>%
    mutate(geography = str_trim(geography)) %>%
    gather("ranking", "industry", -geography) %>%
    select(-ranking) %>%
    filter(geography %in% obtn_oregon_counties) %>%
    mutate(top_three_industry = "Y") %>%
    complete(geography, industry, fill = list(top_three_industry = "N")) %>%
    mutate(year = data_year)
}

obtn_top_employment_industries <- map_df(obtn_years, dk_import_employment_industries_data)

use_data(obtn_top_employment_industries,
         overwrite = TRUE)


# * Population Pyramid ----------------------------------------------------

age_order <- c("0-4",
               "5-9",
               "10-14",
               "15-19",
               "20-24",
               "25-29",
               "30-34",
               "35-39",
               "40-44",
               "45-49",
               "50-54",
               "55-59",
               "60-64",
               "65-69",
               "70-74",
               "75-79",
               "80-84",
               "85+")


dk_import_population_pyramid_data <- function(data_year) {
  read_excel(here("data-raw", str_glue("{data_year}-obtn-by-county.xlsx")),
             sheet = "Gender Age") %>%
    clean_names() %>%
    gather("age_gender", "pct", -geography) %>%
    # Add gender variable
    mutate(gender = case_when(
      str_detect(age_gender, "females") ~ "female",
      TRUE ~ "male"
    )) %>%
    mutate(age_gender = str_remove(age_gender, "females_")) %>%
    mutate(age_gender = str_remove(age_gender, "males_")) %>%
    mutate(age_gender = str_replace(age_gender, "_", "-")) %>%
    mutate(age_gender = str_replace(age_gender, "80-85", "80-84")) %>%
    mutate(age_gender = str_replace(age_gender, "85", "85+")) %>%
    # Since we've removed gender from the age_gender variable, let's rename it to age
    rename("age" = "age_gender") %>%
    # Just reorder to make things nice
    select(geography, age, gender, pct) %>%
    # If pct is less than .01 it won't show up in the final plot so anything that's less than .01 gets changed to .01
    mutate(pct = case_when(
      pct < .01 ~ .01,
      TRUE ~ pct
    )) %>%
    # Add padding to age_labels variables that are shorter so they also show up equal length
    mutate(age_labels = case_when(
      str_length(age) == 3 ~ str_pad(age, width = 7, side = "both", pad = " "),
      TRUE ~ age
    )) %>%
    # Make age a factor using the age_order vector above
    mutate(age = fct_relevel(age, age_order)) %>%
    mutate(pct_formatted = case_when(
      gender == "female" ~ -pct,
      gender == "male" ~ pct
    )) %>%
    rename("value" = "pct") %>%
    mutate(year = data_year)
}

obtn_population_pyramid <- map_df(obtn_years, dk_import_population_pyramid_data)


use_data(obtn_population_pyramid,
         overwrite = TRUE)


# * Total Population --------------------------------------------------------

dk_import_total_population_data <- function(data_year) {
  read_excel(here("data-raw", str_glue("{data_year}-obtn-by-county.xlsx")),
             sheet = "Total Population") %>%
    clean_names() %>%
    mutate(year = data_year)
}

obtn_total_population <- map_df(obtn_years, dk_import_total_population_data)

use_data(obtn_total_population,
         overwrite = TRUE)

# * Rural Population --------------------------------------------------------

dk_import_rural_population_data <- function(data_year) {
  read_excel(here("data-raw", str_glue("{data_year}-obtn-by-county.xlsx")),
             sheet = "Rural Population") %>%
    clean_names() %>%
    rename("value" = "percent_rural") %>%
    mutate(value = value / 100) %>%
    mutate(year = data_year)
}

obtn_rural_population <- map_df(obtn_years, dk_import_rural_population_data)

use_data(obtn_rural_population,
         overwrite = TRUE)


# * Net Migration --------------------------------------------------------

dk_import_net_migration_data <- function(data_year) {
  read_excel(here("data-raw", str_glue("{data_year}-obtn-by-county.xlsx")),
             sheet = "Net Migration") %>%
    clean_names() %>%
    mutate(year = data_year)
}

obtn_net_migration <- map_df(obtn_years, dk_import_net_migration_data)

use_data(obtn_net_migration,
         overwrite = TRUE)


# * Life Expectancy -------------------------------------------------------

dk_import_life_expectancy_data <- function(data_year) {
  read_excel(here("data-raw", str_glue("{data_year}-obtn-by-county.xlsx")),
             sheet = "Life Expectancy") %>%
    clean_names() %>%
    pivot_longer(-geography,
                 names_to = "gender") %>%
    mutate(gender = case_when(
      str_detect(gender, "_overall") ~ "Total",
      str_detect(gender, "_male") ~ "Men",
      str_detect(gender, "_female") ~ "Women"
    )) %>%
    mutate(year = data_year)
}

obtn_life_expectancy <- dk_import_life_expectancy_data(2020)

use_data(obtn_life_expectancy,
         overwrite = TRUE)


# * Total Land Area ---------------------------------------------------------

dk_import_total_land_area_data <- function(data_year) {
  read_excel(here("data-raw", str_glue("{data_year}-obtn-by-county.xlsx")),
             sheet = "Total Land Area") %>%
    clean_names() %>%
    mutate(year = data_year)
}

obtn_total_land_area <- map_df(obtn_years, dk_import_total_land_area_data)

use_data(obtn_total_land_area,
         overwrite = TRUE)



# * Public Land ---------------------------------------------------------

dk_import_public_land_area_data <- function(data_year) {
  read_excel(here("data-raw", str_glue("{data_year}-obtn-by-county.xlsx")),
             sheet = "Public Lands") %>%
    clean_names() %>%
    rename("value" = "publicly_owned_lands") %>%
    mutate(value = value / 100) %>%
    mutate(year = data_year)
}

obtn_public_land <- map_df(obtn_years, dk_import_public_land_area_data)

use_data(obtn_public_land,
         overwrite = TRUE)


# * Largest Community -------------------------------------------------------

dk_import_largest_community_data <- function(data_year) {
  read_excel(here("data-raw", str_glue("{data_year}-obtn-by-county.xlsx")),
             sheet = "Largest Community") %>%
    clean_names() %>%
    rename(community = largest_community) %>%
    oc_forward_df(placename = str_glue("{community}, Oregon")) %>%
    mutate(year = data_year)
}

obtn_largest_community <- map_df(obtn_years, dk_import_largest_community_data)

use_data(obtn_largest_community,
         overwrite = TRUE)

# DATA BY MEASURE ---------------------------------------------------------

# List available here https://docs.google.com/spreadsheets/d/1ScUMUtbFVwzbR2C9VbUr1JeAVDARz_8G6C71YgyAg9s/edit#gid=0

# * Data for Choropleth Maps ----------------------------------------------

dk_import_measure_data <- function(data_year) {

  # Create vector of all sheets to use later on

  sheets <- here("data-raw", str_glue("{data_year}-obtn-by-measure.xlsx")) %>%
    excel_sheets() %>%
    tibble() %>%
    set_names("sheet_name") %>%
    mutate(sheet_number = row_number()) %>%
    mutate(sheet_number = as.numeric(sheet_number))

  # Create categories that I'll use below

  social_measures_2019 <- c("Food Insecurity",
                            "Child Poverty",
                            "Child Abuse",
                            "Index Crime",
                            "Voter Participation")

  education_measures_2019 <- c("4yr Degree or Greater",
                               "2yr Degrees",
                               "Graduation Rate",
                               "Higher ed enrollment",
                               "Letter Sounds")

  economy_measures_2019 <- c("Unemployment Rate",
                             "LFPR",
                             "Job Growth",
                             "Property Tax per Person",
                             "Housing Cost Burden")

  health_measures_2019 <- c("Physically Active Adults",
                            "Adult Smoking",
                            "Healthy Diet",
                            "Vaccination Rate 2yr olds",
                            "Low Weight Births")

  infrastructure_measures_2019 <- c("Broadband Access",
                                    "Transit Service",
                                    "Vehicle Miles Traveled",
                                    "Developed or Cultivated Land",
                                    "Mobile Homes")

  community_measures_2020 <- c("Food Insecurity",
                               "Child Poverty",
                               "Foster Care",
                               "Index Crime",
                               "Voter Participation")

  education_measures_2020 <- c("4yr Degree or Greater",
                               "Graduation Rate",
                               "9th Grade on Track",
                               "3rd Grade ELA",
                               "Letter Sounds")

  economy_measures_2020 <- c("Unemployment Rate",
                             "LFPR",
                             "Job Growth",
                             "Property Tax per Person",
                             "Rent Costs")

  health_measures_2020 <- c("Tobacco Use",
                            "Good Mental Health",
                            "Good Physical Health",
                            "Vaccination Rate 2yr olds",
                            "Low Weight Births")


  infrastructure_measures_2020 <- c("Broadband Access",
                                    "Transit Service",
                                    "Vehicle Miles Traveled",
                                    "Childcare Availability",
                                    "Mobile Homes")

  other_measures <- c("Total Population",
                      "Rural Population",
                      "Net Migration",
                      "Median Income",
                      "Land Area",
                      "Public Lands",
                      "Life Expectancy - Overall",
                      "Above ALICE HH")


  # Create function to get one sheet of data

  dk_import_single_measure_data <- function(sheet_name) {
    read_excel(here("data-raw", str_glue("{data_year}-obtn-by-measure.xlsx")),
               sheet = sheet_name) %>%
      clean_names() %>%
      dplyr::select(county, numeric_only)
  }

  just_counties <- map_df(sheets$sheet_name, dk_import_single_measure_data,
                          .id = "sheet_number") %>%
    mutate(county = str_remove(county, "\\*")) %>%
    filter(county %in% obtn_oregon_counties) %>%
    mutate(year = data_year) %>%
    mutate(sheet_number = as.numeric(sheet_number)) %>%
    left_join(sheets, by = "sheet_number") %>%
    rename("value" = "numeric_only",
           "measure" = "sheet_name",
           "geography" = "county") %>%
    select(geography, measure, value, year) %>%
    mutate(geography = str_remove(geography, "\\*")) %>%
    mutate(geography = str_trim(geography)) %>%
    # Add 2019 categories
    mutate(category = case_when(
      measure %in% social_measures_2019 & year == 2019 ~ "Social",
      measure %in% education_measures_2019 & year == 2019 ~ "Education",
      measure %in% economy_measures_2019 & year == 2019 ~ "Economy",
      measure %in% health_measures_2019 & year == 2019 ~ "Health",
      measure %in% infrastructure_measures_2019 & year == 2019 ~ "Infrastructure",
      measure %in% community_measures_2020 & year == 2020 ~ "Community",
      measure %in% education_measures_2020 & year == 2020 ~ "Education",
      measure %in% economy_measures_2020 & year == 2020 ~ "Economy",
      measure %in% health_measures_2020 & year == 2020 ~ "Health",
      measure %in% infrastructure_measures_2020 & year == 2020 ~ "Infrastructure",
      measure %in% other_measures & year == 2020 ~ "Other",
    )) %>%
    # If a measure doesn't have a category it's because we're not making a choropleth with it so drop it
    drop_na(category) %>%
    # Tertile stuff
    group_by(measure) %>%
    mutate(tertile_numeric = ntile(value, 3)) %>%
    mutate(tertile_numeric = as.numeric(tertile_numeric)) %>%
    mutate(tertile_text = case_when(
      tertile_numeric == 3 ~ "Top third",
      tertile_numeric == 2 ~ "Middle third",
      tertile_numeric == 1 ~ "Bottom third"
    )) %>%
    ungroup() %>%
    # Add ID for all missing values
    mutate(tertile_text = replace_na(tertile_text, "ID")) %>%
    mutate(tertile_text = factor(tertile_text, levels = c("Top third",
                                                          "Middle third",
                                                          "Bottom third",
                                                          "No college",
                                                          "ID")))

  not_counties <- map_df(sheets$sheet_name, dk_import_single_measure_data,
                         .id = "sheet_number") %>%
    filter(county %in% c("Rural Oregon", "Oregon", "Urban Oregon")) %>%
    mutate(year = data_year) %>%
    mutate(sheet_number = as.numeric(sheet_number)) %>%
    left_join(sheets, by = "sheet_number") %>%
    rename("value" = "numeric_only",
           "measure" = "sheet_name",
           "geography" = "county") %>%
    select(geography, measure, value, year) %>%
    mutate(geography = str_remove(geography, "\\*")) %>%
    mutate(geography = str_trim(geography)) %>%
    # Add 2019 categories
    mutate(category = case_when(
      measure %in% social_measures_2019 & year == 2019 ~ "Social",
      measure %in% education_measures_2019 & year == 2019 ~ "Education",
      measure %in% economy_measures_2019 & year == 2019 ~ "Economy",
      measure %in% health_measures_2019 & year == 2019 ~ "Health",
      measure %in% infrastructure_measures_2019 & year == 2019 ~ "Infrastructure",
      measure %in% community_measures_2020 & year == 2020 ~ "Community",
      measure %in% education_measures_2020 & year == 2020 ~ "Education",
      measure %in% economy_measures_2020 & year == 2020 ~ "Economy",
      measure %in% health_measures_2020 & year == 2020 ~ "Health",
      measure %in% infrastructure_measures_2020 & year == 2020 ~ "Infrastructure",
    )) %>%
    # If a measure doesn't have a category it's because we're not making a choropleth with it so drop it
    drop_na(category)

  bind_rows(just_counties, not_counties)

}

obtn_data_by_measure <- map_df(obtn_years, dk_import_measure_data)

use_data(obtn_data_by_measure,
         overwrite = TRUE)


# Write out df of all measures

obtn_data_choropleth_measures <- obtn_data_by_measure %>%
  distinct(year, measure)

use_data(obtn_data_choropleth_measures,
         overwrite = TRUE)

# * Tribes ------------------------------------------------------------------

dk_import_tribes_data <- function(data_year) {

  read_excel(here("data-raw", str_glue("{data_year}-obtn-by-county.xlsx")),
             sheet = "Tribes") %>%
    clean_names() %>%
    pivot_longer(-geography,
                 names_to = "tribe",
                 values_to = "present") %>%
    drop_na(present) %>%
    mutate(present = "Y") %>%
    # complete(geography, tribe, fill = list(present = "N")) %>%
    mutate(year = data_year)

}

obtn_tribes <- map_df(obtn_years, dk_import_tribes_data)

use_data(obtn_tribes,
         overwrite = TRUE)




# GEOSPATIAL DATA ---------------------------------------------------------

obtn_boundaries_oregon_state <- states(cb = TRUE, class="sf") %>%
  clean_names() %>%
  filter(statefp == 41) %>%
  select(name) %>%
  rename("geography" = "name")


use_data(obtn_boundaries_oregon_state,
         overwrite = TRUE)

obtn_boundaries_oregon_counties <- counties(cb = TRUE, class="sf") %>%
  clean_names() %>%
  filter(statefp == 41) %>%
  select(name) %>%
  rename("geography" = "name")


use_data(obtn_boundaries_oregon_counties,
         overwrite = TRUE)



# COLORS ------------------------------------------------------------------

tfff_dark_green <- "#265142"
tfff_light_green <- "#B5CC8E"
tfff_orange <- "#e65100"
tfff_yellow <- "#FBC02D"
tfff_blue <- "#283593"
tfff_light_blue <- "#B3C0D6"
tfff_red <- "#B71C1C"
tfff_dark_gray <- "#545454"
tfff_medium_gray <- "#a8a8a8"
tfff_light_gray <- "#eeeeee"

use_data(tfff_dark_green,
         overwrite = TRUE)

use_data(tfff_light_green,
         overwrite = TRUE)

use_data(tfff_orange,
         overwrite = TRUE)

use_data(tfff_yellow,
         overwrite = TRUE)

use_data(tfff_blue,
         overwrite = TRUE)

use_data(tfff_light_blue,
         overwrite = TRUE)

use_data(tfff_red,
         overwrite = TRUE)

use_data(tfff_dark_gray,
         overwrite = TRUE)

use_data(tfff_medium_gray,
         overwrite = TRUE)

use_data(tfff_light_gray,
         overwrite = TRUE)

obtn_choropleth_colors <- rev(c("#dddddd",
                                "#B5CC8E",
                                "#6E8F68",
                                "#265142"))

use_data(obtn_choropleth_colors,
         overwrite = TRUE)
