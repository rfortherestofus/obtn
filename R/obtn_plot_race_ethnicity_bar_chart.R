#' Title
#'
#' @param obtn_year
#' @param county_to_plot
#'
#' @return
#' @export
#'
#' @examples
obtn_plot_race_ethnicity_bar_chart <- function(obtn_year,
                                               geography_to_plot,
                                               plot_width = 3.1,
                                               plot_height = 2.1) {

  obtn_race_ethnicity_order <- rev(c("American Indian/Alaska Native",
                                     "Asian",
                                     "Black/African American",
                                     "Hispanic/Latino",
                                     "Native Hawaiian/Pacific Islander",
                                     "Some other race",
                                     "Two or more races",
                                     "White"))

  obtn_race_ethnicity_filtered <- obtn_race_ethnicity %>%
    dplyr::filter(year == obtn_year) %>%
    dplyr::filter(geography == geography_to_plot) %>%
    dplyr::mutate(pct_formatted = scales::percent(value, 0.1)) %>%
    dplyr::mutate(population = forcats::fct_relevel(population, obtn_race_ethnicity_order)) %>%

    # Make all items less than .02 show up as .15 on the chart so you can actually see them
    dplyr::mutate(value = dplyr::case_when(
      pct_formatted == "0.1%" ~ .0019,
      TRUE ~ value
    )) %>%

    # Create position for text labels
    dplyr::mutate(text_position = dplyr::case_when(
      value > 0.3 ~ value - 0.025,
      TRUE ~ value + 0.025
    )) %>%
    dplyr::mutate(text_color = dplyr::case_when(
      value > 0.3 ~ "white",
      TRUE ~ tfff_dark_gray
    ))

  if (geography_to_plot %in% obtn_oregon_counties) {
    ggplot2::ggplot(obtn_race_ethnicity_filtered,
                    ggplot2::aes(x = population, y = value)) +
      ggplot2::geom_bar(stat = "identity", fill = tfff_dark_green) +
      ggplot2::geom_text(data = dplyr::filter(obtn_race_ethnicity_filtered, population != "White"),
                         ggplot2::aes(population, value + .025,
                                      label = stringr::str_glue("{population}: {pct_formatted}")),
                         hjust = 0,
                         size = 2.75,
                         color = tfff_dark_gray,
                         family = "Calibri") +
      ggplot2::geom_text(data = dplyr::filter(obtn_race_ethnicity_filtered, population == "White"),
                         ggplot2::aes(population, value - .025,
                                      label = stringr::str_glue("{population}: {pct_formatted}")),
                         hjust = 1,
                         size = 2.75,
                         color = "white",
                         family = "Calibri") +
      ggplot2::scale_x_discrete(expand = c(0, 0)) +
      ggplot2::scale_y_continuous(expand = c(0, 0)) +
      ggplot2::theme_void() +
      ggplot2::coord_flip()

  } else {
    ggplot2::ggplot(obtn_race_ethnicity_filtered,
                    ggplot2::aes(x = population, y = value)) +
      ggplot2::geom_bar(stat = "identity", fill = tfff_dark_green) +
      ggplot2::geom_text(data = dplyr::filter(obtn_race_ethnicity_filtered, population != "White"),
                         ggplot2::aes(population, value + .025,
                                      label = stringr::str_glue("{population}: {pct_formatted}")),
                         hjust = 0,
                         size = 2.75 * 1.5,
                         color = tfff_dark_gray,
                         family = "Calibri") +
      ggplot2::geom_text(data = dplyr::filter(obtn_race_ethnicity_filtered, population == "White"),
                         ggplot2::aes(population, value - .025,
                                      label = stringr::str_glue("{population}: {pct_formatted}")),
                         hjust = 1,
                         size = 2.75 * 1.5,
                         color = "white",
                         family = "Calibri") +
      ggplot2::scale_x_discrete(expand = c(0, 0)) +
      ggplot2::scale_y_continuous(expand = c(0, 0),
                                  limits = c(0, 0.85)) +
      ggplot2::theme_void() +
      ggplot2::coord_flip()
  }

obtn_save_plot(obtn_year, "Race Ethnicity Bar Chart", geography_to_plot, plot_width, plot_height)

}

