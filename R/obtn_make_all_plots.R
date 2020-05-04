#' Title
#'
#' @param obtn_year
#'
#' @return
#' @export
#'
#' @examples
obtn_make_all_plots <- function(obtn_year = 2020) {

  # Delete existing plots ---------------------------------------------------

  # Get list of all plots
  existing_plots <- fs::dir_ls(stringr::str_glue("inst/plots/{obtn_year}/"))

  # Delete them all
  fs::file_delete(existing_plots)


  # Largest Community -------------------------------------------------------

  obtn_plot_largest_community(2020)

  # Tribes Maps -------------------------------------------------------------

  # Create vector of tribes
  obtn_tribes_vector <- obtn_tribes %>%
    dplyr::filter(year == obtn_year) %>%
    dplyr::distinct(tribe) %>%
    dplyr::pull(tribe)

  # Make all top industry maps
  purrr::pwalk(list(obtn_year, obtn_tribes_vector), obtn_plot_tribes_map)


  # State/Rural/Urban Population Pyramids -----------------------------------
  purrr::pwalk(list(obtn_year, obtn_oregon_counties), obtn_plot_population_pyramid)


  # County-Level Population Pyramids ----------------------------------------
  purrr::pwalk(list(obtn_year, c("Oregon", "Rural", "Urban"), 3, 4), obtn_plot_population_pyramid)


  # ALICE -------------------------------------------------------------------
  purrr::pwalk(list(obtn_year, obtn_oregon_counties), obtn_plot_alice)


  # Median Income Bar Charts ------------------------------------------------
  purrr::pwalk(list(obtn_year, obtn_oregon_counties), obtn_plot_median_income)


  # County-Level Race/Ethnicity Bar Charts ----------------------------------
  purrr::pwalk(list(obtn_year, obtn_oregon_counties), obtn_plot_race_ethnicity_bar_chart)


  # State/Rural/Urban Race/Ethnicity Bar Charts -----------------------------
  purrr::pwalk(list(obtn_year, c("Oregon", "Rural", "Urban"), 4.3684, 3.25), obtn_plot_race_ethnicity_bar_chart)


  # Choropleth Maps ---------------------------------------------------------

  # Create vector of choropleth measures
  obtn_data_choropleth_measures_to_plot <- obtn_data_choropleth_measures %>%
    dplyr::filter(year == obtn_year) %>%
    dplyr::pull(measure)

  # Make all choropleth maps
  purrr::pwalk(list(obtn_year, obtn_data_choropleth_measures_to_plot), obtn_plot_choropleth_map)


  # Race/Ethnicity Statewide Maps -------------------------------------------

  obtn_plot_multiple_race_ethnicity_choropleth_maps()

  obtn_save_plot(2020, "race-ethnicity", "oregon", 7.5, 10)

  # Top Employment Industries -----------------------------------------------

  # Create vector of industries
  obtn_industries <- obtn_top_employment_industries %>%
    dplyr::filter(year == obtn_year) %>%
    dplyr::distinct(industry) %>%
    dplyr::pull(industry)

  # Make all top industry maps
  purrr::pwalk(list(obtn_year, obtn_industries), obtn_plot_top_employment_industries)

}

