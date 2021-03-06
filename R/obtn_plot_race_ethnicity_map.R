#' Make Single Race/Ethnicity Choropleth Map
#'
#' @param obtn_year
#' @param plot_width
#' @param plot_height
#'
#' @return
#' @export
#'
#' @examples

obtn_plot_single_race_ethnicity_choropleth_map <- function(obtn_year, population_to_filter, plot_width = 4.3684, plot_height = 3.25) {



  state_avg <- obtn_race_ethnicity %>%
    dplyr::filter(year == obtn_year) %>%
    dplyr::filter(population == population_to_filter) %>%
    dplyr::filter(geography == "Oregon") %>%
    dplyr::pull(value)

  obtn_race_ethnicity_filtered <- obtn_race_ethnicity %>%
    dplyr::filter(year == obtn_year) %>%
    dplyr::filter(population == population_to_filter) %>%
    dplyr::filter(geography %in% obtn_oregon_counties) %>%
    dplyr::mutate(above_state_avg = dplyr::case_when(
      value > state_avg ~ "Y",
      TRUE ~ "N"
    ))

  obtn_race_ethnicity_geospatial <- dplyr::left_join(obtn_race_ethnicity_filtered,
                                                     obtn_boundaries_oregon_counties,
                                                     by = "geography") %>%
    sf::st_as_sf()

  ggplot2::ggplot(obtn_race_ethnicity_geospatial) +
    ggplot2::geom_sf(ggplot2::aes(fill = above_state_avg),
                     color = "white",
                     size = .5) +
    ggplot2::coord_sf(datum = NA) +
    ggplot2::scale_fill_manual(values = c(
      "Y" = tfff_dark_green,
      "N" = tfff_light_gray
    )) +
    ggplot2::theme_void() +
    ggplot2::theme(text = ggplot2::element_text(family = "Calibri",
                                                size = 10),
                   plot.title = ggplot2::element_text(family = "Calibri",
                                                      hjust = 0.5,
                                                      size = 12),
                   legend.box.margin = ggplot2::margin(10,10,10,10),
                   legend.position = "none") +
    ggplot2::labs(fill = NULL,
                  title = population_to_filter)

  # obtn_save_plot(2020, measure_to_plot_name, "Oregon", plot_width, plot_height)

}


#' Make All Race/Ethnicity Choropleth Maps
#'
#' @return
#' @export
#'
#' @examples
obtn_plot_multiple_race_ethnicity_choropleth_maps <- function() {

  obtn_race_ethnicity_groups <- obtn_race_ethnicity %>%
    dplyr::distinct(population) %>%
    dplyr::arrange(population) %>%
    dplyr::pull(population)

  obtn_plot_single_race_ethnicity_choropleth_map(2020, obtn_race_ethnicity_groups[1]) +
  obtn_plot_single_race_ethnicity_choropleth_map(2020, obtn_race_ethnicity_groups[2]) +
  obtn_plot_single_race_ethnicity_choropleth_map(2020, obtn_race_ethnicity_groups[3]) +
  obtn_plot_single_race_ethnicity_choropleth_map(2020, obtn_race_ethnicity_groups[4]) +
  obtn_plot_single_race_ethnicity_choropleth_map(2020, obtn_race_ethnicity_groups[5]) +
  obtn_plot_single_race_ethnicity_choropleth_map(2020, obtn_race_ethnicity_groups[6]) +
  obtn_plot_single_race_ethnicity_choropleth_map(2020, obtn_race_ethnicity_groups[7]) +
  obtn_plot_single_race_ethnicity_choropleth_map(2020, obtn_race_ethnicity_groups[8]) +
  patchwork::plot_layout(ncol = 2,
                         widths = 3.5)

}

# library(tidyverse)
#
# obtn_plot_multiple_race_ethnicity_choropleth_maps()
#
# ggsave(filename = "inst/plots/tests/race-ethnicity-above-state-avg.pdf",
#        device = cairo_pdf,
#        height = 8.5,
#        width = 11)
#
