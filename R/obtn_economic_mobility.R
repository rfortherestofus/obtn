# obtn_plot_economic_mobility_map <- function() {
#
#   choropleth_colors_blues <- c("#375678",
#                                "#788CA7",
#                                "#B2BCCB",
#                                "dddddd")
#
#   obtn_economic_mobility_filtered <- obtn_economic_mobility %>%
#     dplyr::filter(family_income_percentile == "25th Percentile") %>%
#     dplyr::mutate(tertile_numeric = dplyr::ntile(value, 3)) %>%
#     dplyr::mutate(tertile_numeric = as.numeric(tertile_numeric)) %>%
#     dplyr::mutate(tertile_text = dplyr::case_when(
#       tertile_numeric == 3 ~ "Top third",
#       tertile_numeric == 2 ~ "Middle third",
#       tertile_numeric == 1 ~ "Bottom third"
#     )) %>%
#     dplyr::ungroup() %>%
#     # Add ID for all missing values
#     dplyr::mutate(tertile_text = tidyr::replace_na(tertile_text, "ID")) %>%
#     dplyr::mutate(tertile_text = factor(tertile_text, levels = c("Top third",
#                                                                  "Middle third",
#                                                                  "Bottom third",
#                                                                  "No college",
#                                                                  "ID")))
#
#   obtn_economic_mobility_filtered_geospatial <- dplyr::left_join(obtn_economic_mobility_filtered,
#                                                                  obtn_boundaries_oregon_counties,
#                                                                  by = "geography") %>%
#     sf::st_as_sf()
#
#
#   ggplot2::ggplot(obtn_economic_mobility_filtered_geospatial) +
#     ggplot2::geom_sf(ggplot2::aes(fill = tertile_text),
#                      color = "white",
#                      size = .5) +
#     # ggplot2::geom_sf_text(ggplot2::aes(label = scales::percent(value, 0.1),
#     #                                    color = tertile_text),
#     #                       size = ggplot_pts(10),
#     #                       family = "Calibri",
#     #                       show_guide = FALSE) +
#     # ggplot2::geom_sf_text(ggplot2::aes(label = scales::number((value * 100), 0.1),
#     #                                    color = tertile_text),
#     #                       size = ggplot_pts(10),
#     #                       family = "Calibri",
#     #                       show_guide = FALSE) +
#     ggplot2::coord_sf(datum = NA) +
#     ggplot2::scale_fill_manual(values = choropleth_colors_blues) +
#     ggplot2::scale_color_manual(values = c("white",
#                                            "white",
#                                            tfff_dark_gray)) +
#     ggplot2::theme_void() +
#     ggplot2::theme(text = ggplot2::element_text(family = "Calibri",
#                                                 size = 10),
#                    legend.box.margin = ggplot2::margin(10,10,10,10),
#                    legend.position = "bottom") +
#     ggplot2::scale_x_continuous(expand = c(0, 0)) +
#     ggplot2::scale_y_continuous(expand = c(0, 0)) +
#     ggplot2::labs(fill = NULL)
#
# }
#
# obtn_plot_economic_mobility_map()
#
# ggplot2::ggsave(filename = "inst/plots/tests/economic-mobility-map-no-labels.pdf",
#                 width = 7,
#                 height = 7/1.34,
#                 device = cairo_pdf)
#
#
