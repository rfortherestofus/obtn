library(tidyverse)
library(readxl)
library(here)
library(janitor)

fpl_2016 <- 24300

median_household_income_2016 <- read_excel(here("data-raw", "2016 Median Household Income.xlsx")) %>%
  clean_names() %>%
  set_names("geography", "median_income") %>%
  mutate(geography = str_remove(geography, " County, Oregon")) %>%
  filter(geography %in% obtn_oregon_counties)


obtn_alice_data_thresholds <- read_excel(here("data-raw", "alice-data-2016.xlsx"),
                                         sheet = "County") %>%
  clean_names() %>%
  select(us_county, alice_threshold_hh_under_65) %>%
  set_names("geography", "alice_threshold") %>%
  left_join(median_household_income_2016, by = "geography")

obtn_alice_data_thresholds_summary_v2 <- obtn_alice_data_thresholds %>%
  mutate(fpl = fpl_2016) %>%
  dplyr::mutate(gap = median_income - alice_threshold) %>%
  mutate(gap_label = case_when(
    gap > 0 ~ str_glue("+{scales::dollar(gap)}"),
    gap < 0 ~ scales::dollar(gap)
  )) %>%
  dplyr::mutate(label_placement_x = alice_threshold + (gap / 2)) %>%
  dplyr::mutate(label_placement_y = dplyr::case_when(
    # gap > 0 ~ 1.1,
    gap < 0 ~ gap / 40000
  )) %>%
  dplyr::mutate(label_placement_y = 1 + label_placement_y - 0.1) %>%
  dplyr::mutate(fpl_mhi_gap = median_income - fpl) %>%
  dplyr::mutate(fpl_mhi_gap = scales::dollar(fpl_mhi_gap)) %>%
  dplyr::mutate(fpl_alice_gap = alice_threshold - fpl) %>%
  dplyr::mutate(fpl_alice_gap = scales::dollar(fpl_alice_gap)) %>%
  dplyr::filter(geography %in% c("Baker", "Benton", "Clackamas", "Clatsop"))



ggplot() +
  geom_hline(yintercept = 1,
             color = tfff_light_gray) +
  geom_curve(data = obtn_alice_data_thresholds_summary_v2,
             aes(x = fpl,
                 xend = median_income,
                 y = 1,
                 yend = 1),
             curvature = -1,
             size = 1.5,
             color = tfff_yellow) +
  geom_curve(data = obtn_alice_data_thresholds_summary_v2,
             aes(x = fpl,
                 xend = alice_threshold,
                 y = 1,
                 yend = 1),
             curvature = -1,
             size = 1.5,
             color = tfff_light_green) +
  geom_curve(data = obtn_alice_data_thresholds_summary_v2,
             aes(x = median_income,
                 xend = alice_threshold,
                 y = 1,
                 yend = 1),
             curvature = 1,
             color = tfff_dark_green) +
  geom_point(data = obtn_alice_data_thresholds_summary_v2,
             aes(x = fpl,
                 y = 1),
             shape = 21,
             size = 3,
             stroke = 1.5,
             fill = "white",
             color = tfff_blue) +
  geom_point(data = obtn_alice_data_thresholds_summary_v2,
             aes(x = median_income,
                 y = 1),
             shape = 21,
             size = 3,
             stroke = 1.5,
             fill = "white",
             color = tfff_yellow) +
  geom_point(data = obtn_alice_data_thresholds_summary_v2,
             aes(x = alice_threshold,
                 y = 1),
             shape = 21,
             size = 3,
             stroke = 1.5,
             fill = "white",
             color = tfff_light_green) +
  ggplot2::theme_minimal(base_size = 14,
                         base_family = "Calibri") +
  ggplot2::theme(
    panel.grid.minor.y = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_blank(),
    panel.grid.minor.x = ggplot2::element_blank(),
    panel.grid.major.x = ggplot2::element_line(color = tfff_light_gray),
    axis.text.y = ggplot2::element_blank(),
    axis.text.x = ggplot2::element_text(color = tfff_medium_gray,
                                        size = 9),
    axis.title = ggplot2::element_blank(),
    legend.position = "none",
    strip.text = element_text(face = "bold"),
    panel.spacing = unit(2, "lines"),
    plot.title = ggtext::element_markdown(),
    plot.subtitle = ggtext::element_markdown()
  ) +
  ggplot2::scale_x_continuous(labels = scales::dollar_format(scale = 0.001,
                                                             suffix = "K"),
                              limits = c(22500, 75000),
                              breaks = seq(25000, 75000, by = 25000),
                              expand = expansion(add = c(0, 10000))) +
  ggplot2::scale_y_continuous(limits = c(-0.4,
                                         5.5)) +
  facet_wrap(~geography,
             ncol = 2,
             scale = "free_x") +
  geom_text(data = filter(obtn_alice_data_thresholds_summary_v2, gap > 0),
            aes(x = median_income,
                y = 1.5,
                label = gap_label),
            hjust = -0.1,
            family = "Calibri") +
  geom_text(data = filter(obtn_alice_data_thresholds_summary_v2, gap < 0),
            aes(x = label_placement_x,
                y = label_placement_y,
                label = gap_label),
            vjust = 2.5,
            family = "Calibri")

library(tidyverse)
library(janitor)
library(scales)

obtn_alice_data %>%
  filter(year == 2020) %>%
  select(-year) %>%
  pivot_wider(id_cols = geography,
              names_from = level,
              values_from = value) %>%
  clean_names() %>%
  mutate(below_alice_and_poverty = below_poverty_level + below_alice_threshold) %>%
  select(geography, below_alice_and_poverty, above_alice_threshold) %>%
  filter(geography %in% obtn_oregon_counties) %>%
  mutate(below_alice_and_poverty = percent(below_alice_and_poverty, 1)) %>%
  mutate(above_alice_threshold = percent(above_alice_threshold, 1)) %>%
  set_names("County", "Below Poverty Level and ALICE Threshold", "Above ALICE Threshold") %>%
  write_csv("inst/data/alice-data-2020.csv")
  view()
