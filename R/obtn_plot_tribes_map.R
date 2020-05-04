#' Make Map of Tribes Present in Oregon Counties
#'
#' @param obtn_year Year to plot
#' @param tribe_to_plot Tribe to plot
#' @param plot_width Plot width
#' @param plot_height Plot height
#'
#' @return
#' @export
#'
#' @examples
obtn_plot_tribes_map <- function(obtn_year, tribe_to_plot, plot_width = 2, plot_height = 1.5) {

  # Create vector of counties where tribe is NOT present

  counties_where_tribe_present <- obtn_tribes %>%
    dplyr::filter(year == obtn_year) %>%
    dplyr::filter(tribe == tribe_to_plot) %>%
    dplyr::filter(present == "Y") %>%
    dplyr::pull(geography)

  # Using the %!in% operator created below, create a data frame for all other counties and bind it
  # Source: https://stackoverflow.com/questions/38351820/negation-of-in-in-r

  `%!in%` = Negate(`%in%`)

  all_other_counties <- obtn_oregon_counties %>%
    as.data.frame() %>%
    purrr::set_names("geography") %>%
    dplyr::filter(geography %!in% counties_where_tribe_present)

  # Create obtn_tribes_filtered

  obtn_tribes_filtered <- obtn_tribes %>%
    dplyr::filter(year == obtn_year) %>%
    dplyr::filter(tribe == tribe_to_plot) %>%
    dplyr::filter(present == "Y") %>%
    dplyr::bind_rows(all_other_counties) %>%
    dplyr::mutate(present = tidyr::replace_na(present, list(present = "N"))) %>%
    dplyr::mutate(present = as.character(present)) %>%
    dplyr::left_join(obtn_boundaries_oregon_counties, by = "geography") %>%
    sf::st_as_sf()


  # Plot

  ggplot2::ggplot(obtn_tribes_filtered) +
    ggplot2::geom_sf(ggplot2::aes(fill = present),
                     color = "white",
                     size = .35) +
    ggplot2::coord_sf(datum = NA) +
    ggplot2::scale_fill_manual(values = c(tfff_light_gray, tfff_dark_green)) +
    ggplot2::theme_void() +
    ggplot2::theme(text = ggplot2::element_text(family = "Calibri",
                                                size = 10),
                   legend.box.margin = ggplot2::margin(10,10,10,10),
                   legend.position = "none") +
    ggplot2::scale_x_continuous(expand = c(0, 0)) +
    ggplot2::scale_y_continuous(expand = c(0, 0))

  # Save plot

  tribe_to_plot_name <- stringr::str_glue("Tribe {tribe_to_plot}")

  obtn_save_plot(2020, tribe_to_plot_name, "Oregon", plot_width, plot_height)

}

