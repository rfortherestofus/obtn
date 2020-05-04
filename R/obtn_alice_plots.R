fpl_2016 <- 24300


obtn_alice_data_thresholds %>%
  dplyr::mutate(gap = median_income - alice_threshold) %>%
  dplyr::mutate(gap_dichotomous = dplyr::case_when(
    gap > 0 ~ "Above",
    gap < 0 ~ "Below"
  )) %>%
  dplyr::mutate(geography = forcats::fct_reorder2(geography, gap, alice_threshold)) %>%
  dplyr::mutate(geography = forcats::fct_rev(geography)) %>%
  ggplot2::ggplot(ggplot2::aes(x = median_income,
                               xend = alice_threshold,
                               y = geography,
                               yend = geography,
                               color = gap_dichotomous)) +
  ggplot2::geom_segment() +
  # ggalt::geom_dumbbell(colour_xend = tfff_dark_green,
  #                      size = 1.5,
  #                      dot_guide = TRUE,
  #                      dot_guide_size=0.25,
  #                      dot_guide_colour = tfff_medium_gray) +
  ggplot2::scale_x_continuous(labels = scales::dollar_format(),
                              limits = c(20000, 65000),
                              breaks = seq(20000, 65000, by = 5000)) +
  ggplot2::labs(title = "<span style = 'color: #545454'>The <span style = 'color: #265142'><b>ALICE Threshold</b></span> is above the <span style = 'color: #B5CC8E'><b>Median Household Income</b></span> in all but one county</span>",
                subtitle = "<span style = 'color: #545454'>And the <span style = 'color: #283593'><b>Federal Poverty Level</b></span> is below both in all counties</span>") +
  ggplot2::theme_minimal(base_size = 14,
                         base_family = "Calibri") +
  ggplot2::theme(
    panel.grid.major.y = ggplot2::element_blank(),
    panel.grid.minor.y = ggplot2::element_blank(),
    panel.grid.minor.x = ggplot2::element_blank(),
    panel.grid.major.x = ggplot2::element_line(color = tfff_light_gray),
    axis.title = ggplot2::element_blank(),
    legend.position = "none",
    plot.title = ggtext::element_markdown(),
    plot.subtitle = ggtext::element_markdown()
  ) +
  ggplot2::geom_vline(xintercept = fpl_2016,
                      color = tfff_blue,
                      size = 0.75) +
  ggplot2::scale_color_manual(values = c(tfff_yellow,
                                         tfff_light_green))

ggsave("alice-plot.pdf",
       width = 10,
       height = 10,
       device = cairo_pdf)

ggsave("alice-plot.png",
       width = 10,
       height = 10)
