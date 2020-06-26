obtn_alice_data_thresholds_geospatial <- obtn_alice_data_thresholds %>%
  dplyr::mutate(value_categorical = scales::dollar(value, accuracy = 1)) %>%
  dplyr::mutate(age = forcats::fct_rev(age)) %>%
  dplyr::left_join(obtn_boundaries_oregon_counties,
                   by = "geography") %>%
  sf::st_as_sf()

ggplot2::ggplot(obtn_alice_data_thresholds_geospatial) +
  ggplot2::geom_sf(ggplot2::aes(fill = value_categorical),
                   color = "white",
                   size = .5) +
  ggplot2::coord_sf(datum = NA) +
  # ggplot2::scale_fill_gradient(low = tfff_yellow,
  #                              high = tfff_dark_green) +
  # ggplot2::scale_fill_manual(values = c(
  #   "Y" = tfff_dark_green,
  #   "N" = tfff_light_green
  # )) +
  ggplot2::theme_void() +
  ggplot2::theme(text = ggplot2::element_text(family = "Calibri",
                                              size = 10),
                 plot.title = ggplot2::element_text(family = "Calibri",
                                                    hjust = 0.5,
                                                    size = 12),
                 legend.box.margin = ggplot2::margin(10,10,10,10),
                 legend.position = "bottom") +
  ggplot2::labs(fill = NULL) +
  ggplot2::facet_wrap(~age)


ggplot2::ggplot(obtn_alice_data_thresholds_geospatial) +
  ggplot2::geom_sf(data = obtn_boundaries_oregon_counties,
                   color = "white",
                   fill = tfff_light_green,
                   size = .5) +
  ggplot2::geom_sf(color = "white",
                   fill = tfff_dark_green,
                   size = .5) +
  ggplot2::coord_sf(datum = NA) +
  ggplot2::theme_void() +
  ggplot2::theme(text = ggplot2::element_text(family = "Calibri",
                                              size = 10),
                 plot.title = ggplot2::element_text(family = "Calibri",
                                                    hjust = 0.5,
                                                    size = 12),
                 legend.box.margin = ggplot2::margin(10,10,10,10),
                 legend.position = "bottom") +
  ggplot2::labs(fill = NULL) +
  ggplot2::facet_grid(cols = ggplot2::vars(age),
                      rows = ggplot2::vars(value_categorical),
                      switch = "y")
