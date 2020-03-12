# library(tidyverse)
#
# obtn_public_land_geospatial %>%
#   filter(geography == "Baker") %>%
#   ggplot2::ggplot() +
#   ggplot2::geom_sf(data = dplyr::filter(obtn_boundaries_oregon_counties, geography == "Baker"),
#                    color = "transparent") +
#   ggplot2::geom_sf(fill = "#265142",
#           color = "transparent",
#           size = 0) +
#   theme_void()
#
# ggsave("inst/plots/2019/baker-public-lands.pdf",
#        device = cairo_pdf)
