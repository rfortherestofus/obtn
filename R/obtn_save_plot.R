#' Title
#'
#' @param obtn_year
#' @param measure
#' @param geography
#' @param plot_width
#' @param plot_height
#'
#' @return
#' @export
#'
#' @examples
obtn_save_plot <- function(obtn_year, measure, geography, plot_width, plot_height) {

  measure <- stringr::str_to_lower(measure) %>%
    stringr::str_replace_all(",", "") %>%
    stringr::str_replace_all(" ", "-")


  geography <- stringr::str_to_lower(geography) %>%
    stringr::str_replace_all(" ", "-")

  file_name <- stringr::str_glue("{obtn_year}-{measure}-{geography}.pdf")

  file_path <- stringr::str_glue("inst/plots/{obtn_year}/")

  file_path_and_name <- stringr::str_glue("{file_path}{file_name}")

  ggplot2::ggsave(file_path_and_name,
                  width = plot_width,
                  height = plot_height,
                  device = cairo_pdf)

}
