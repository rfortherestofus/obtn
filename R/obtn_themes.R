#' Title
#'
#' @return
#' @export
#'
#' @examples
obtn_base_theme <- function() {
  ggplot2::theme_minimal(base_family = "Calibri", ...)
    # theme(panel.grid.minor = element_blank(),
    #       panel.background = element_rect(fill = "transparent",colour = NA),
    #       plot.background = element_rect(fill = "transparent",colour = NA),
    #       text = element_text(color = tfff_dark_gray,
    #                           family = "Calibri",
    #                           size = 10),
    #       title = element_text(family = "Calibri"),
    #       axis.text = element_text(color = tfff_dark_gray,
    #                                family = "Calibri"),
    #       axis.title = element_blank(),
    #       axis.ticks = element_blank(),
    #       panel.grid.major = element_line(color = tfff_light_gray),
    #       legend.position = "none",
    #       plot.margin = margin(-3, -3, -3, -3, "pt"),
    #       panel.spacing = margin(-3, -3, -3, -3, "pt"))
}
#
# tfff_area_theme <- tfff_base_theme + theme (
#   panel.grid.major.x = element_blank()
# )
#
# tfff_line_theme <- tfff_base_theme + theme (
#   panel.grid.major.x = element_blank()
# )
#
# tfff_line_theme_faceted <- tfff_area_theme + theme (
#   panel.spacing = unit(1, "lines"),
#   strip.background = element_rect(fill = "white"),
#   panel.grid.major.x = element_blank(),
#   strip.text = element_blank()
#   # axis.text.x = element_blank()
# )
#
# tfff_bar_chart_theme <- tfff_base_theme + theme(
#   axis.text.x = element_blank(),
#   axis.text.y = element_blank(),
#   panel.grid.major.x = element_blank(),
#   panel.grid.major.y = element_blank()
# )
#
# tfff_column_chart_theme <- tfff_base_theme + theme(
#   axis.text.y = element_blank(),
#   axis.text.x = element_text(color = tfff_dark_gray),
#   panel.grid.major.x = element_blank(),
#   panel.grid.major.y = element_blank()
# )
#
# tfff_population_pyramid_theme <- tfff_base_theme + theme(
#   axis.text.x = element_text(color = tfff_dark_gray),
#   axis.text.y = element_blank(),
#   panel.grid.major.x = element_line(color = tfff_light_gray),
#   panel.grid.major.y = element_blank(),
#   plot.margin = margin(3, 3, 3, 3, "pt"),
#   panel.spacing = margin(3, 3, 3, 3, "pt")
# )
#
# tfff_bar_chart_with_benchmark_theme <- tfff_base_theme + theme(
#   axis.text.x = element_blank(),
#   panel.grid.major.x = element_blank(),
#   panel.grid.major.y = element_blank()
# )
#
#
# tfff_map_theme <- tfff_base_theme + theme(
#   panel.grid.major.x = element_blank(),
#   panel.grid.major.y = element_blank(),
#   axis.text = element_blank(),
#   legend.position = "none",
#   legend.title = element_blank()
# )
