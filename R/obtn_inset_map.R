#' Make Inset Map
#'
#' @param county
#'
#' @return
#' @export
#'
#' @examples
obtn_make_inset_map <- function(county) {
  ggplot2::ggplot(obtn_boundaries_oregon_counties) +
    ggplot2::geom_sf(fill = tfff_medium_gray,
            color = "transparent") +
    ggplot2::geom_sf(data = dplyr::filter(obtn_boundaries_oregon_counties,
                          geography == county),
            fill = tfff_light_green,
            color = "white",
            size = 0.3) +
    ggplot2::coord_sf(datum = NA) +
    obtn_base_theme()
}
