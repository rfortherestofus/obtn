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
obtn_plot_population_pyramid <- function(obtn_year, county_to_plot, plot_width = 3.27, plot_height = 4.0752) {

  # Create data frame for this county

  obtn_population_pyramid_filtered <- obtn_population_pyramid %>%
    dplyr::filter(geography == county_to_plot) %>%
    dplyr::filter(year == obtn_year)


  # Define labels etc

  largest_group_pct <- max(obtn_population_pyramid_filtered$value)

  if (largest_group_pct < .04) {
    population_pyramid_labels <- c("4%", "2%",
                                   "0",
                                   "2%", "4%")
    population_pyramid_limit <- .04
    population_pyramid_labels_placement <- .01

    obtn_population_pyramid_filtered <- obtn_population_pyramid_filtered %>%
      dplyr::mutate(value_formatted = ifelse(gender == "female", -value, value))

  } else if (largest_group_pct < .06) {
    population_pyramid_labels <- c("6%", "4%", "2%",
                                   "0",
                                   "2%", "4%", "6%")

    population_pyramid_limit <- .06
    population_pyramid_labels_placement <- .01

    obtn_population_pyramid_filtered <- obtn_population_pyramid_filtered %>%
      dplyr::mutate(value_formatted = ifelse(gender == "female", -value, value))

  } else if (largest_group_pct < .08) {
    population_pyramid_labels <- c("8%", "6%", "4%", "2%",
                                   "0",
                                   "2%", "4%", "6%", "8%")

    population_pyramid_limit <- .08
    population_pyramid_labels_placement <- .02

    obtn_population_pyramid_filtered <- obtn_population_pyramid_filtered %>%
      dplyr::mutate(value = ifelse(value < .019, .015, value)) %>%
      dplyr::mutate(value_formatted = ifelse(gender == "female", -value, value))

  } else if (largest_group_pct < .1) {
    population_pyramid_labels <- c("10%", "8%", "6%", "4%", "2%",
                                   "0",
                                   "2%", "4%", "6%", "8%", "10%")
    population_pyramid_limit <- .1
    population_pyramid_labels_placement <- .03

    obtn_population_pyramid_filtered <- obtn_population_pyramid_filtered %>%
      dplyr::mutate(value = ifelse(value < .019, .02, value)) %>%
      dplyr::mutate(value_formatted = ifelse(gender == "female", -value, value))

  }


  ggplot2::ggplot(obtn_population_pyramid_filtered, ggplot2::aes(x = age, y = value_formatted,
                                                                 fill = gender,
                                                                 frame = geography)) +
    ggplot2::geom_hline(yintercept = 0, color = "white") +
    ggplot2::geom_bar(data = obtn_population_pyramid_filtered,
                      stat = "identity",
                      width = .7) +
    # Add labels in middle of two sets of bars
    ggplot2::geom_label(label = obtn_population_pyramid_filtered$age_labels,
                        ggplot2::aes(x = age, y = 0),
                        fill = "white",
                        family = "Calibri",
                        label.size = NA,
                        color = tfff_dark_gray) +
    # Add men label
    ggplot2::geom_label(ggplot2::aes(x = 17,
                                     y = (population_pyramid_limit - population_pyramid_labels_placement) * 1 ),
                        label = "Men",
                        color = "white",
                        family = "Calibri",
                        fill = tfff_blue,
                        label.size = 0,
                        label.r = ggplot2::unit(0, "lines"),
                        label.padding = ggplot2::unit(.3, "lines")) +
    ggplot2::geom_label(ggplot2::aes(x = 17,
                                     y = (population_pyramid_limit - population_pyramid_labels_placement) * -1),
                        label = "Women",
                        color = tfff_dark_gray,
                        family = "Calibri",
                        fill = tfff_light_blue,
                        label.size = 0,
                        label.r = ggplot2::unit(0, "lines"),
                        label.padding = ggplot2::unit(.3, "lines")) +
    ggplot2::coord_flip() +
    ggplot2::scale_y_continuous(breaks = seq(population_pyramid_limit * -1,
                                             population_pyramid_limit,
                                             by = .02),
                                limits = c(population_pyramid_limit * -1,
                                           population_pyramid_limit),
                                labels = population_pyramid_labels) +
    ggplot2::scale_fill_manual(values = c(tfff_light_blue, tfff_blue)) +
    ggplot2::theme_void(base_family = "Calibri",
                        base_size = 10) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(color = tfff_dark_gray,
                                                       size = 10,
                                                       margin = ggplot2::margin(3, 0, 0, 0, "pt")),
                   axis.text.y = ggplot2::element_blank(),
                   panel.grid.major.x = ggplot2::element_line(color = tfff_light_gray),
                   panel.grid.major.y = ggplot2::element_blank(),
                   plot.margin = ggplot2::margin(3, 3, 3, 3, "pt"),
                   panel.spacing = ggplot2::margin(3, 3, 3, 3, "pt"),
                   legend.position = "none")

  obtn_save_plot(obtn_year, "Population Pyramid", county_to_plot, plot_width, plot_height)

}
