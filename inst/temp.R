ggplot2::ggplot(obtn_race_ethnicity_filtered,
                ggplot2::aes(x = population, y = value)) +
  ggplot2::geom_bar(ggplot2::aes(x = population, y = 1),
                    stat = "identity", fill = tfff_light_gray,
                    width = 0.5) +
  ggplot2::geom_bar(stat = "identity", fill = tfff_dark_green,
                    width = 0.5) +
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
  ggplot2::scale_y_continuous(expand = c(0, 0),
                              limits = c(0, 1)) +
  ggplot2::theme_void() +
  ggplot2::coord_flip()
