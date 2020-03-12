#' Make Choropleth Map
#'
#' @param measure_to_plot
#' @param obtn_year
#'
#' @return
#' @export
#'
#' @examples
obtn_plot_choropleth_map <- function(obtn_year, measure_to_plot, plot_width = 4.3684, plot_height = 3.25) {

  obtn_data_by_measure_filtered <- obtn_data_by_measure %>%
    dplyr::filter(year == obtn_year) %>%
    dplyr::filter(measure == measure_to_plot) %>%
    dplyr::filter(geography %in% obtn_oregon_counties)

  obtn_data_by_measure_geospatial <- dplyr::left_join(obtn_data_by_measure_filtered, obtn_boundaries_oregon_counties, by = "geography") %>%
    sf::st_as_sf()

  obtn_choropleth_colors <- rev(c("#dddddd",
                                  "#B5CC8E",
                                  "#6E8F68",
                                  "#265142"))

  ggplot2::ggplot(obtn_data_by_measure_geospatial) +
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

  measure_to_plot_name <- stringr::str_glue("Choropleth {measure_to_plot}")

  obtn_save_plot(2020, measure_to_plot_name, "Oregon", plot_width, plot_height)

}


