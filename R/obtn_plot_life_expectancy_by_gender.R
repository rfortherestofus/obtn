# obtn_life_expectancy %>%
#   group_by(gender) %>%
#   mutate(tertile_numeric = ntile(value, 3)) %>%
#   mutate(tertile_numeric = as.numeric(tertile_numeric)) %>%
#   ungroup() %>%
#   mutate(tertile_text = case_when(
#     tertile_numeric == 3 ~ "Top third",
#     tertile_numeric == 2 ~ "Middle third",
#     tertile_numeric == 1 ~ "Bottom third"
#   )) %>%
#   mutate(tertile_text = fct_rev(tertile_text)) %>%
#   arrange(geography) %>%
#   view()
#
#
# obtn_plot_life_expectancy_by_gender <- function(obtn_year, measure_to_plot, plot_width = 4.3684, plot_height = 3.25) {
#
#   obtn_data_by_measure_filtered <- obtn_data_by_measure %>%
#     dplyr::filter(year == obtn_year) %>%
#     dplyr::filter(measure == measure_to_plot) %>%
#     dplyr::filter(geography %in% obtn_oregon_counties)
#
#   obtn_data_by_measure_geospatial <- dplyr::left_join(obtn_data_by_measure_filtered,
#                                                       obtn_boundaries_oregon_counties,
#                                                       by = "geography") %>%
#     sf::st_as_sf()
#
#   ggplot2::ggplot(obtn_data_by_measure_geospatial) +
#     ggplot2::geom_sf(ggplot2::aes(fill = tertile_text),
#                      color = "white",
#                      size = .5) +
#     ggplot2::coord_sf(datum = NA) +
#     ggplot2::scale_fill_manual(values = obtn_choropleth_colors) +
#     ggplot2::theme_void() +
#     ggplot2::theme(text = ggplot2::element_text(family = "Calibri",
#                                                 size = 10),
#                    legend.box.margin = ggplot2::margin(10,10,10,10),
#                    legend.position = "bottom") +
#     ggplot2::scale_x_continuous(expand = c(0, 0)) +
#     ggplot2::scale_y_continuous(expand = c(0, 0)) +
#     ggplot2::labs(fill = NULL)
#
#   # measure_to_plot_name <- stringr::str_glue("Choropleth {measure_to_plot}")
#
#   # obtn_save_plot(obtn_year, measure_to_plot_name, "Oregon", plot_width, plot_height)
#
# }
#
# obtn_plot_life_expectancy_by_gender(2020, "Life Expectancy - Overall")
