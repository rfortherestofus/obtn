# # obtn_plot_population_density_map <- function()
# library(tidyverse)
# library(sf)
#
# obtn_population_by_census_tract_geospatial <- obtn_boundaries_oregon_census_tracts %>%
#   left_join(obtn_population_by_census_tract) %>%
#   mutate(population_per_square_mile_categorical = case_when(
#     population_per_square_mile < 10 ~ "Less than 10",
#     between(population_per_square_mile, 10, 100) ~ "10-100",
#     between(population_per_square_mile, 100, 500) ~ "100-500",
#     between(population_per_square_mile, 500, 5000) ~ "500-5,000",
#     population_per_square_mile > 5000 ~ "Greater than 5,000"
#   )) %>%
#   mutate(population_per_square_mile_categorical = factor(population_per_square_mile_categorical,
#                                                          levels = c("Less than 10",
#                                                                     "10-100",
#                                                                     "100-500",
#                                                                     "500-5,000",
#                                                                     "Greater than 5,000")))
#
#
#
# obtn_population_by_census_tract_geospatial %>%
#   st_drop_geometry() %>%
#   skimr::skim()
#
# library(colorblindr)
#
# tfff_dark_green_lighter <- tinter::tinter(tfff_dark_green,
#                                           steps = 1,
#                                           direction = "tints")
#
# p <- ggplot2::ggplot(obtn_population_by_census_tract_geospatial) +
#   ggplot2::geom_sf(ggplot2::aes(fill = population_per_square_mile_categorical),
#                    color = "transparent",
#                    size = 0) +
#   ggplot2::coord_sf(datum = NA) +
#   ggplot2::scale_fill_manual(values = c(tfff_light_green,
#                                         "#6E8F68",
#                                         tfff_yellow,
#                                         tfff_orange,
#                                         tfff_red)) +
#   ggplot2::theme_void() +
#   ggplot2::labs(fill = "Population per Square Mile") +
#   ggplot2::theme(text = ggplot2::element_text(family = "Calibri",
#                                               size = 10),
#                  legend.box.margin = ggplot2::margin(10,10,10,10),
#                  legend.text = element_text(size = 10),
#                  legend.title = element_text(size = 12),
#                  legend.position = "right") +
#   ggplot2::scale_x_continuous(expand = c(0, 0)) +
#   ggplot2::scale_y_continuous(expand = c(0, 0))
#
# p
#
# ggsave(p,
#        path = "inst/plots/tests/",
#        filename = "population-density-map-five-colors.pdf",
#        device = cairo_pdf)
#
# p_cb <- cvd_grid(p)
#
# ggsave(p_cb,
#        path = "inst/plots/tests/",
#        filename = "population-density-map-colorblind-test.pdf",
#        device = cairo_pdf)
#
#
# # ggplot2::ggplot(obtn_population_by_census_tract_geospatial) +
# #   ggplot2::geom_sf(ggplot2::aes(fill = population_per_square_mile),
# #                    color = "transparent",
# #                    size = .01) +
# #   ggplot2::coord_sf(datum = NA) +
# #   ggplot2::scale_fill_gradient(low = tfff_light_gray,
# #                                high = tfff_dark_green,
# #                                label = scales::comma_format()) +
# #   ggplot2::theme_void() +
# #   ggplot2::labs(fill = "Population per Square Mile") +
# #   ggplot2::theme(text = ggplot2::element_text(family = "Calibri",
# #                                               size = 10),
# #                  legend.box.margin = ggplot2::margin(10,10,10,10),
# #                  legend.position = "right") +
# #   ggplot2::scale_x_continuous(expand = c(0, 0)) +
# #   ggplot2::scale_y_continuous(expand = c(0, 0))
#
# ggsave("inst/plots/tests/population-density-map.pdf",
#        device = cairo_pdf)
#
# ggsave("inst/plots/tests/population-density-map.png",
#        dpi = 300)
