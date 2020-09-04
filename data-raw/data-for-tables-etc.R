

# Packages ----------------------------------------------------------------

library(devtools)
library(tidyverse)
library(here)
library(readxl)
library(janitor)
library(sf)
library(scales)
library(tigris)
library(writexl)

load_all()


# Settings ----------------------------------------------------------------

obtn_year <- 2020


# Infographic Page Numbers ------------------------------------------------

total_population <- read_excel(here("data-raw", str_glue("{obtn_year}-obtn-by-county.xlsx")),
                               sheet = "Total Population") %>%
  clean_names()

rural_population <- read_excel(here("data-raw", str_glue("{obtn_year}-obtn-by-county.xlsx")),
                               sheet = "Rural Population") %>%
  clean_names()

net_migration <- read_excel(here("data-raw", str_glue("{obtn_year}-obtn-by-county.xlsx")),
                            sheet = "Net Migration") %>%
  clean_names()

developed_cultivated_land <- read_excel(here("data-raw", str_glue("{obtn_year}-obtn-by-measure.xlsx")),
                                        sheet = "Developed or Cultivated Land") %>%
  clean_names() %>%
  select(county, numeric_only) %>%
  rename(pct_developed_cultivated_land = numeric_only,
         geography = county)

net_migration %>%
  left_join(total_population) %>%
  rename(total_population = population) %>%
  left_join(rural_population) %>%
  left_join(developed_cultivated_land) %>%
  mutate(net_migration = number(net_migration, 1)) %>%
  mutate(total_population = comma(total_population)) %>%
  mutate(percent_rural = percent(percent_rural / 100)) %>%
  mutate(pct_developed_cultivated_land = percent((pct_developed_cultivated_land / 100),
                                                 1)) %>%
  filter(geography %in% obtn_oregon_counties) %>%
  select(geography, total_population, percent_rural, net_migration, pct_developed_cultivated_land) %>%
  write_xlsx(here("data-raw", "table-data", "big-numbers.xlsx"))

# Top Employment Industries -----------------------------------------------

obtn_top_employment_industries %>%
  filter(year == obtn_year) %>%
  filter(top_three_industry == "Y") %>%
  select(geography, industry) %>%
  rename(county = geography) %>%
  write_xlsx(here("data-raw", "table-data", "top-industries.xlsx"))


obtn_top_employment_industries %>%
  filter(year == obtn_year) %>%
  filter(top_three_industry == "Y") %>%
  select(geography, industry) %>%
  rename(county = geography) %>%
  count(industry)


# County Table Pages ------------------------------------------------------

community_measures_2020 <- c("Food Insecurity",
                             "Child Poverty",
                             "Foster Care",
                             "Index Crime",
                             "Voter Participation")

education_measures_2020 <- c("Letter Sounds",
                             "3rd Grade ELA",
                             "9th Grade on Track",
                             "Graduation Rate",
                             "4yr Degree or Greater")

economy_measures_2020 <- c("Unemployment Rate",
                           "LFPR",
                           "Job Growth",
                           "Property Tax per Person",
                           "Rent Costs")

health_measures_2020 <- c("Low Weight Births",
                          "Vaccination Rate 2yr olds",
                          "Good Physical Health",
                          "Good Mental Health",
                          "Tobacco Use")


infrastructure_measures_2020 <- c("Broadband Access",
                                  "Childcare Availability",
                                  "Transit Service",
                                  "Mobile Homes",
                                  "VMT per capita")

measures <- c(community_measures_2020,
              education_measures_2020,
              economy_measures_2020,
              health_measures_2020,
              infrastructure_measures_2020)

table_data <- obtn_data_by_measure %>%
  filter(year == obtn_year) %>%
  mutate(category = factor(category, levels = c("Community",
                                                "Education",
                                                "Economy",
                                                "Health",
                                                "Infrastructure"))) %>%
  mutate(measure = factor(measure, levels = measures)) %>%
  arrange(geography, category, measure) %>%
  mutate(value = case_when(
    measure %in% c("Food Insecurity",
                   "Child Poverty",
                   "Voter Participation",
                   "4yr Degree or Greater",
                   "Graduation Rate",
                   "9th Grade on Track",
                   "3rd Grade ELA",
                   "Unemployment Rate",
                   "LFPR",
                   "Tobacco Use",
                   "Good Mental Health",
                   "Good Physical Health",
                   "Vaccination Rate 2yr olds",
                   "Low Weight Births",
                   "Broadband Access",
                   "Transit Service",
                   "Mobile Homes") ~ percent(value / 100),
    measure %in% c("Foster Care",
                   "Index Crime",
                   "Letter Sounds",
                   "Job Growth",
                   "VMT per capita",
                   "Childcare Availability") ~ comma(value),
    measure %in% c("Property Tax per Person",
                   "Rent Costs") ~ dollar(value, 1)
  )) %>%
  select(geography:value) %>%
  drop_na(measure) %>%
  view()

# health_measures_not_counties <- table_data %>%
#   filter(measure %in% health_measures_2020) %>%
#   filter(geography %in% c("Oregon", "Rural Oregon", "Urban Oregon")) %>%
#   pivot_wider(id_cols = measure,
#               names_from = geography,
#               values_from = value)
#
# table_data %>%
#   filter(measure %in% health_measures_2020) %>%
#   filter(geography %in% obtn_oregon_counties) %>%
#   left_join(health_measures_not_counties, by = "measure") %>%
#   write_xlsx(here("data-raw", "table-data", "table-data-health-measures.xlsx"))


table_data_not_counties <- table_data %>%
  filter(geography %in% c("Rural Oregon", "Oregon", "Urban Oregon")) %>%
  pivot_wider(id_cols = measure,
              names_from = geography,
              values_from = value)

table_data %>%
  filter(geography %in% obtn_oregon_counties) %>%
  left_join(table_data_not_counties) %>%
  rename(County = value) %>%
  mutate(measure = case_when(
    measure == "Child Poverty" ~ "Child poverty*",
    measure == "Foster Care" ~ "Foster care rate (per 1,000 pop.)",
    measure == "Index Crime" ~ "Index crime (per 1,000 pop.)",
    measure == "Letter Sounds" ~ "Kindergarten readiness",
    measure == "3rd Grade ELA" ~ "3rd grade reading",
    measure == "Graduation Rate" ~ "5-year high school graduation rate",
    measure == "4yr Degree or Greater" ~ "4-year degree or greater",
    measure == "LFPR" ~ "Labor force participation rate",
    measure == "Job Growth" ~ "Job growth (per 1,000 pop.)",
    measure == "Property Tax per Person" ~ "Property tax (per person)",
    measure == "Rent Costs" ~ "Rent costs (1 bedroom/1 bath)",
    measure == "Vaccination Rate 2yr olds" ~ "Vaccination rate, 2 year olds",
    measure == "Childcare Availability" ~ "Child care (slots per 100 children)",
    measure == "Letter Sounds" ~ "Kidergarten ready (Letter sound)",
    measure == "VMT per capita" ~ "Vehicle Miles Traveled (per capita)",
    TRUE ~ str_to_sentence(measure)
  )) %>%
  # view()
  write_xlsx(here("data-raw", "table-data", "table-data-counties.xlsx"))


# Infrastructure Measures - Updated Order ---------------------------------

table_data %>%
  filter(geography %in% obtn_oregon_counties) %>%
  left_join(table_data_not_counties) %>%
  rename(County = value) %>%
  filter(measure %in% infrastructure_measures_2020) %>%
  mutate(measure = case_when(
    measure == "Child Poverty" ~ "Child poverty*",
    measure == "Foster Care" ~ "Foster care rate (per 1,000 pop.)",
    measure == "Index Crime" ~ "Index crime (per 1,000 pop.)",
    measure == "Letter Sounds" ~ "Kindergarten readiness",
    measure == "3rd Grade ELA" ~ "3rd grade reading",
    measure == "Graduation Rate" ~ "5-year high school graduation rate",
    measure == "4yr Degree or Greater" ~ "4-year degree or greater",
    measure == "LFPR" ~ "Labor force participation rate",
    measure == "Job Growth" ~ "Job growth (per 1,000 pop.)",
    measure == "Property Tax per Person" ~ "Property tax (per person)",
    measure == "Rent Costs" ~ "Rent costs (1 bedroom/1 bath)",
    measure == "Vaccination Rate 2yr olds" ~ "Vaccination rate, 2 year olds",
    measure == "Childcare Availability" ~ "Child care (slots per 100 children)",
    measure == "Letter Sounds" ~ "Kidergarten ready (Letter sound)",
    measure == "VMT per capita" ~ "Vehicle Miles Traveled (per capita)",
    TRUE ~ str_to_sentence(measure)
  )) %>%
  view()
  write_xlsx(here("data-raw", "table-data", "table-data-infrastructure.xlsx"))


# Vehicle Miles Traveled --------------------------------------------------

table_data %>%
  filter(geography %in% obtn_oregon_counties) %>%
  left_join(table_data_not_counties) %>%
  rename(County = value) %>%
  filter(measure %in% infrastructure_measures_2020)

obtn_data_by_measure %>%
  filter(measure == "VMT per capita") %>%
  filter(year == 2020) %>%
  arrange(desc(value)) %>%
  mutate(value = comma(value, 1)) %>%
  select(geography, value) %>%
  write_xlsx(here("data-raw", "table-data", "table-data-vmt-per-capita.xlsx"))


# Kindergarten Readiness --------------------------------------------------

obtn_data_by_measure %>%
  filter(measure == "Letter Sounds") %>%
  filter(year == 2020) %>%
  arrange(desc(value)) %>%
  mutate(value = round_half_up(value, 1)) %>%
  mutate(value = number(value, 0.1)) %>%
  select(geography, value) %>%
  set_names("county", "value") %>%
  write_xlsx(here("data-raw", "table-data", "letter-sounds.xlsx"))

# Life Expectancy ---------------------------------------------------------

obtn_life_expectancy %>%
  filter(gender != "Total") %>%
  filter(year == 2020) %>%
  view()
filter(geography %in% obtn_oregon_counties) %>%
  select(-year) %>%
  mutate(value = number(value, 1)) %>%
  pivot_wider(id_cols = geography,
              names_from = gender,
              values_from = value) %>%
  select(geography, Women, Men) %>%
  rename(County = geography) %>%
  write_xlsx(here("data-raw", "table-data", "life-expectancy-by-gender.xlsx"))


# Land Area ---------------------------------------------------------------

obtn_total_land_area %>%
  filter(year == 2020) %>%
  mutate(land_area = round_half_up(land_area)) %>%
  arrange(desc(land_area)) %>%
  write_xlsx(here("data-raw", "table-data", "land-area.xlsx"))


# Developed or Cultivated Land --------------------------------------------

obtn_data_by_measure %>%
  filter(year == 2020) %>%
  filter(measure == "Developed or Cultivated Land") %>%
  mutate(land_area = round_half_up(land_area)) %>%
  arrange(desc(land_area)) %>%
  write_xlsx(here("data-raw", "table-data", "land-area.xlsx"))


# Tribes ------------------------------------------------------------------

obtn_tribes %>%
  filter(year == 2020) %>%
  select(-year) %>%
  mutate(tribe = str_to_upper(tribe)) %>%
  mutate(geography = factor(geography, levels = obtn_oregon_counties)) %>%
  complete(geography, tribe) %>%
  rename(county = geography) %>%
  pivot_wider(id_cols = county,
              names_from = "tribe",
              values_from = "present") %>%
  write_xlsx(here("data-raw", "table-data", "tribe-icon-data.xlsx"))
