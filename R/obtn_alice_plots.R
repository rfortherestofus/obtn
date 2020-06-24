#
# # Load Stuff --------------------------------------------------------------
#
#
#
# library(tidyverse)
# fpl_2016 <- 24300
#
#
# # # Line Chart --------------------------------------------------------------
#
# obtn_plot_alice_thresholds <- function(var,
#                                        title_text,
#                                        threshold_color) {
#
#   obtn_alice_data_thresholds_summary <- obtn_alice_data_thresholds %>%
#     dplyr::mutate(alice_threshold = {{ var }}) %>%
#     dplyr::mutate(gap = median_income - alice_threshold) %>%
#     dplyr::mutate(plot_order_gap = median_income - alice_threshold_hh_under_65) %>%
#     dplyr::mutate(gap_dichotomous = dplyr::case_when(
#       gap > 0 ~ "Above",
#       gap < 0 ~ "Below"
#     )) %>%
#     dplyr::mutate(hjust_amount = dplyr::if_else(gap > 0, -0.2, 1.2)) %>%
#     dplyr::mutate(geography = forcats::fct_reorder(geography, alice_threshold))
#
#
#   ggplot2::ggplot(obtn_alice_data_thresholds_summary,
#                   ggplot2::aes(x = median_income,
#                                xend = alice_threshold,
#                                y = geography,
#                                yend = geography,
#                                color = gap_dichotomous)) +
#     ggplot2::geom_segment(size = 2) +
#     # shadowtext::geom_shadowtext(ggplot2::aes(x = median_income,
#     #                                          y = geography,
#     #                                          label = scales::dollar(gap)),
#     #                             hjust = obtn_alice_data_thresholds_summary$hjust_amount,
#     #                             bg.colour = "white") +
#     ggimage::geom_image(ggplot2::aes(x = median_income,
#                                      y = geography),
#                         image = here::here("inst", "images", "house-yellow.png"),
#                         size = 0.02,
#                         color = tfff_yellow) +
#     ggplot2::geom_point(ggplot2::aes(x = alice_threshold,
#                                      y = geography),
#                         color = threshold_color,
#                         shape = 21,
#                         fill = "white",
#                         stroke = 1.5,
#                         size = 4) +
#     ggplot2::geom_text(ggplot2::aes(x = alice_threshold,
#                                     y = geography),
#                        color = threshold_color,
#                        label = "A",
#                        fontface = "bold",
#                        family = "Calibri",
#                        size = 3.5) +
#     ggplot2::scale_x_continuous(labels = scales::dollar_format(),
#                                 limits = c(30000, 70000),
#                                 breaks = seq(30000, 70000, by = 5000),
#                                 expand = ggplot2::expansion(add = c(700, 5000))) +
#     ggplot2::labs(title = title_text) +
#     ggplot2::theme_minimal(base_size = 14,
#                            base_family = "Calibri") +
#     ggplot2::theme(
#       panel.grid.minor.y = ggplot2::element_blank(),
#       panel.grid.minor.x = ggplot2::element_blank(),
#       panel.grid.major.x = ggplot2::element_line(color = tfff_light_gray),
#       axis.title = ggplot2::element_blank(),
#       legend.position = "none",
#       plot.title = ggplot2::element_text(color = threshold_color)
#     ) +
#     ggplot2::scale_color_manual(values = c(tfff_dark_green,
#                                            tfff_light_green)) +
#     ggplot2::scale_y_discrete(expand = ggplot2::expansion(add = c(1, 2)))
#
# }
#
# under65_plot <- obtn_plot_alice_thresholds(alice_threshold_hh_under_65,
#                                            "Households Under 65",
#                                            tfff_dark_gray)
# under65_plot
#
# ggplot2::ggsave("inst/plots/tests/alice-plot-under-65.pdf",
#                 width = 10,
#                 height = 10,
#                 device = cairo_pdf)
#
# over65_plot <- obtn_plot_alice_thresholds(alice_threshold_hh_65_years_and_over,
#                                           "Households Over 65",
#                                           tfff_dark_gray) +
#   ggplot2::theme(axis.text.y = ggplot2::element_blank())
#
#
# under65_plot + over65_plot +
#   patchwork::plot_layout(ncol = 2)
#
# ggplot2::ggsave("inst/plots/tests/alice-plot-lines-under-over-65.pdf",
#                 width = 15,
#                 height = 10,
#                 device = cairo_pdf)
#
#
# # Over 65 + Under 65 in One -----------------------------------------------
#
# obtn_plot_alice_thresholds_combined <- function() {
#
#   obtn_alice_data_thresholds_summary <- obtn_alice_data_thresholds %>%
#     dplyr::mutate(alice_threshold = alice_threshold_hh_under_65) %>%
#     dplyr::mutate(gap = median_income - alice_threshold) %>%
#     dplyr::mutate(plot_order_gap = median_income - alice_threshold_hh_under_65) %>%
#     dplyr::mutate(gap_dichotomous = dplyr::case_when(
#       gap > 0 ~ "Above",
#       gap < 0 ~ "Below"
#     )) %>%
#     dplyr::mutate(hjust_amount = dplyr::if_else(gap > 0, -0.2, 1.2)) %>%
#     dplyr::mutate(geography = forcats::fct_reorder(geography, plot_order_gap))
#
#
#   ggplot2::ggplot(obtn_alice_data_thresholds_summary,
#                   ggplot2::aes(x = median_income,
#                                y = geography,
#                                color = gap_dichotomous)) +
#     ggimage::geom_image(ggplot2::aes(x = median_income,
#                                      y = geography),
#                         image = here::here("inst", "images", "house-yellow.png"),
#                         size = 0.02,
#                         color = tfff_yellow) +
#     ggplot2::geom_point(ggplot2::aes(x = alice_threshold_hh_under_65,
#                                      y = geography),
#                         color = tfff_dark_green,
#                         shape = 21,
#                         fill = "white",
#                         stroke = 1.5,
#                         size = 4) +
#     ggplot2::geom_text(ggplot2::aes(x = alice_threshold_hh_under_65,
#                                     y = geography),
#                        color = tfff_dark_green,
#                        label = "A",
#                        fontface = "bold",
#                        family = "Calibri",
#                        size = 3.5) +
#     ggplot2::geom_point(ggplot2::aes(x = alice_threshold_hh_65_years_and_over,
#                                      y = geography),
#                         color = tfff_medium_gray,
#                         shape = 21,
#                         fill = "white",
#                         stroke = 1.5,
#                         size = 4) +
#     ggplot2::geom_text(ggplot2::aes(x = alice_threshold_hh_65_years_and_over,
#                                     y = geography),
#                        color = tfff_medium_gray,
#                        label = "A",
#                        fontface = "bold",
#                        family = "Calibri",
#                        size = 3.5) +
#     ggplot2::scale_x_continuous(labels = scales::dollar_format(),
#                                 limits = c(30000, 70000),
#                                 breaks = seq(30000, 70000, by = 5000),
#                                 expand = ggplot2::expansion(add = c(700, 5000))) +
#     # ggplot2::labs(title = title_text) +
#     ggplot2::theme_minimal(base_size = 14,
#                            base_family = "Calibri") +
#     ggplot2::theme(
#       panel.grid.minor.y = ggplot2::element_blank(),
#       panel.grid.minor.x = ggplot2::element_blank(),
#       panel.grid.major.x = ggplot2::element_line(color = tfff_light_gray),
#       axis.title = ggplot2::element_blank(),
#       legend.position = "none"
#     ) +
#     ggplot2::scale_color_manual(values = c(tfff_dark_green,
#                                            tfff_light_green)) +
#     ggplot2::scale_y_discrete(expand = ggplot2::expansion(add = c(1, 2)))
#
# }
#
# obtn_plot_alice_thresholds_combined()
#
#
# ggplot2::ggsave("inst/plots/tests/alice-plot-lines-under-over-65-combined.pdf",
#                 width = 15,
#                 height = 10,
#                 device = cairo_pdf)
#
#
#
# # Facetted ----------------------------------------------------------------
#
# obtn_plot_alice_thresholds_combined_facetted <- function() {
#
#   obtn_alice_data_thresholds_summary <- obtn_alice_data_thresholds %>%
#     dplyr::mutate(alice_threshold = alice_threshold_hh_under_65)
#
#
#   ggplot2::ggplot(obtn_alice_data_thresholds_summary,
#                   ggplot2::aes(x = median_income,
#                                y = 1,
#                                color = gap_dichotomous)) +
#     ggimage::geom_image(ggplot2::aes(x = median_income,
#                                      y = 1),
#                         image = here::here("inst", "images", "house-yellow.png"),
#                         size = 0.02,
#                         color = tfff_yellow) +
#     ggplot2::geom_point(ggplot2::aes(x = alice_threshold_hh_under_65,
#                                      y = 1),
#                         color = tfff_dark_green,
#                         shape = 21,
#                         fill = "white",
#                         stroke = 1.5,
#                         size = 4) +
#     ggplot2::geom_text(ggplot2::aes(x = alice_threshold_hh_under_65,
#                                     y = 1),
#                        color = tfff_dark_green,
#                        label = "A",
#                        fontface = "bold",
#                        family = "Calibri",
#                        size = 3.5) +
#     ggplot2::geom_point(ggplot2::aes(x = alice_threshold_hh_65_years_and_over,
#                                      y = 1),
#                         color = tfff_medium_gray,
#                         shape = 21,
#                         fill = "white",
#                         stroke = 1.5,
#                         size = 4) +
#     ggplot2::geom_text(ggplot2::aes(x = alice_threshold_hh_65_years_and_over,
#                                     y = 1),
#                        color = tfff_medium_gray,
#                        label = "A",
#                        fontface = "bold",
#                        family = "Calibri",
#                        size = 3.5) +
#     ggplot2::scale_x_continuous(labels = scales::dollar_format(),
#                                 limits = c(30000, 70000),
#                                 breaks = seq(30000, 70000, by = 5000),
#                                 expand = ggplot2::expansion(add = c(700, 5000))) +
#     ggplot2::theme_minimal(base_size = 14,
#                            base_family = "Calibri") +
#     ggplot2::theme(
#       panel.grid.minor.y = ggplot2::element_blank(),
#       panel.grid.minor.x = ggplot2::element_blank(),
#       panel.grid.major.x = ggplot2::element_line(color = tfff_light_gray),
#       axis.title = ggplot2::element_blank(),
#       axis.text.y = ggplot2::element_blank(),
#       legend.position = "none"
#     ) +
#     ggplot2::scale_color_manual(values = c(tfff_dark_green,
#                                            tfff_light_green)) +
#     ggplot2::scale_y_discrete(expand = ggplot2::expansion(add = c(1, 2))) +
#     ggplot2::facet_wrap(~geography)
#
# }
#
# obtn_plot_alice_thresholds_combined_facetted()
#
# ggplot2::ggsave("inst/plots/tests/alice-plot-lines-under-over-65-facetted.pdf",
#                 width = 15,
#                 height = 10,
#                 device = cairo_pdf)
#
# # Cut Outs ----------------------------------------------------------------
#
#
#
# # ggplot2::geom_label(ggplot2::aes(x = 39000,
# #                                  y = 34.5),
# #                     family = "Calibri",
# #                     color = tfff_dark_gray,
# #                     lineheight = 1,
# #                     hjust = 1,
# #                     label.size = 0,
# #                     label.padding = grid::unit(0.25, "lines"),
# #                     label = "Median household income\nin Sherman County is\n$5,684 above ALICE threshold") +
# # ggplot2::geom_curve(ggplot2::aes(x = 39500,
# #                                  xend = 42000,
# #                                  y = 34.5,
# #                                  yend = 35.5),
# #                     color = tfff_dark_gray,
# #                     curvature = 0.3,
# #                     arrow = grid::arrow(length = grid::unit(0.25,"cm"),
# #                                         type = "closed")) +
# # ggplot2::geom_label(ggplot2::aes(x = 55000,
# #                                  y = 7),
# #                     family = "Calibri",
# #                     color = tfff_dark_gray,
# #                     lineheight = 1,
# #                     hjust = 0,
# #                     label.size = 0,
# #                     label.padding = grid::unit(0.25, "lines"),
# #                     label = "Median household income in\nHood River is $28,524\nbelow ALICE threshold,\nthe largest gap of any county") +
# # ggplot2::geom_curve(ggplot2::aes(x = 62000,
# #                                  xend = 60800,
# #                                  y = 5,
# #                                  yend = 1),
# #                     color = tfff_light_green,
# #                     curvature = -0.5,
# #                     arrow = grid::arrow(length = grid::unit(0.25,"cm"),
# #                                         type = "closed")) +
#
# # ggplot2::geom_label(ggplot2::aes(x = 60000,
# #                                  y = 37,
# #                                  label = "ALICE Threshold"),
# #                     label.size = 0,
# #                     label.padding = grid::unit(0.25, "lines"),
# #                     hjust = 1,
# #                     family = "Calibri",
# #                     color = tfff_dark_gray) +
# # ggplot2::geom_label(ggplot2::aes(x = 61000,
# #                                  y = 37,
# #                                  label = "Median Household Income"),
# #                     label.size = 0,
# #                     label.padding = grid::unit(0.25, "lines"),
# #                     hjust = 0,
# #                     family = "Calibri",
# #                     color = tfff_dark_gray)
#
#
