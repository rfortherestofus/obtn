data(obtn_alice_data)

obtn_alice_data_filtered <- obtn_alice_data %>%
  dplyr::filter(geography == "Multnomah") %>%
  dplyr::filter(year == 2020)

pct_below_poverty_and_alice <- obtn_alice_data_filtered %>%
  dplyr::filter(level != "Above ALICE Threshold") %>%
  dplyr::summarize(total = sum(value)) %>%
  dplyr::pull(total) %>%
  scales::percent(1)

pct_below_poverty_and_alice_html <- str_glue("<span style ='font-size: 18pt; font-weight: bold; color: #000000;'>{pct_below_poverty_and_alice}</span>")

below_poverty_and_alice_text <- "Below <span style ='color: #265142;'>Poverty Level</span> and <span style ='color: #B5CC8E'>ALICE Threshold</span>"

plot_title <- str_glue("{pct_below_poverty_and_alice_html} {below_poverty_and_alice_text}")



ggplot2::ggplot(obtn_alice_data_filtered,
                ggplot2::aes(value, 1,
                             fill = level,
                             label = scales::percent(value, 1))) +
  ggplot2::geom_col(color = "white",
                    size = 2) +
  ggplot2::geom_text(position = ggplot2::position_stack(vjust = 0.5),
                     color = c("white", "black", tfff_light_gray),
                     fontface = "bold",
                     family = "Calibri") +
  ggplot2::labs(title = plot_title) +
  ggplot2::scale_fill_manual(values = c(tfff_light_gray, tfff_light_green, tfff_dark_green)) +
  ggplot2::theme_void() +
  ggplot2::theme(legend.position = "none",
                 plot.title = ggtext::element_markdown(color = tfff_medium_gray,
                                                       margin = margin(0, 0, 0, 20, "pt")))

