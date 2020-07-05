obtn_plot_alice_map <- function(age_to_filter) {

obtn_alice_data_thresholds_geospatial <- obtn_alice_data_thresholds %>%
  dplyr::mutate(value_categorical = scales::dollar(value,
                                                   accuracy = 1)) %>%
  dplyr::filter(age == age_to_filter) %>%
  dplyr::mutate(age = forcats::fct_rev(age)) %>%
  dplyr::left_join(obtn_boundaries_oregon_counties,
                   by = "geography") %>%
  sf::st_as_sf()

obtn_alice_data_thresholds_geospatial %>%
  ggplot2::ggplot() +
  ggplot2::geom_sf(data = obtn_boundaries_oregon_counties,
                   color = "white",
                   fill = tfff_light_green,
                   size = .5) +
  ggplot2::geom_sf(color = "white",
                   fill = tfff_dark_green,
                   size = .5) +
  ggplot2::coord_sf(datum = NA) +
  ggplot2::theme_void() +
  ggplot2::labs(title = age_to_filter) +
  ggplot2::theme(text = ggplot2::element_text(family = "Calibri",
                                              size = 10),
                 plot.title = ggplot2::element_text(family = "Calibri",
                                                    face = "bold",
                                                    hjust = 0.5,
                                                    size = 11,
                                                    margin = ggplot2::margin(b = 10, unit = "pt"))) +
  ggplot2::labs(fill = NULL) +
  # ggplot2::facet_grid(rows = ggplot2::vars(value_categorical))  +
  ggplot2::facet_wrap(~value_categorical,
                      strip.position = "right",
                      ncol = 1) +
  ggplot2::scale_x_continuous(expand = c(0, 0)) +
  ggplot2::scale_y_continuous(expand = c(0, 0))

}

under_65_map <- obtn_plot_alice_map("Under 65")

ggplot2::ggsave(under_65_map,
                filename = "inst/plots/tests/alice-threshold-maps-under-65.pdf",
                device = cairo_pdf)

ggplot2::ggsave(under_65_map,
                filename = "inst/plots/tests/alice-threshold-maps-under-65.svg")

over_65_map <- obtn_plot_alice_map("Over 65") +
  ggplot2::theme(strip.text = ggplot2::element_blank())

ggplot2::ggsave(over_65_map,
                filename = "inst/plots/tests/alice-threshold-maps-over-65.pdf",
                device = cairo_pdf)

ggplot2::ggsave(over_65_map,
                filename = "inst/plots/tests/alice-threshold-maps-over-65.svg")

under_65_map + over_65_map +
  plot_layout(ncol = 2)

plot_grid(under_65_map, over_65_map,
          ncol = 2)

