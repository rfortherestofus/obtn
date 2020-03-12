# Convert mm in ggplot to points. See https://gist.github.com/andrewheiss/93f3da5d6daa8c10c37cc97d8c8d83ab

#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
ggplot_pts <- function(x) {
  as.numeric(grid::convertUnit(grid::unit(x, "pt"), "mm"))
}
