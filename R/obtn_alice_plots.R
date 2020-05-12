#
# # Load Stuff --------------------------------------------------------------
#
#
#
# library(tidyverse)
# fpl_2016 <- 24300
#
#
#
# # Line Chart --------------------------------------------------------------
#
# obtn_alice_data_thresholds_summary <- obtn_alice_data_thresholds %>%
#   dplyr::mutate(gap = median_income - alice_threshold) %>%
#   dplyr::mutate(gap_dichotomous = dplyr::case_when(
#     gap > 0 ~ "Above",
#     gap < 0 ~ "Below"
#   )) %>%
#   dplyr::mutate(hjust_amount = dplyr::if_else(gap > 0, -0.2, 1.2)) %>%
#   dplyr::mutate(geography = forcats::fct_reorder(geography, median_income))
#
# ggplot2::ggplot(obtn_alice_data_thresholds_summary,
#                 ggplot2::aes(x = median_income,
#                              xend = alice_threshold,
#                              y = geography,
#                              yend = geography,
#                              color = gap_dichotomous)) +
#   ggplot2::geom_vline(xintercept = fpl_2016,
#                       color = "#686DB3",
#                       linetype = "dashed",
#                       size = 1) +
#   ggplot2::geom_segment(size = 2) +
#   shadowtext::geom_shadowtext(ggplot2::aes(x = median_income,
#                                            y = geography,
#                                            label = scales::dollar(gap)),
#                               hjust = obtn_alice_data_thresholds_summary$hjust_amount,
#                               bg.colour = "white") +
#   ggimage::geom_image(ggplot2::aes(x = median_income,
#                                    y = geography),
#                       image = here::here("inst", "images", "house-yellow.png"),
#                       size = 0.02,
#                       color = tfff_yellow) +
#   # ggplot2::geom_point(ggplot2::aes(x = median_income,
#   #                                  y = geography),
#   #                     color = tfff_yellow,
#   #                     shape = 21,
#   #                     fill = "white",
#   #                     stroke = 1.5,
#   #                     size = 3) +
#   ggplot2::geom_point(ggplot2::aes(x = alice_threshold,
#                                    y = geography),
#                       color = tfff_yellow,
#                       shape = 21,
#                       fill = "white",
#                       stroke = 1.5,
#                       size = 3) +
#   ggplot2::scale_x_continuous(labels = scales::dollar_format(),
#                               limits = c(20000, 65000),
#                               breaks = seq(20000, 65000, by = 5000),
#                               expand = ggplot2::expansion(add = c(500, 5000))) +
#   # ggplot2::labs(title = "<span style = 'color: #545454'>The <span style = 'color: #FBC02D'><b>Median Household Income</b></span> is <span style = 'color: #B5CC8E'><b>below</b></span> the <span style = 'color: #FBC02D'><b>ALICE Threshold</b></span> in all but <span style = 'color: #265142'><b>three counties</b></span>",
#   #               subtitle = "<span style = 'color: #545454'>And the <span style = 'color: #686DB3'><b>Federal Poverty Level</b></span> is below both in all counties</span>") +
#   ggplot2::theme_minimal(base_size = 14,
#                          base_family = "Calibri") +
#   ggplot2::theme(
#     panel.grid.minor.y = ggplot2::element_blank(),
#     panel.grid.minor.x = ggplot2::element_blank(),
#     panel.grid.major.x = ggplot2::element_line(color = tfff_light_gray),
#     axis.title = ggplot2::element_blank(),
#     legend.position = "none",
#     plot.title = ggtext::element_markdown(),
#     plot.subtitle = ggtext::element_markdown()
#   ) +
#   ggplot2::scale_color_manual(values = c(tfff_dark_green,
#                                          tfff_light_green)) +
#   ggplot2::geom_label(ggplot2::aes(x = 39000,
#                                    y = 34.5),
#                       family = "Calibri",
#                       color = tfff_dark_gray,
#                       lineheight = 1,
#                       hjust = 1,
#                       label.size = 0,
#                       label.padding = grid::unit(0.25, "lines"),
#                       label = "Median household income\nin Sherman County is\n$5,684 above ALICE threshold") +
#   ggplot2::geom_curve(ggplot2::aes(x = 39500,
#                                    xend = 42000,
#                                    y = 34.5,
#                                    yend = 35.5),
#                       color = tfff_dark_gray,
#                       curvature = 0.3,
#                       arrow = grid::arrow(length = grid::unit(0.25,"cm"),
#                                           type = "closed")) +
#   ggplot2::geom_label(ggplot2::aes(x = 55000,
#                                    y = 7),
#                       family = "Calibri",
#                       color = tfff_dark_gray,
#                       lineheight = 1,
#                       hjust = 0,
#                       label.size = 0,
#                       label.padding = grid::unit(0.25, "lines"),
#                       label = "Median household income in\nHood River is $28,524\nbelow ALICE threshold,\nthe largest gap of any county") +
#   ggplot2::geom_curve(ggplot2::aes(x = 62000,
#                                    xend = 60800,
#                                    y = 5,
#                                    yend = 1),
#                       color = tfff_light_green,
#                       curvature = -0.5,
#                       arrow = grid::arrow(length = grid::unit(0.25,"cm"),
#                                           type = "closed")) +
#   ggplot2::scale_y_discrete(expand = ggplot2::expansion(add = c(1, 2))) +
#   ggplot2::geom_label(ggplot2::aes(x = 60000,
#                                    y = 37,
#                                    label = "ALICE Threshold"),
#                       label.size = 0,
#                       label.padding = grid::unit(0.25, "lines"),
#                       hjust = 1,
#                       family = "Calibri",
#                       color = tfff_dark_gray) +
#   ggplot2::geom_label(ggplot2::aes(x = 61000,
#                                    y = 37,
#                                    label = "Median Household Income"),
#                       label.size = 0,
#                       label.padding = grid::unit(0.25, "lines"),
#                       hjust = 0,
#                       family = "Calibri",
#                       color = tfff_dark_gray)
#
# ggplot2::ggsave("inst/plots/tests/alice-plot-lines-only.pdf",
#                 width = 10,
#                 height = 10,
#                 device = cairo_pdf)
#
#
# # Curves ------------------------------------------------------------------
#
# obtn_alice_data_thresholds_summary_v2 <- obtn_alice_data_thresholds %>%
#   mutate(fpl = fpl_2016) %>%
#   dplyr::mutate(gap = median_income - alice_threshold) %>%
#   mutate(gap_label = case_when(
#     gap > 0 ~ str_glue("+{scales::dollar(gap)}"),
#     gap < 0 ~ scales::dollar(gap)
#   )) %>%
#   dplyr::mutate(label_placement_x = alice_threshold + (gap / 2)) %>%
#   dplyr::mutate(label_placement_y = dplyr::case_when(
#     # gap > 0 ~ 1.1,
#     gap < 0 ~ gap / 40000
#   )) %>%
#   dplyr::mutate(label_placement_y = 1 + label_placement_y - 0.1) %>%
#   dplyr::mutate(fpl_mhi_gap = median_income - fpl) %>%
#   dplyr::mutate(fpl_mhi_gap = scales::dollar(fpl_mhi_gap)) %>%
#   dplyr::mutate(fpl_alice_gap = alice_threshold - fpl) %>%
#   dplyr::mutate(fpl_alice_gap = scales::dollar(fpl_alice_gap))
#
#
#
# ggplot() +
#   geom_hline(yintercept = 1,
#              color = tfff_light_gray) +
#   geom_curve(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = fpl,
#                  xend = median_income,
#                  y = 1,
#                  yend = 1),
#              curvature = -1,
#              size = 1.5,
#              color = tfff_yellow) +
#   geom_curve(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = fpl,
#                  xend = alice_threshold,
#                  y = 1,
#                  yend = 1),
#              curvature = -1,
#              size = 1.5,
#              color = tfff_light_green) +
#   geom_curve(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = median_income,
#                  xend = alice_threshold,
#                  y = 1,
#                  yend = 1),
#              curvature = 1,
#              color = tfff_dark_green) +
#   geom_point(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = fpl,
#                  y = 1),
#              shape = 21,
#              size = 3,
#              stroke = 1.5,
#              fill = "white",
#              color = tfff_blue) +
#   geom_point(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = median_income,
#                  y = 1),
#              shape = 21,
#              size = 3,
#              stroke = 1.5,
#              fill = "white",
#              color = tfff_yellow) +
#   geom_point(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = alice_threshold,
#                  y = 1),
#              shape = 21,
#              size = 3,
#              stroke = 1.5,
#              fill = "white",
#              color = tfff_light_green) +
#   ggplot2::theme_minimal(base_size = 14,
#                          base_family = "Calibri") +
#   ggplot2::theme(
#     panel.grid.minor.y = ggplot2::element_blank(),
#     panel.grid.major.y = ggplot2::element_blank(),
#     panel.grid.minor.x = ggplot2::element_blank(),
#     panel.grid.major.x = ggplot2::element_line(color = tfff_light_gray),
#     axis.text.y = ggplot2::element_blank(),
#     axis.text.x = ggplot2::element_text(color = tfff_medium_gray,
#                                         size = 9),
#     axis.title = ggplot2::element_blank(),
#     legend.position = "none",
#     strip.text = element_text(face = "bold"),
#     panel.spacing = unit(2, "lines"),
#     plot.title = ggtext::element_markdown(),
#     plot.subtitle = ggtext::element_markdown()
#   ) +
#   ggplot2::scale_x_continuous(labels = scales::dollar_format(scale = 0.001,
#                                                              suffix = "K"),
#                               limits = c(22500, 75000),
#                               breaks = seq(25000, 75000, by = 25000),
#                               expand = expansion(add = c(0, 10000))) +
#   ggplot2::scale_y_continuous(limits = c(-0.4,
#                                          5.5)) +
#   facet_wrap(~geography,
#              ncol = 4,
#              scale = "free_x") +
#   geom_text(data = filter(obtn_alice_data_thresholds_summary_v2, gap > 0),
#             aes(x = median_income,
#                 y = 1.5,
#                 label = gap_label),
#             hjust = -0.1,
#             family = "Calibri") +
#   geom_text(data = filter(obtn_alice_data_thresholds_summary_v2, gap < 0),
#             aes(x = label_placement_x,
#                 y = label_placement_y,
#                 label = gap_label),
#             vjust = 2.5,
#             family = "Calibri")
#
#
# ggplot2::ggsave("inst/plots/tests/alice-plot-curves.pdf",
#                 width = 12,
#                 height = 24,
#                 device = cairo_pdf)
#
#
#
# # Curves with Arrow -------------------------------------------------------
#
#
# ggplot() +
#   geom_hline(yintercept = 1,
#              color = tfff_light_gray) +
#   geom_curve(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = fpl,
#                  xend = median_income,
#                  y = 1,
#                  yend = 1),
#              curvature = -1,
#              size = 1.5,
#              color = tfff_yellow) +
#   geom_curve(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = fpl,
#                  xend = alice_threshold,
#                  y = 1,
#                  yend = 1),
#              curvature = -1,
#              size = 1.5,
#              color = tfff_light_green) +
#   geom_segment(data = obtn_alice_data_thresholds_summary_v2,
#                aes(x = alice_threshold,
#                    xend = median_income,
#                    y = 0.5,
#                    yend = 0.5),
#                arrow = arrow(type = "open",
#                              length = unit(0.1, "inches")),
#                color = tfff_dark_green) +
#   geom_point(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = fpl,
#                  y = 1),
#              shape = 21,
#              size = 3,
#              stroke = 1.5,
#              fill = "white",
#              color = tfff_blue) +
#   geom_point(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = median_income,
#                  y = 1),
#              shape = 21,
#              size = 3,
#              stroke = 1.5,
#              fill = "white",
#              color = tfff_yellow) +
#   geom_point(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = alice_threshold,
#                  y = 1),
#              shape = 21,
#              size = 3,
#              stroke = 1.5,
#              fill = "white",
#              color = tfff_light_green) +
#   ggplot2::theme_minimal(base_size = 14,
#                          base_family = "Calibri") +
#   ggplot2::theme(
#     panel.grid.minor.y = ggplot2::element_blank(),
#     panel.grid.major.y = ggplot2::element_blank(),
#     panel.grid.minor.x = ggplot2::element_blank(),
#     panel.grid.major.x = ggplot2::element_line(color = tfff_light_gray),
#     axis.text.y = ggplot2::element_blank(),
#     axis.text.x = ggplot2::element_text(color = tfff_medium_gray,
#                                         size = 9),
#     axis.title = ggplot2::element_blank(),
#     legend.position = "none",
#     strip.text = element_text(face = "bold"),
#     panel.spacing = unit(2, "lines"),
#     plot.title = ggtext::element_markdown(),
#     plot.subtitle = ggtext::element_markdown()
#   ) +
#   ggplot2::scale_x_continuous(labels = scales::dollar_format(scale = 0.001,
#                                                              suffix = "K"),
#                               limits = c(22500, 75000),
#                               breaks = seq(25000, 75000, by = 25000),
#                               expand = expansion(add = c(0, 10000))) +
#   ggplot2::scale_y_continuous(limits = c(-0.4,
#                                          5.5)) +
#   facet_wrap(~geography,
#              ncol = 4,
#              scale = "free_x") +
#   geom_text(data = filter(obtn_alice_data_thresholds_summary_v2, gap > 0),
#             aes(x = median_income,
#                 y = 1.5,
#                 label = gap_label),
#             hjust = -0.1,
#             family = "Calibri") +
#   geom_text(data = filter(obtn_alice_data_thresholds_summary_v2, gap < 0),
#             aes(x = label_placement_x,
#                 y = label_placement_y,
#                 label = gap_label),
#             vjust = 2.5,
#             family = "Calibri")
#
#
# ggplot2::ggsave("inst/plots/tests/alice-plot-curves-with-arrow.pdf",
#                 width = 12,
#                 height = 24,
#                 device = cairo_pdf)
#
# # Curves v2 ------------------------------------------------------------------
#
#
# ggplot() +
#   geom_hline(yintercept = 1,
#              color = tfff_light_gray) +
#   geom_curve(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = fpl,
#                  xend = median_income,
#                  y = 1,
#                  yend = 1),
#              curvature = 1,
#              size = 1.5,
#              color = tfff_light_blue) +
#   geom_curve(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = fpl,
#                  xend = alice_threshold,
#                  y = 1,
#                  yend = 1),
#              curvature = -1,
#              size = 1.5,
#              color = tfff_blue) +
#   geom_point(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = fpl,
#                  y = 1),
#              shape = 21,
#              size = 3,
#              stroke = 1.5,
#              fill = "white",
#              color = tfff_light_green) +
#   geom_point(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = median_income,
#                  y = 1),
#              shape = 21,
#              size = 3,
#              stroke = 1.5,
#              fill = "white",
#              color = tfff_light_blue) +
#   geom_point(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = alice_threshold,
#                  y = 1),
#              shape = 21,
#              size = 3,
#              stroke = 1.5,
#              fill = "white",
#              color = tfff_blue) +
#   ggplot2::theme_minimal(base_size = 14,
#                          base_family = "Calibri") +
#   ggplot2::theme(
#     panel.grid.minor.y = ggplot2::element_blank(),
#     panel.grid.major.y = ggplot2::element_blank(),
#     panel.grid.minor.x = ggplot2::element_blank(),
#     panel.grid.major.x = ggplot2::element_line(color = tfff_light_gray),
#     axis.text.y = ggplot2::element_blank(),
#     axis.text.x = ggplot2::element_text(color = tfff_medium_gray,
#                                         size = 9),
#     axis.title = ggplot2::element_blank(),
#     legend.position = "none",
#     strip.text = element_text(face = "bold"),
#     panel.spacing = unit(2, "lines"),
#     plot.title = ggtext::element_markdown(size = 20,
#                                           face = "bold"),
#     plot.subtitle = ggtext::element_markdown(size = 16,
#                                              face = "bold")
#   ) +
#   ggplot2::scale_x_continuous(labels = scales::dollar_format(scale = 0.001,
#                                                              suffix = "K"),
#                               limits = c(22500, 75000),
#                               breaks = seq(25000, 75000, by = 25000),
#                               expand = expansion(add = c(0, 10000))) +
#   ggplot2::scale_y_continuous(limits = c(-5.5,
#                                          6)) +
#   facet_wrap(~geography,
#              ncol = 4,
#              scale = "free_x") +
#   shadowtext::geom_shadowtext(data = obtn_alice_data_thresholds_summary_v2,
#                               aes(x = median_income,
#                                   y = -0.5,
#                                   label = scales::dollar(median_income)),
#                               hjust = -0.1,
#                               family = "Calibri",
#                               # fontface = "bold",
#                               bg.color = "white",
#                               # bg.r = 0.25,
#                               color = tfff_light_blue) +
#   shadowtext::geom_shadowtext(data = obtn_alice_data_thresholds_summary_v2,
#                               aes(x = alice_threshold,
#                                   y = 2.5,
#                                   label = scales::dollar(alice_threshold)),
#                               hjust = -0.1,
#                               family = "Calibri",
#                               # fontface = "bold",
#                               bg.color = "white",
#                               # bg.r = 0.25,
#                               color = tfff_blue) +
#   ggplot2::labs(title = "<span style = 'color: #545454'>The <span style = 'color: #283593'><b>ALICE Threshold</b></span> is above the <span style = 'color: #B3C0D6'><b>Median Household Income</b></span> in Most Oregon Counties</span>",
#                 subtitle = "<span style = 'color: #545454'>And both are well above the <span style = 'color: #B5CC8E'><b>Federal Poverty Level of $24,300</b></span></span>")
#
#
#
# ggplot2::ggsave("inst/plots/tests/alice-plot-curves-v2.pdf",
#                 width = 12,
#                 height = 24,
#                 device = cairo_pdf)
#
#
# ggplot2::ggsave("inst/plots/tests/alice-plot-curves-v2.png",
#                 width = 12,
#                 height = 24)
#
#
#
# # Curves v3 ---------------------------------------------------------------
#
# baker_fill <- obtn_alice_data_thresholds_summary_v2 %>%
#   filter(geography == "Baker")
#
# xend <- seq(from=baker_fill$fpl, to=baker_fill$alice_threshold, by=1)
# xstart <- rep(1, length(xend))
# ystart <- rep(1, length(xend))
# yend <- rep(1, length(xend))
#
# df <- data.frame(xstart, xend, ystart, yend)
#
# ggplot() +
#   geom_hline(yintercept = 1,
#              color = tfff_light_gray) +
#   geom_curve(data = baker_fill,
#              aes(x = fpl,
#                  xend = alice_threshold,
#                  y = 1,
#                  yend = 1),
#              curvature = -1,
#              color = tfff_light_green) +
#   geom_curve(data = df,
#              aes(x=xstart, y=ystart, xend=xend, yend=yend), curvature = -.5, color="purple")
#
# geom_curve(data = obtn_alice_data_thresholds_summary_v2,
#            aes(x = median_income,
#                xend = alice_threshold,
#                y = 1,
#                yend = 1),
#            curvature = 1,
#            color = tfff_dark_green) +
#   geom_point(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = fpl,
#                  y = 1),
#              color = tfff_blue) +
#   geom_point(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = median_income,
#                  y = 1),
#              color = tfff_yellow) +
#   geom_point(data = obtn_alice_data_thresholds_summary_v2,
#              aes(x = alice_threshold,
#                  y = 1),
#              color = tfff_light_green) +
#   ggplot2::theme_minimal(base_size = 14,
#                          base_family = "Calibri") +
#   ggplot2::theme(
#     panel.grid.minor.y = ggplot2::element_blank(),
#     panel.grid.major.y = ggplot2::element_blank(),
#     panel.grid.minor.x = ggplot2::element_blank(),
#     panel.grid.major.x = ggplot2::element_line(color = tfff_light_gray),
#     axis.text.y = ggplot2::element_blank(),
#     axis.text.x = ggplot2::element_text(color = tfff_medium_gray,
#                                         size = 9),
#     axis.title = ggplot2::element_blank(),
#     legend.position = "none",
#     strip.text = element_text(face = "bold"),
#     panel.spacing = unit(2, "lines"),
#     plot.title = ggtext::element_markdown(),
#     plot.subtitle = ggtext::element_markdown()
#   ) +
#   ggplot2::scale_x_continuous(labels = scales::dollar_format(scale = 0.001,
#                                                              suffix = "K"),
#                               limits = c(22500, 75000),
#                               breaks = seq(25000, 75000, by = 25000),
#                               expand = expansion(add = c(0, 10000))) +
#   ggplot2::scale_y_continuous(limits = c(-0.4,
#                                          5.5)) +
#   facet_wrap(~geography,
#              ncol = 4,
#              scale = "free_x") +
#   geom_text(data = filter(obtn_alice_data_thresholds_summary_v2, gap > 0),
#             aes(x = median_income,
#                 y = 1.5,
#                 label = gap_label),
#             hjust = -0.1,
#             family = "Calibri") +
#   geom_text(data = filter(obtn_alice_data_thresholds_summary_v2, gap < 0),
#             aes(x = label_placement_x,
#                 y = label_placement_y,
#                 label = gap_label),
#             vjust = 2.5,
#             family = "Calibri")
#
#
# ggplot2::ggsave("inst/plots/tests/alice-plot-curves_v3.pdf",
#                 width = 4,
#                 height = 6,
#                 device = cairo_pdf)
#
# # svgdevout ---------------------------------------------------------------
#
# library(devoutsvg)
# #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# # 1. Define a pattern
# #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# pattern_gear4 <- svgpatternsimple::create_pattern_gradient(
#   id           = 'fire_gradient',
#   colour1      = 'red',
#   colour2      = 'gold',
#   angle        = 90
# )
#
# pattern_gear6 <- svgpatternsimple::create_pattern_hex(
#   id            = 'hex',
#   angle         = 0,
#   spacing       = 20,
#   fill_fraction = 0.1,
#   colour        = '#2297e6'
# )
#
# fire_filter <- svgfilter::create_filter_turbulent_displacement(
#   id = "fire1"
# )
# #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# # 2. Create a named list associating a hex colour with a pattern to fill with
# #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# my_pattern_list <- list(
#   '#61d04f' = list(fill = pattern_gear4, filter = fire_filter),
#   '#2297e6' = list(fill = pattern_gear6)
# )
#
# #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# # 3. Pass this named `pattern_list` to the `svgout` device
# #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# svgout(filename = "inst/plots/tests/example-filter.svg", width = 8, height = 4,
#        pattern_list = my_pattern_list)
#
#
# last_plot() +
#   labs(title = "Example - patterns + filters")
#
# invisible(dev.off())
