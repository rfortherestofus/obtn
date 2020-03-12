#' Title
#'
#' @param obtn_year
#'
#' @return
#' @export
#'
#' @examples
obtn_make_all_plots <- function(obtn_year) {

  # Get list of all plots
  existing_plots <- fs::dir_ls(stringr::str_glue("inst/plots/{obtn_year}/"))

  # Delete them all
  fs::file_delete(existing_plots)

  # Make county-level median income bar charts
  purrr::pwalk(list(obtn_year, obtn_oregon_counties), obtn_plot_median_income)

  # Make county-level race/ethnicity bar charts
  purrr::pwalk(list(obtn_year, obtn_oregon_counties), obtn_plot_race_ethnicity_bar_chart)

  # Create vector of choropleth measures
  obtn_data_choropleth_measures_to_plot <- obtn_data_choropleth_measures %>%
    dplyr::filter(year == obtn_year) %>%
    dplyr::pull(measure)

  # Make all choropleth maps
  purrr::pwalk(list(obtn_year, obtn_data_choropleth_measures_to_plot), obtn_plot_choropleth_map)

}
