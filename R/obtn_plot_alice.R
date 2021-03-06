#' Title
#'
#' @param obtn_year
#' @param county_to_plot
#' @param plot_width
#' @param plot_height
#'
#' @return
#' @export
#'
#' @examples
obtn_plot_alice <- function(obtn_year, county_to_plot, plot_width = 3.1, plot_height = 0.3574) {

  obtn_alice_data_filtered <- obtn_alice_data %>%
    dplyr::filter(geography == county_to_plot) %>%
    dplyr::filter(year == obtn_year)


  ggplot2::ggplot(obtn_alice_data_filtered,
                  ggplot2::aes(value, geography,
                               fill = level,
                               label = scales::percent(value, 1))) +
    ggplot2::geom_col(color = "white",
                      size = 1) +
    ggplot2::geom_text(position = ggplot2::position_stack(vjust = 0.5),
                       color = c("white", "black", tfff_light_gray),
                       fontface = "bold",
                       family = "Calibri") +
    ggplot2::scale_fill_manual(values = c(tfff_light_gray, tfff_light_green, tfff_dark_green)) +
    ggplot2::scale_x_continuous(expand = c(0, 0)) +
    ggplot2::scale_y_discrete(expand = c(0, 0)) +
    ggplot2::theme_void() +
    ggplot2::theme(legend.position = "none")


  obtn_save_plot(2020, "ALICE", county_to_plot, plot_width, plot_height)

}


