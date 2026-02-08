# london ------------------------------------------------------------------

unmod_df <- autocruller::ac_get_co2_transit()

london_sf <- sf::st_read(
  # here::here("data/raw/london.geojson")
  "/Users/samherniman/projects/indoor_co2_map/data/raw/london.geojson"
)

lon_sf <- sf::st_intersection(unmod_df, london_sf)


df_df <- lon_sf |>
  dplyr::mutate(
    trans_type_assumed = dplyr::case_when(
      stringr::str_detect(
        lineName,
        "(Bakerloo|Central (L|l)ine|Circle|District|Hammersmith & City|Jubilee|Metropolitan|Northern|Piccadilly|Victoria (l|L)ine|Waterloo & City)"
      ) ~ "underground",
      stringr::str_detect(
        lineName,
        "(Lioness|Windrush|Weaver|Liberty|Mildmay|Suffragette)"
      ) ~ "overground",
      stringr::str_detect(lineName, ":") ~ "train",
      stringr::str_detect(lineName, " → ") ~ "bus"
    ),
    line_str = stringr::str_split_i(lineName, "(:| → )", 1),
    line_str = stringr::str_replace_all(
      line_str,
      "SWR",
      "South Western Railway"
    ) |>
      trimws(),
    co2Array = as.numeric(co2Array)
  ) |>
  dplyr::filter(line_str != "Train") |>
  dplyr::group_by(line_str) |>
  dplyr::mutate(journey_number = dplyr::dense_rank(uid)) |>
  dplyr::ungroup() |>
  dplyr::arrange(trans_type_assumed)

library(tidyplots)

tidyplot(
  # df_df[df_df$trans_type_assumed %in% c("underground", "overground"), ],
  df_df[df_df$trans_type_assumed == "train", ],
  # df_df,
  x = line_str,
  y = co2Array,
  color = journey_number
  # color = trans_type_assumed
) |>
  add_boxplot(fill = "#c9b7bf") |>
  add_data_points_beeswarm() |>
  sort_x_axis_labels(trans_type_assumed, .reverse = TRUE) |>
  adjust_x_axis(
    title = "Line name",
    rotate_labels = TRUE
  ) |>
  adjust_size(width = NA, height = NA, unit = "cm") |>
  adjust_font(fontsize = 12) |>
  adjust_y_axis_title("CO2 ppm") |>
  # adjust_legend_title("Transport type")|>
  # adjust_colors(new_colors = colors_discrete_seaside) |>
  adjust_legend_title("Journey number") |>
  remove_legend() |>
  adjust_caption("Data from indoorCO2map.com") |>
  add(
    ggplot2::scale_fill_continuous(
      guide = ggplot2::guide_coloursteps(show.limits = TRUE)
    )
  )

library(ggplot2)

df_df$line_str <- factor(
  df_df$line_str,
  levels = c("bus", "overground", "train", "underground")
)
# g_plot <-
df_df |>
  # dplyr::mutate(
  #   line_str = forcats::fct_relevel(line_str, "bus", "overground", "train", "underground")
  # ) |>
  ggplot(
    # data = df_df[df_df$trans_type_assumed == "underground",],
    # data = df_df,
    aes(x = line_str, y = co2Array)
  ) +
  geom_boxplot(aes(fill = trans_type_assumed)) +
  geom_jitter(
    aes(color = factor(journey_number)),
    height = 0,
    width = 0.2
  ) +
  scico::scale_color_scico_d(
    palette = "romaO"
  ) +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
    # axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=0.5)
  ) +
  guides(x = guide_axis(angle = 45))

tidyplot(
  df_df,
  x = trans_type_assumed,
  y = co2Array,
  color = co2Array
) |>
  add_boxplot() |>
  # add_data_points_beeswarm() |>
  # sort_x_axis_labels(trans_type_assumed, .reverse = TRUE) |>
  adjust_x_axis(
    title = "Transport type",
    rotate_labels = TRUE
  ) |>
  adjust_size(width = NA, height = NA, unit = "cm") |>
  adjust_font(fontsize = 12) |>
  adjust_y_axis_title("CO2 ppm") |>
  adjust_caption("Data from indoorCO2map.com")
# adjust_legend_title("Transport type")

df_df[df_df$trans_type_assumed == "underground", ]$co2Array |> median()

# buildings ---------------------------------------------------------------

unmod_df <- ac_get_co2()

london_sf <- sf::st_read(
  # here::here("data/raw/london.geojson")
  "/Users/samherniman/projects/indoor_co2_map/data/raw/london.geojson"
)

lon_sf <- sf::st_intersection(unmod_df, london_sf)
ac_df_long <- ac_unnest_longer(lon_sf)

library(tidyplots)
ac_df_long |>
  dplyr::filter(
    co2readings > 400
  ) |>
  tidyplot(
    x = osmtag,
    y = co2readings,
    color = co2readings
  ) |>
  add_boxplot() |>
  add_data_points_beeswarm() |>
  # sort_x_axis_labels(trans_type_assumed, .reverse = TRUE) |>
  adjust_x_axis(
    title = "Transport type",
    rotate_labels = TRUE
  ) |>
  adjust_size(width = NA, height = NA, unit = "cm") |>
  adjust_font(fontsize = 12) |>
  adjust_y_axis_title("CO2 ppm") |>
  adjust_caption("Data from indoorCO2map.com")
