# library(tidyverse)
# library(tidytext)
# library(scales)
# library(devtools)
# library(sf)
# library(gghighlight)
# library(patchwork)
# library(extrafont)
#
#
#
# # Colors ------------------------------------------------------------------
#
# tfff_dark_green <- "#265142"
# tfff_light_green <- "#B5CC8E"
# tfff_orange <- "#e65100"
# tfff_yellow <- "#FBC02D"
# tfff_blue <- "#283593"
# tfff_red <- "#B71C1C"
# tfff_dark_gray <- "#545454"
# tfff_medium_gray <- "#a8a8a8"
# tfff_light_gray <- "#eeeeee"
#
# tfff_choropleth_colors <- c("#B5CC8E", "#6E8F68", "#265142", "#000000")
#
#
# # Data --------------------------------------------------------------------
#
# data(obtn_economic_mobility)
#
# obtn_economic_mobility_adult <- obtn_economic_mobility %>%
#   filter(family_income_percentile == "25th Percentile") %>%
#   mutate(geography = fct_reorder(geography, value)) %>%
#   mutate(tertile = ntile(value, 3)) %>%
#   select(-family_income_percentile) %>%
#   mutate(timing = "adult")
#
# obtn_economic_mobility_child <- obtn_economic_mobility_adult %>%
#   mutate(timing = "child") %>%
#   mutate(value = 0)
#
#
# obtn_economic_mobility_oregon <- read_excel(here("data-raw", "Economic Mobility Data for Oregon Counties 2.10.20.xlsx"),
#                                             range = "A38:B39") %>%
#   clean_names() %>%
#   set_names(c("geography", "value")) %>%
#   mutate(geography = str_remove(geography, " Average")) %>%
#   mutate(timing = "adult") %>%
#   add_row(geography = "Oregon",
#           timing = "child",
#           value = 0) %>%
#   mutate(tertile = 4)
#
# obtn_economic_mobility_child_adult <- bind_rows(obtn_economic_mobility_child,
#                                                 obtn_economic_mobility_adult,
#                                                 obtn_economic_mobility_oregon) %>%
#   mutate(timing = str_to_title(timing)) %>%
#   mutate(timing = fct_rev(timing))
#
#
# # Slopegraphs -------------------------------------------------------------
#
#
# obtn_economic_mobility_slopegraph <- function(county_state_to_use) {
#
#   tertile_for_plot <- obtn_economic_mobility_child_adult %>%
#     filter(geography == county_state_to_use) %>%
#     distinct(tertile) %>%
#     pull(tertile) %>%
#     as.numeric()
#
#   highlight_color <- tfff_choropleth_colors[tertile_for_plot]
#
#   obtn_economic_mobility_child_adult_for_plot <- obtn_economic_mobility_child_adult %>%
#     mutate(tertile = as.character(tertile))
#
#
#   ggplot(obtn_economic_mobility_child_adult_for_plot,
#          aes(timing, value,
#              group = geography)) +
#
#     # Add lines for all counties
#
#     geom_line(color = tfff_light_gray) +
#
#     # Highlight county/state in different color
#
#     geom_line(data = filter(obtn_economic_mobility_child_adult_for_plot, geography == county_state_to_use),
#               color = highlight_color,
#               size = 1) +
#
#     # Add percent label for highlighted county/state
#
#     geom_text(data = filter(obtn_economic_mobility_child_adult_for_plot, geography == county_state_to_use & timing == "Adult"),
#               aes(label = percent(value, 0.1)),
#               color = highlight_color,
#               hjust = -0.25,
#               fontface = "bold") +
#
#     # Add name of county/state
#
#     annotate("text",
#              x = 1,
#              y = 0.1,
#              label = county_state_to_use,
#              color = highlight_color,
#              fontface = "bold") +
#
#     # Remove clipping so annotation doesn't get cut off
#
#     coord_cartesian(clip = "off") +
#
#     # Theme stuff
#
#     theme_void() +
#     theme(legend.position = "none",
#           plot.margin = unit(c(10, 10, 10, 10), "pt"),
#           plot.title = element_text(hjust = 0.75,
#                                     color = highlight_color,
#                                     face = "bold",
#                                     size = 12))
#
# }
#
#
# # Oregon Average ----------------------------------------------------------
#
#
#
# obtn_economic_mobility_slopegraph("Oregon")
#
# ggsave("inst/plots/2020/econ-mobility-oregon.pdf",
#        width = 3 * 1.5,
#        height = (7/12) * 1.5)
#
#
#
#
# # County Slopegraphs ------------------------------------------------------
#
#
# obtn_oregon_counties %>%
#   tibble() %>%
#   set_names("geography") %>%
#   left_join(obtn_economic_mobility_child_adult) %>%
#   filter(timing == "Adult") %>%
#   filter(geography != "Oregon Average") %>%
#   arrange(desc(value)) %>%
#   pull(geography)
#
#
# obtn_economic_mobility_slopegraph_patchwork <- function(start_value) {
#
#   obtn_oregon_counties_ordered <- obtn_oregon_counties %>%
#     tibble() %>%
#     set_names("geography") %>%
#     left_join(obtn_economic_mobility_child_adult) %>%
#     filter(timing == "Adult") %>%
#     filter(geography != "Oregon Average") %>%
#     arrange(desc(value)) %>%
#     pull(geography)
#
#   obtn_economic_mobility_slopegraph(obtn_oregon_counties_ordered[start_value]) /
#     obtn_economic_mobility_slopegraph(obtn_oregon_counties_ordered[start_value + 1]) /
#     obtn_economic_mobility_slopegraph(obtn_oregon_counties_ordered[start_value + 2]) /
#     obtn_economic_mobility_slopegraph(obtn_oregon_counties_ordered[start_value + 3]) /
#     obtn_economic_mobility_slopegraph(obtn_oregon_counties_ordered[start_value + 4]) /
#     obtn_economic_mobility_slopegraph(obtn_oregon_counties_ordered[start_value + 5]) /
#     obtn_economic_mobility_slopegraph(obtn_oregon_counties_ordered[start_value + 6]) /
#     obtn_economic_mobility_slopegraph(obtn_oregon_counties_ordered[start_value + 7]) /
#     obtn_economic_mobility_slopegraph(obtn_oregon_counties_ordered[start_value + 8]) /
#     obtn_economic_mobility_slopegraph(obtn_oregon_counties_ordered[start_value + 9]) /
#     obtn_economic_mobility_slopegraph(obtn_oregon_counties_ordered[start_value + 10]) /
#     obtn_economic_mobility_slopegraph(obtn_oregon_counties_ordered[start_value + 11])
#
# }
#
# obtn_economic_mobility_slopegraph_patchwork(1)
#
# ggsave("inst/plots/2020/econ-mobility-top-third.pdf",
#        height = 8,
#        width = 3)
#
#
# obtn_economic_mobility_slopegraph_patchwork(13)
#
# ggsave("inst/plots/2020/econ-mobility-middle-third.pdf",
#        height = 8,
#        width = 3)
#
#
# obtn_economic_mobility_slopegraph_patchwork(25)
#
# ggsave("inst/plots/2020/econ-mobility-bottom-third.pdf",
#        height = 8,
#        width = 3)
#
#
# # Bar Charts --------------------------------------------------------------
#
#
# obtn_economic_mobility_bar_chart <- function() {
#
#   obtn_economic_mobility_child_adult %>%
#     filter(timing == "Adult") %>%
#     filter(geography != "Oregon") %>%
#     mutate(geography = fct_reorder(geography, value)) %>%
#     ggplot(aes(value,
#                geography,
#                fill = as.character(tertile),
#                color = as.character(tertile),,
#                label = percent(value, 0.1))) +
#     geom_col(color = "transparent") +
#     geom_text(hjust = 1.1,
#               family = "Calibri") +
#     geom_text(aes(0.0025,
#                   geography,
#                   family = "Calibri",
#                   label = geography),
#               hjust = 0) +
#     theme_void() +
#     theme(legend.position = "none") +
#     scale_fill_manual(values = tfff_choropleth_colors) +
#     scale_color_manual(values = c(tfff_dark_green, "white", "white"))
# }
#
# obtn_economic_mobility_bar_chart()
#
# ggsave("inst/plots/2020/econ-mobility-bar-chart.pdf",
#        height = 9,
#        width = 6,
#        device = cairo_pdf)
#
# obtn_economic_mobility_bar_chart(1)
#
#
# ggsave("inst/plots/2020/econ-mobility-bar-chart-bottom-third.pdf",
#        height = 8,
#        width = 3)
#
# obtn_economic_mobility_bar_chart(2)
#
# ggsave("inst/plots/2020/econ-mobility-bar-chart-middle-third.pdf",
#        height = 8,
#        width = 3)
#
# obtn_economic_mobility_bar_chart(3)
#
# ggsave("inst/plots/2020/econ-mobility-bar-chart-top-third.pdf",
#        height = 8,
#        width = 3)
#
# # Map ---------------------------------------------------------------------
#
# obtn_economic_mobility %>%
#   filter(family_income_percentile == "25th Percentile") %>%
#   mutate(geography = fct_reorder(geography, value)) %>%
#   mutate(tertile = ntile(value, 3)) %>%
#   mutate(tertile = as.character(tertile)) %>%
#   right_join(obtn_boundaries_oregon_counties, by = "geography") %>%
#   st_set_geometry("geometry") %>%
#   ggplot(aes(fill = tertile)) +
#   geom_sf(color = "white") +
#   labs(fill = NULL) +
#   scale_fill_manual(values = tfff_choropleth_colors,
#                     labels = c(" Bottom third ",
#                                " Middle third ",
#                                " Top third ")) +
#   theme_void() +
#   theme(legend.position = "bottom",
#         legend.text = element_text(family = "Calibri")) +
#   scale_x_continuous(expand = c(0, 0)) +
#   scale_y_continuous(expand = c(0, 0))
#
# ggsave("inst/plots/2020/econ-mobility-map.pdf",
#        height = 3.25,
#        width = 4.2942,
#        device = cairo_pdf)
#
# ggsave("inst/plots/2020/econ-mobility-map-large.pdf",
#        height = 4,
#        width = 6,
#        device = cairo_pdf)
#
#
#
