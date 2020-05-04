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

  obtn_race_ethnicity_filtered <- obtn_race_ethnicity %>%
    dplyr::filter(year == obtn_year) %>%
    dplyr::filter(geography %in% obtn_oregon_counties)

  obtn_race_ethnicity_range_top <- obtn_race_ethnicity_filtered %>%
    dplyr::group_by(population, tertile_text) %>%
    dplyr::slice_max(value, 1,
                     with_ties = FALSE) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(range_label = "max")

  obtn_race_ethnicity_range_bottom <- obtn_race_ethnicity_filtered %>%
    dplyr::group_by(population, tertile_text) %>%
    dplyr::slice_min(value, 1,
                     with_ties = FALSE) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(range_label = "min")

  obtn_race_ethnicity_ranges <- dplyr::bind_rows(obtn_race_ethnicity_range_bottom,
                                                 obtn_race_ethnicity_range_top) %>%
    dplyr::select(population, value, tertile_text, tertile_numeric, range_label) %>%
    dplyr::arrange(population, value) %>%
    dplyr::mutate(value = scales::percent(value, accuracy = 0.1)) %>%
    tidyr::pivot_wider(id_cols = c(population, tertile_text, tertile_numeric),
                       names_from = range_label,
                       values_from = value) %>%
    dplyr::mutate(tertile_label = stringr::str_glue("{tertile_text}\n{min}-{max}")) %>%
    dplyr::select(population, tertile_text, tertile_numeric, tertile_label) %>%
    dplyr::mutate(tertile_label = forcats::fct_reorder(tertile_label, tertile_numeric)) %>%
    dplyr::mutate(tertile_label = forcats::fct_rev(tertile_label))


  dplyr::left_join(obtn_race_ethnicity_filtered, obtn_race_ethnicity_ranges)

  obtn_race_ethnicity_geospatial <- dplyr::left_join(obtn_race_ethnicity_filtered, obtn_boundaries_oregon_counties, by = "geography") %>%
    sf::st_as_sf() %>%
    dplyr::left_join(obtn_race_ethnicity_ranges, by = c("population", "tertile_numeric", "tertile_text")) %>%
    dplyr::select(geography, population, tertile_label)

  obtn_race_ethnicity_geospatial_filtered <- obtn_race_ethnicity_geospatial %>%
    dplyr::filter(population == population_to_filter)


  ggplot2::ggplot(obtn_race_ethnicity_geospatial_filtered) +
    ggplot2::geom_sf(ggplot2::aes(fill = tertile_label),
                     color = "white",
                     size = .5) +
    ggplot2::coord_sf(datum = NA) +
    ggplot2::scale_fill_manual(values = obtn_choropleth_colors) +
    ggplot2::theme_void() +
    ggplot2::theme(text = ggplot2::element_text(family = "Calibri",
                                                size = 10),
                   plot.title = ggplot2::element_text(family = "Calibri",
                                                      hjust = 0.5,
                                                      size = 12),
                   legend.box.margin = ggplot2::margin(10,10,10,10),
                   legend.position = "bottom") +
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



