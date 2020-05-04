#' Make a single median income plot
#'
#' @param county
#' @param obtn_year
#'
#' @return
#' @export
#'
#' @examples
#'
#'
#'
obtn_plot_median_income <- function(obtn_year, county_to_plot, plot_width = 2.43, plot_height = 0.61) {

  obtn_data_median_income_filtered <- obtn_data_median_income %>%
    dplyr::filter(year == obtn_year) %>%
    dplyr::filter(geography %in% c(county_to_plot, "Oregon")) %>%
    dplyr::mutate(type = dplyr::case_when(
      geography == "Oregon" ~ "state",
      TRUE ~ "county"
    )) %>%
    dplyr::mutate(geography = forcats::fct_reorder(geography, type)) %>%
    dplyr::mutate(geography = forcats::fct_rev(geography))

  obtn_data_median_income_filtered %>%

    # Add bars
    ggplot2::ggplot(ggplot2::aes(geography,
                        value,
                        fill = geography)) +
    ggplot2::geom_col(width = 0.75) +

    # Add county/state name
    ggplot2::geom_text(label = obtn_data_median_income_filtered$geography,
                       ggplot2::aes(geography, 2000),
                       hjust = 0,
                       color = "white",
                       family = "Calibri") +

    # Add median income amount text
    ggplot2::geom_text(label = scales::dollar(obtn_data_median_income_filtered$value),
                       ggplot2::aes(geography, value - 2000),
                       hjust = 1,
                       color = "white",
                       family = "Calibri") +

    ggplot2::scale_fill_manual(values = c(tfff_medium_gray, tfff_dark_green)) +
    ggplot2::scale_x_discrete(expand = c(0, 0)) +
    ggplot2::scale_y_continuous(expand = c(0, 0)) +
    ggplot2::coord_flip() +
    ggplot2::theme_void() +
    ggplot2::theme(legend.position = "none")

  obtn_save_plot(obtn_year, "Median Income", county_to_plot, plot_width, plot_height)

}



