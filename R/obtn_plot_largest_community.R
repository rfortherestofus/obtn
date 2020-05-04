#' Title
#'
#' @param obtn_year
#' @param plot_width
#' @param plot_height
#'
#' @return
#' @export
#'
#' @examples
obtn_plot_largest_community <- function(obtn_year, plot_width = 5, plot_height = 3.8633) {

  obtn_largest_community_sf <- obtn_largest_community %>%
    dplyr::filter(year == obtn_year) %>%
    dplyr::arrange(desc(population)) %>%
    dplyr::mutate(n = dplyr::row_number()) %>%
    dplyr::mutate(oc_lat = dplyr::case_when(
      geography == "Clackamas" ~ 45.4,
      geography == "Washington" ~ 45.514415,
      geography == "Multnomah" ~ 45.545634,
      geography == "Polk" ~ 44.956786,
      TRUE ~ oc_lat
    )) %>%
    dplyr::mutate(oc_lng = dplyr::case_when(
      geography == "Clackamas" ~ -122.703035,
      geography == "Washington" ~ -122.82,
      geography == "Multnomah" ~ -122.654335,
      geography == "Polk" ~ -123.15,
      TRUE ~ oc_lng
    )) %>%
    sf::st_as_sf(coords = c("oc_lng", "oc_lat")) %>%
    sf::st_set_crs(4269)

  ggplot2::ggplot() +
    ggplot2::geom_sf(data = obtn_boundaries_oregon_counties,
                     fill = tfff_light_green,
                     color = "white",
                     size = .5) +
    ggplot2::geom_sf_text(data = obtn_largest_community_sf,
                          ggplot2::aes(label = n),
                          family = "Calibri",
                          fontface = "bold",
                          color = tfff_dark_green) +
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

  measure_to_plot_name <- "Largest Community"

  obtn_save_plot(obtn_year, measure_to_plot_name, "Oregon", plot_width, plot_height)

}

