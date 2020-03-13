#' Make Map of Top Employment Industries in Oregon Counties
#'
#' @param obtn_year Year to plot
#' @param industry_to_plot Industry to plot
#' @param plot_width Plot width
#' @param plot_height Plot height
#'
#' @return
#' @export
#'
#' @examples
obtn_plot_top_employment_industries <- function(obtn_year, industry_to_plot, plot_width = 2, plot_height = 1.5) {

  obtn_top_employment_industries_filtered <- obtn_top_employment_industries %>%
    dplyr::filter(year == obtn_year) %>%
    dplyr::filter(industry == industry_to_plot) %>%
    dplyr::filter(geography %in% obtn_oregon_counties) %>%
    dplyr::left_join(obtn_boundaries_oregon_counties, by = "geography") %>%
    sf::st_as_sf()

  ggplot2::ggplot(obtn_top_employment_industries_filtered) +
    ggplot2::geom_sf(ggplot2::aes(fill = top_three_industry),
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

  industry_to_plot_name <- stringr::str_glue("Top Employment Industry {industry_to_plot}")

  obtn_save_plot(2020, industry_to_plot_name, "Oregon", plot_width, plot_height)

}

