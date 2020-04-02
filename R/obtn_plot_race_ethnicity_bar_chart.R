#' Title
#'
#' @param obtn_year
#' @param county_to_plot
#'
#' @return
#' @export
#'
#' @examples
obtn_plot_race_ethnicity_bar_chart <- function(obtn_year, county_to_plot, plot_width = 3.1, plot_height = 2.1) {

  obtn_race_ethnicity_order <- c("White",
                                "Latino",
                                "African American",
                                "Asian",
                                "Am Indian/Alaska Native",
                                "Native Hawaiian/Pacific Islander",
                                "Multiracial",
                                "Other Race") %>%
    rev()

  obtn_race_ethnicity_filtered <- obtn_race_ethnicity %>%
    dplyr::filter(year == obtn_year) %>%
    dplyr::filter(geography == county_to_plot) %>%
    dplyr::mutate(pct_formatted = scales::percent(value, 0.1)) %>%
    dplyr::mutate(population = forcats::fct_relevel(population, obtn_race_ethnicity_order)) %>%

    # Make all items less than .02 show up as .15 on the chart so you can actually see them
    dplyr::mutate(value = dplyr::case_when(
      pct_formatted == "0.1%" ~ .0019,
      TRUE ~ value
    ))



  ggplot2::ggplot(obtn_race_ethnicity_filtered,
                  ggplot2::aes(x = population, y = value)) +
    ggplot2::geom_bar(stat = "identity", fill = tfff_blue) +
    ggplot2::geom_text(data = dplyr::filter(obtn_race_ethnicity_filtered, population != "White"),
                       ggplot2::aes(population, value + .025,
                                    label = stringr::str_glue("{population}: {pct_formatted}")),
                       hjust = 0,
                       color = tfff_dark_gray,
                       family = "Calibri") +
    ggplot2::geom_text(data = dplyr::filter(obtn_race_ethnicity_filtered, population == "White"),
                       ggplot2::aes(population, value - .025,
                                    label = stringr::str_glue("{population}: {pct_formatted}")),
                       hjust = 1,
                       color = "white",
                       family = "Calibri") +
    ggplot2::scale_x_discrete(expand = c(0, 0)) +
    ggplot2::scale_y_continuous(expand = c(0, 0)) +
    ggplot2::theme_void() +
    ggplot2::coord_flip()

  obtn_save_plot(obtn_year, "Race Ethnicity Bar Chart", county_to_plot, plot_width, plot_height)

}



