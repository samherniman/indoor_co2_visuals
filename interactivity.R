library(ggiraph)

buildings_lines <-
  buildings_long_df_med |>
  dplyr::mutate(
    toolt = glue::glue(
      "{nwrname} {community_name} {best_country_name}\nType: {osmtag}\nMedian CO2: {median_co2}"
    )
  ) |>
  dplyr::group_by(obs_number) |>
  sf::st_drop_geometry() |>
  ggplot(aes(
    x = time_range,
    y = co2readings,
    color = median_co2,
    group = obs_number,
    tooltip = toolt,
    data_id = nwrname
  )) +
  geom_smooth_interactive(
    se = FALSE,
    # color = "grey80",
    linewidth = 0.5,
    hover_nearest = FALSE
  ) +
  # geom_smooth(
  #   data = lowest_building,
  #   mapping = aes(x = time_range, y = co2readings, color = obs_number),
  #   se = FALSE
  # ) +
  # geom_point(
  #   data = lowest_building,
  #   mapping = aes(x = time_range, y = co2readings),
  #   color = "blue",
  #   size = 4
  # ) +
  # geom_smooth(
  #   data = highest_building,
  #   mapping = aes(x = time_range, y = co2readings, color = obs_number),
  #   se = FALSE
  # ) +
  geom_point_interactive(
    mapping = aes(x = time_range, y = co2readings, color = co2readings),
    hover_nearest = FALSE
    # size = 4
  ) +
  scale_color_viridis_c() +
  # scico::scale_color_scico(palette = "managua", direction = -1) +
  # annotate(
  #   "label",
  #   x = .7,
  #   y = mean(lowest_building$ppmavg, na.rm = TRUE) + 140,
  #   label = unique(lowest_building$nwrname) |>
  #     stringr::str_flatten_comma(last = ' and ')
  # ) +
  # annotate(
  #   "label",
  #   x = .2,
  #   y = mean(highest_building$ppmavg, na.rm = TRUE) - 140,
  #   label = unique(highest_building$nwrname) |>
  #     stringr::str_flatten_comma(last = ' and ')
  # ) +
  # ylim(400, ylim_max) +
  labs(title = "Highest recording this month") +
  xlab("Time (from recording start to end)") +
  ylab(bquote(CO ~ 2)) +
  theme_minimal() +
  theme(
    text = element_text(size = 16),
    plot.title = element_text(size = 12),
    panel.grid = element_blank(),
    axis.text.x = element_text(size = 16),
    axis.line = element_line(
      colour = "black",
      linewidth = 1,
      linetype = "solid"
    ),
    legend.position = "none"
  )

girafe(
  buildings_lines,
  options = list(
    opts_hover_inv(css = "stroke:grey;opacity:0.1;"),
    opts_hover(css = "stroke-width:3px;")
  )
)

# install.packages("pak")
pak::pak("pandionlabs/ggspeciesaccumulation")
library(ggspeciesaccumulation)

buildings_labels <-
  buildings_wide_df |>
  tidyr::drop_na(community_name) |>
  dplyr::mutate(
    combined_id = as.factor(combined_id),
    community_name = as.factor(community_name)
  ) |>
  dplyr::group_by(community_name) |>
  dplyr::summarise(
    n_measurements = dplyr::n_distinct(obs_number),
    n_places = dplyr::n_distinct(combined_id)
  ) |>
  sf::st_drop_geometry()

buildings_wide_df |>
  tidyr::drop_na(community_name) |>
  # dplyr::mutate(
  #   combined_id = as.factor(combined_id)
  #   # community_name = as.factor(community_name)
  # ) |>
  # dplyr::group_by(community_name) |>
  sf::st_drop_geometry() |>
  dplyr::filter(
    community_name %in%
      c(
        "Bay Area",
        "Berlin",
        "Den Haag",
        "Dortmund-Essen-Duisburg-Dusseldorf",
        "Dresden",
        "Frankfurt-Manheim",
        "Goettingen",
        "Hamburg",
        "Hannover",
        "Koln",
        "Leipzig",
        "London",
        "Los Angeles Area",
        "Lubeck",
        "Munich",
        "New York City",
        "Nuremburg",
        "Paris",
        "Stuttgartt",
        "Wein",
        "Woodbridge"
      )
  ) |>
  ggplot2::ggplot(ggplot2::aes(
    species_key = combined_id,
    colour = community_name,
    group = community_name
  )) +
  stat_species_acc(geom = "smooth") +
  facet_wrap(vars(community_name)) +
  # geom_text(
  #   # data = buildings_labels,
  #   aes(
  #     x = dplyr::n_distinct(obs_number),
  #     y = dplyr::n_distinct(combined_id),
  #     label = community_name
  #   )
  #   # aes(x = n_measurements, y = n_places, label = community_name)
  # ) +
  ggplot2::labs(y = "Location", x = "Measurements") +
  ggplot2::xlim(NA, 1400) +
  ggplot2::ylim(NA, 600) +
  tidyplots_theme() +
  ggplot2::theme(
    axis.text.x = element_text(angle = 45),
    legend.position = "none"
  )

x |>
  tidyr::drop_na(route) |>
  dplyr::mutate(
    type = stringr::str_to_sentence(route) |>
      stringr::str_replace_all("_", " ")
  ) |>
  dplyr::group_by(type) |>
  dplyr::summarise(
    count = dplyr::n_distinct(uid)
  ) |>
  sf::st_drop_geometry() |>
  gt()
