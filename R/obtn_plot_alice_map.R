# obtn_plot_alice_map <- function() {
#
# obtn_alice_data_thresholds_geospatial <- obtn_alice_data_thresholds %>%
#   dplyr::mutate(value_categorical = scales::dollar(value,
#                                                    accuracy = 1)) %>%
#   # dplyr::filter(age == age_to_filter) %>%
#   dplyr::mutate(age = forcats::fct_rev(age)) %>%
#   dplyr::left_join(obtn_boundaries_oregon_counties,
#                    by = "geography") %>%
#   sf::st_as_sf()
#
# obtn_alice_data_thresholds_geospatial %>%
#   ggplot2::ggplot() +
#   ggplot2::geom_sf(data = obtn_boundaries_oregon_counties,
#                    color = "white",
#                    fill = tfff_light_gray,
#                    size = .5) +
#   ggplot2::geom_sf(color = "white",
#                    fill = tfff_dark_green,
#                    size = .5) +
#   ggplot2::coord_sf(datum = NA) +
#   ggplot2::theme_void() +
#   # ggplot2::labs(title = age_to_filter) +
#   ggplot2::theme(text = ggplot2::element_text(family = "Calibri",
#                                               size = 10),
#                  # strip.text = ggplot2::element_blank(),
#                  plot.title = ggplot2::element_text(family = "Calibri",
#                                                     face = "bold",
#                                                     hjust = 0.5,
#                                                     size = 11,
#                                                     margin = ggplot2::margin(b = 10, unit = "pt"))) +
#   ggplot2::labs(fill = NULL) +
#   ggplot2::facet_grid(rows = ggplot2::vars(value_categorical),
#                       cols = ggplot2::vars(age))
#
# }
#
# obtn_plot_alice_map()
#
# ggplot2::ggsave(filename = "inst/plots/tests/alice-threshold-maps.pdf",
#                 device = cairo_pdf)
#
