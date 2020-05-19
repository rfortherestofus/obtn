obtn_plot_economic_mobility <- function() {

  obtn_plot_economic_mobility_single_tertile <- function(tertile_level) {

    obtn_economic_mobility_single_tertile <- obtn_economic_mobility %>%
      dplyr::filter(family_income_percentile == "25th Percentile") %>%
      dplyr::mutate(tertile = dplyr::ntile(value, 3)) %>%
      dplyr::mutate(tertile = as.character(tertile)) %>%
      dplyr::mutate(tertile = forcats::fct_rev(tertile)) %>%
      dplyr::mutate(geography = forcats::fct_reorder(geography, value)) %>%
      dplyr::filter(tertile == tertile_level) %>%
      dplyr::mutate(tertile_text = dplyr::case_when(
        tertile == 3 ~ "Top third",
        tertile == 2 ~ "Middle third",
        tertile == 1 ~ "Bottom third"
      ))

    colors <- tfff_choropleth_colors %>%
      as.data.frame() %>%
      rlang::set_names("fill_color") %>%
      dplyr::filter(fill_color != "#dddddd") %>%
      dplyr::mutate(text_color = c("white", "white", tfff_dark_gray)) %>%
      dplyr::mutate(tertile = c(3, 2, 1))

    fill_color <- colors %>%
      dplyr::filter(tertile == tertile_level) %>%
      dplyr::pull(fill_color)

    text_color <- colors %>%
      dplyr::filter(tertile == tertile_level) %>%
      dplyr::pull(text_color)

    ggplot2::ggplot(obtn_economic_mobility_single_tertile,
                    ggplot2::aes(x = value,
                                 y = geography,
                                 label = scales::percent(value, 0.1))) +
      ggplot2::geom_col(fill = fill_color) +
      ggplot2::geom_text(family = "Calibri",
                         color = text_color,
                         hjust = 1.25) +
      ggplot2::scale_x_continuous(expand = c(0.05, 0),
                                  limits = c(0, 0.15)) +
      ggplot2::theme_void(base_family = "Calibri") +
      ggplot2::theme(legend.position = "none",
                     plot.title = ggplot2::element_text(family = "Calibri",
                                                        hjust = 0.1,
                                                        size = 11,
                                                        face = "bold"),
                     panel.margin = ggplot2::margin(0.5, 0, 0.1, 0, "in"),
                     axis.text.y = ggplot2::element_text(color = tfff_dark_gray,
                                                         hjust = 1)) +
      ggplot2::labs(title = obtn_economic_mobility_single_tertile$tertile_text)
  }


  bar_charts <- cowplot::plot_grid(obtn_plot_economic_mobility_single_tertile(3),
                                   obtn_plot_economic_mobility_single_tertile(2),
                                   obtn_plot_economic_mobility_single_tertile(1),
                                   ncol = 3)

  bar_charts


}

economc_mobility_bar_charts <- obtn_plot_economic_mobility()

ggplot2::ggsave(economc_mobility_bar_charts,
                filename = "inst/plots/tests/economic-mobility-bar-charts.pdf",
                width = 7,
                height = 4,
                device = cairo_pdf)


obtn_plot_economic_mobility_map <- function() {

  obtn_economic_mobility_filtered <- obtn_economic_mobility %>%
    dplyr::filter(family_income_percentile == "25th Percentile") %>%
    dplyr::mutate(tertile_numeric = dplyr::ntile(value, 3)) %>%
    dplyr::mutate(tertile_numeric = as.numeric(tertile_numeric)) %>%
    dplyr::mutate(tertile_text = dplyr::case_when(
      tertile_numeric == 3 ~ "Top third",
      tertile_numeric == 2 ~ "Middle third",
      tertile_numeric == 1 ~ "Bottom third"
    )) %>%
    dplyr::ungroup() %>%
    # Add ID for all missing values
    dplyr::mutate(tertile_text = tidyr::replace_na(tertile_text, "ID")) %>%
    dplyr::mutate(tertile_text = factor(tertile_text, levels = c("Top third",
                                                                 "Middle third",
                                                                 "Bottom third",
                                                                 "No college",
                                                                 "ID")))

  obtn_economic_mobility_filtered_geospatial <- dplyr::left_join(obtn_economic_mobility_filtered,
                                                                 obtn_boundaries_oregon_counties,
                                                                 by = "geography") %>%
    sf::st_as_sf()


  ggplot2::ggplot(obtn_economic_mobility_filtered_geospatial) +
    ggplot2::geom_sf(ggplot2::aes(fill = tertile_text),
                     color = "white",
                     size = .5) +
    ggplot2::coord_sf(datum = NA) +
    ggplot2::scale_fill_manual(values = obtn_choropleth_colors) +
    ggplot2::theme_void() +
    ggplot2::theme(text = ggplot2::element_text(family = "Calibri",
                                                size = 10),
                   legend.box.margin = ggplot2::margin(10,10,10,10),
                   legend.position = "bottom") +
    ggplot2::scale_x_continuous(expand = c(0, 0)) +
    ggplot2::scale_y_continuous(expand = c(0, 0)) +
    ggplot2::labs(fill = NULL)

}



economic_mobility_map <- obtn_plot_economic_mobility_map()

economic_mobility_map

ggplot2::ggsave(economic_mobility_map,
                filename = "inst/plots/tests/economic-mobility-map.pdf",
                width = 4.3684,
                height = 3.25,
                device = cairo_pdf)

# cowplot::plot_grid(obtn_plot_economic_mobility_map(),
#                    bar_charts,
#                    rel_heights = c(3, 2),
#                    ncol = 1)

# economic_mobility_plot <- obtn_plot_economic_mobility()

# ggplot2::ggsave(economic_mobility_plot,
#                 filename = "inst/plots/tests/economic-mobility.pdf",
#                width = 7.5,
#                height = 10,
#                device = cairo_pdf)

library(tidyverse)
library(scales)

obtn_economic_mobility %>%
  dplyr::filter(family_income_percentile == "25th Percentile") %>%
  select(geography, value) %>%
  arrange(desc(value)) %>%
  mutate(value = percent(value, 0.1)) %>%
  set_names("county", "percent_mobility") %>%
  write_csv("inst/plots/tests/economic-mobility.csv")


