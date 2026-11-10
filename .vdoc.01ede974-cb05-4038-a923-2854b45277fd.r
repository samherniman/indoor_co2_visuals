#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| include: false
# things to add
# numbers of obs by category
# averages by category
# map showing observations over time animation
# lollipop summer vs winter shops - maybe summarize by category
# highest velocity based off of different time periods
start_date <- lubridate::ymd("2026-09-30")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| warning: false
#| message: false
#| include: false 
#| cache: false
source(here::here("functions/functions.R"))
#
#
#
#| warning: false
#| message: false
#| include: false
library(duckplyr)
buildings_wide_df <- autocruller::ac_get_co2("web") 
# saveRDS(buildings_wide_df, here::here("buildings_wide_df.rds"))
# buildings_wide_df <- readRDS(here::here("buildings_wide_df.rds"))

buildings_wide_df <- sf::st_join(buildings_wide_df, world_sf)

buildings_wide_df <- 
  buildings_wide_df |> 
  dplyr::rowwise() |>
    dplyr::mutate(
      best_country_name = name_ciawf %||% 
        brk_name %||%
        name_en %||%
        admin %||%
        name %||%
        countryname
    ) 

buildings_wide_df <- sf::st_join(
  buildings_wide_df,
  communities_sf,
  left = TRUE
  )

buildings_wide_df_short <-
  buildings_wide_df |>
    # sf::st_drop_geometry() |>
    filter_to_month(start_date) |>
    dplyr::mutate(type = "building")

transit_long_df <- autocruller::ac_get_co2("transit") 
# saveRDS(transit_long_df, here::here("transit_long_df.rds"))
# transit_long_df <- readRDS(here::here("transit_long_df.rds"))

#
#
#
#| include: false
#| warning: false
#| message: false
#| eval: true
# transit_long_df <- join_transit_osm(transit_long_df)
# saveRDS(transit_long_df, here::here("transit_long_df.rds"))
transit_long_df <- readRDS(here::here("transit_long_df.rds"))
#
#
#
#| warning: false
#| message: false
#| include: false
transit_long_df <- sf::st_join(transit_long_df, world_sf)

transit_long_df <- 
  transit_long_df |> 
  dplyr::rowwise() |>
    dplyr::mutate(
      best_country_name = name_ciawf %||% 
        brk_name %||%
        name_en %||%
        admin %||%
        sovereignt #%||%
        # name.y
    ) 

transit_long_df <- sf::st_join(
  transit_long_df,
  communities_sf,
  left = TRUE
  )
#
#
#
#| warning: false
#| message: false
#| include: false
transit_long_df_short <- 
transit_long_df |> 
    filter_to_month(start_date) |> 
        dplyr::mutate(type = "transit")
#
#
#
#
#| warning: false
#| message: false
#| include: false
common_building_types <- buildings_wide_df |> 
  dplyr::group_by(osmtag) |> 
  dplyr::count() |> 
  dplyr::filter(
    n > quantile(n, 0.98, na.rm = TRUE) & osmtag != ""
    )
#
#
#
#| warning: false
#| message: false
#| include: false 
# list new countries
new_countries_sentence <- form_new_countries_sentence(buildings_wide_df, buildings_wide_df_short)

#
#
#
#| eval: false
#| include: false
buildings_wide_df_short_geo <- geocode_buildings_or_transit(buildings_wide_df_short)

# saveRDS(buildings_wide_df_short_geo, here::here("data/derivative/buildings_wide_df_short_geo.rds"))
#
#
#
#| eval: false
#| include: false

transit_long_df_short_geo <- geocode_buildings_or_transit(transit_long_df_short)
  
# saveRDS(transit_long_df_short_geo, here::here("data/derivative/transit_long_df_short_geo.rds"))

#
#
#
#| include: false
#| eval: false

buildings_wide_df_short_geo <- 
  # buildings_wide_df_short_geo |> 
  readRDS(here::here("data/derivative/buildings_wide_df_short_geo.rds")) |> 
  dplyr::rowwise() |> 
  dplyr::mutate(
    location_description = glue::glue("{city %||% county %||% province %||% state %||% town %||% municipality %||% region %||% borough %||% suburb %||% neighbourhood %||% city_district}, {country}")
      ) |> 
    sf::st_as_sf(coords = c("X", "Y"), crs = sf::st_crs(buildings_wide_df_short))

buildings_wide_df_short <- sf::st_join(
  buildings_wide_df_short,
  buildings_wide_df_short_geo,
  left = TRUE,
  largest = TRUE
) |> dplyr::ungroup()

#
#
#
#| warning: false
#| message: false
#| include: false 

buildings_long_df <- autocruller::ac_unnest_longer(buildings_wide_df_short)
#
#
#
#| eval: false
#| include: false
transit_long_df_short_geo <- 
  # transit_long_df_short_geo |> 
  readRDS(here::here("data/derivative/transit_long_df_short_geo.rds")) |> 
  dplyr::rowwise() |> 
  dplyr::mutate(
    location_description = glue::glue("{city %||% county %||%  state %||% town %||% municipality %||% region %||% borough %||% suburb %||% neighbourhood %||% city_district}, {country}")
      ) |> 
     sf::st_as_sf(coords = c("X", "Y"), crs = sf::st_crs(transit_long_df_short))

transit_long_df_short <- transit_long_df_short |> 
  dplyr::mutate(osm_id_line = as.integer(osm_id_line))

# this doesn't work
# transit_long_df_short <- dplyr::left_join(
#   transit_long_df_short,
#   transit_long_df_short_geo,
#   by = dplyr::join_by(osm_id_line == place_id)
# )

transit_long_df_short <- sf::st_join(
  transit_long_df_short,
  transit_long_df_short_geo,
  left = TRUE,
  largest = TRUE
) |> dplyr::ungroup()
#
#
#
#| warning: false
#| message: false
#| include: false 
transit_long_df_short <- transit_long_df_short |> 
  dplyr::mutate(osm_id_line = stringr::str_extract(line, "[:digit:]+") |> as.integer()) |> 
  dplyr::filter(co2Array > 410)
#
#
#
#
#
#
#| warning: false
#| message: false
#| out.width: "100%"
library(gganimate)
library(rnaturalearth)
library(rnaturalearthhires)
countries_sf <- rnaturalearth::ne_countries(scale = 50L)
bbox_buildings <- sf::st_bbox(buildings_wide_df_short)
anim <-
  buildings_wide_df_short |>
  dplyr::mutate(day = as.Date(date)) |>
  ggplot2::ggplot() +
  ggplot2::geom_sf(data = countries_sf, fill = "white") +
  ggplot2::geom_sf(aes(colour = ppmavg), size = 2) +
  gganimate::transition_time(day) +
  gganimate::enter_grow() +
  gganimate::shadow_mark(past = TRUE, future = FALSE, alpha = 0.6 
  # color = "grey"
  ) +
  xlim(bbox_buildings[1] - 1, bbox_buildings[3] + 1) +
  ylim(bbox_buildings[2] - 1, bbox_buildings[4] + 1) +
  scale_color_viridis_c(
    name = "Mean CO2 ppm",
    breaks = c(420, 600, 800, 1200, 2000, 4000),
    transform = "log2",
    option = "turbo"
  ) +
  theme(
    plot.background = ggplot2::element_rect(fill = NA, colour = NA),
    plot.title = ggplot2::element_text(size = ggplot2::rel(1.5)),
    legend.background = ggplot2::element_rect(fill = NA, colour = NA),
    legend.key = ggplot2::element_rect(fill = NA, colour = NA),
    legend.key.width = unit(0.6, "lines"),
    legend.key.height = unit(1, "lines"),
    strip.background = ggplot2::element_rect(fill = "#cbd6dfff", colour = NA),
    panel.background = ggplot2::element_rect(fill = "#cbd6dfff", colour = NA),
    panel.border = ggplot2::element_rect(
      fill = NA,
      colour = "black",
      linewidth = 0.5
    ),
    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_line(colour = "black", linewidth = 0.25),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14)
  ) +
  ggtitle("{frame_time}")

animate(
  anim,
  nframes = 32,
  driver = 'png',
  # quality = 40,
  # nframes = 260,
  fps = 5
) |> magick::image_trim()
# anim_save(here::here("data/derivative/animation.gif"), anim2)

#
#
#
#
#
#| echo: false
#| warning: false
#| message: false
#| include: false 
most_measured <- 
buildings_wide_df_short |> 
  summarise_most_measured_buildings()

mean_vals <- buildings_wide_df_short |>
  sf::st_drop_geometry() |> 
    dplyr::filter(
      ppmavg >= 410
    ) 
  
#
#
#
#| warning: false
#| message: false
#| include: false 
countries_count <- 
buildings_wide_df_short |> 
    dplyr::select(uid = obs_number, best_country_name, type) |> 
    sf::st_drop_geometry() 

countries_count_transit <- 
    transit_long_df_short |> 
    dplyr::group_by(uid, best_country_name, type) |> 
    dplyr::count() |> 
    dplyr::select(-n) |> 
    # dplyr::summarise(n = dplyr::n_distinct(uid)) |> 
    # tidyr::drop_na() |> 
    sf::st_drop_geometry()

countries_count <- 
  dplyr::bind_rows(countries_count, countries_count_transit) 
  # dplyr::left_join(iso_3166_a2, by = dplyr::join_by(country_code == code))  
  

# countries_count <- countries_count[order(countries_count$n, decreasing = TRUE),] |> 
#   tidyr::drop_na()
countries_count <- 
    countries_count |>
      # dplyr::mutate(
      #   type = forcats::fct_relevel(type, "building", "transit"), #|> forcats::fct_rev()
      #   # best_country_name = forcats::fct_infreq(best_country_name) |> forcats::fct_rev()
        
      #   ) |> 
      dplyr::group_by(best_country_name, type) |> 
      dplyr::count() 



countries_labels <- 
  countries_count |> 
  tidyr::pivot_wider(names_from = type, values_from = n) |>
  dplyr::mutate(
    building = tidyr::replace_na(building, 0),
    transit = sum(transit, building, na.rm = FALSE)) |> 
    dplyr::mutate(
    building = dplyr::na_if(building, 0)
    ) |> 
  tidyr::pivot_longer(!best_country_name, names_to = "type", values_to = "label_n") |> 
  tidyr::drop_na()

countries_count <- 
  dplyr::left_join(
    countries_count,
    countries_labels,
    by = dplyr::join_by(best_country_name, type)
  ) |> 
    dplyr::arrange(dplyr::desc(label_n))

countries_count$best_country_name <- factor(
  countries_count$best_country_name, 
  levels = unique(countries_count$best_country_name) |> rev()
  )

countries_count <- 
  countries_count |> 
  dplyr::ungroup() |> 
  dplyr::filter(best_country_name != "") |> 
    dplyr::mutate(
        # best_country_name = forcats::fct_relevel(best_country_name, country_order)
        # best_country_name = forcats::fct_infreq(best_country_name) |> forcats::fct_rev()

        type = forcats::fct_relevel(
          type, 
          "transit", 
          "building"
          ) |> forcats::fct_rev()
        )

#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
buildings_wide_df_short |> plot_histogram_co2()
#
#
#
#
#
#
#
#
#| eval: false
#| include: false
countries_count <- 
buildings_wide_df_short |> 
    dplyr::group_by(country_code, type.x) |> 
    dplyr::count() |> 
    tidyr::drop_na() |> 
    sf::st_drop_geometry() |> 
    dplyr::ungroup()

# not yet done. need to give transit data a country col
countries_count_transit <- 
    transit_long_df_short |> 
    dplyr::group_by(country_code, type.x) |> 
    dplyr::summarise(n = dplyr::n_distinct(uid)) |> 
    tidyr::drop_na() |> 
    sf::st_drop_geometry()

countries_count <- 
  dplyr::bind_rows(countries_count, countries_count_transit) |> 
  dplyr::left_join(iso_3166_a2, by = dplyr::join_by(country_code == code)) |> 
  dplyr::mutate(
    type.x = factor(type.x, levels = c("building", "transit"))
    )

countries_count <- countries_count[order(countries_count$n, decreasing = TRUE),] |> 
  tidyr::drop_na()
#
#
#
#| eval: false
#| include: false
#| warning: false
#| message: false

countries_count |> plot_countries_count()
  
#
#
#
#| warning: false
#| error: false
#| message: false
#| fig.asp: 1.05
countries_count |> 
  tidyr::drop_na() |> 
  dplyr::rowwise() |> 
  dplyr::mutate(
    label_n = dplyr::if_else(
      type == "transit" && n < 10 && label_n != n,
      label_n + 16,
      label_n
      )
      ) |> 
  # dplyr::filter(n > 1) |> 
    ggplot2::ggplot(aes(x = best_country_name, y = n, fill = forcats::fct_rev(type))) +
    geom_col() +
    # ggrepel::geom_text_repel(
    geom_text(
      aes(y = label_n, label = n), 
      vjust = -0.5, 
      colour = "black",
      # min.segment.length = 1000,
      # direction = "y"
      # box.padding = 0.1
      # point.padding = 0.1
      ) +
    # scico::scale_fill_scico_d() +
    scale_fill_manual(values = c("#FFBB34", "#295059")) +
    labs(x = "Country", y = "Number of measurements") +
    tidyplots_theme() +
    theme(
      legend.title = element_blank(),
      axis.text.x = element_text(
      angle = 45, 
      # vjust = 0.5, 
      hjust=1)
      )
#
#
#
#
#
#
#
#
#
#
#
#| include: true
#| eval: false
#| warning: false
#| message: false
#| fig.asp: 1.2

plot_building_types_1(buildings_wide_df)
#
#
#
#
#
#| include: true
#| eval: true
#| warning: false
#| message: false
#| fig.asp: 1.2

plot_building_types_2(buildings_long_df)
#
#
#
#
#
#| warning: false
#| message: false
#| include: false 

buildings_long_df_med <- buildings_long_df |> 
  dplyr::filter(
    co2readings >= 410
  ) |> 
    dplyr::group_by(obs_number) |> 
    dplyr::mutate(
      median_co2 = median(co2readings),
      time_n = dplyr::row_number(),
      time_range = range01(time_n)
      # description_str = glue::glue("{nwrname} in {location_description}")
    ) |> 
      dplyr::ungroup()

highest_building <- buildings_long_df_med |> 
  dplyr::slice_max(order_by = median_co2) |> 
  sf::st_as_sf() |> 
  geocode_and_join() |> 
  add_all_town_cols(cols = cols) |> 
  dplyr::rowwise() |> 
  describe_location() |> 
  dplyr::mutate(description_str = glue::glue("{nwrname} in {location_description}"))

lowest_building <- buildings_long_df_med |> 
  dplyr::slice_min(order_by = median_co2) |> 
  sf::st_as_sf() |> 
  geocode_and_join() |> 
    add_all_town_cols(cols = cols) |> 
  dplyr::rowwise() |> 
  describe_location() |> 
  dplyr::mutate(description_str = glue::glue("{nwrname} in {location_description}"))
#
#
#
#| warning: false
#| message: false
#| include: false 

lowest_sentence <- lowest_building |> 
  dplyr::group_by(obs_number) |> 
  dplyr::summarise(
    description_str = dplyr::first(description_str),
    median_co2 = dplyr::first(median_co2)
  ) |> 
    describe_buildings(measure = "lowest")

highest_sentence <- highest_building |> 
  dplyr::group_by(obs_number) |> 
  dplyr::summarise(
    description_str = dplyr::first(description_str),
    median_co2 = dplyr::first(median_co2)
  ) |> 
    describe_buildings(measure = "highest")

co2_threshold <- 500

buildings_under_threshold <- 
  buildings_long_df_med |>
  dplyr::filter(median_co2 < co2_threshold) |>
  sf::st_as_sf() |> 
  geocode_and_join() |> 
  add_all_town_cols(cols = cols) |> 
  dplyr::rowwise() |> 
  describe_location() |>
  dplyr::group_by(obs_number) |>
    dplyr::summarise(
      name = dplyr::first(nwrname),
      co2 = dplyr::first(median_co2),
      windows = dplyr::first(openwindows),
      osmtag = dplyr::first(osmtag) |> stringr::str_to_sentence(),
      location_description = dplyr::first(location_description)
    ) |>
    dplyr::select(
      -obs_number
    ) 
  # list_buildings_under_threshold(co2_threshold)
#
#
#
#
#
#
#
#
#
#
#| warning: false
#| eval: false

create_co2_tibble(highest_building) |> 
plot_building_co2_vs_time()
#
#
#
#| warning: false
#| eval: false

create_co2_tibble(lowest_building) |> 
  plot_building_co2_vs_time()

#
#
#
#
#
#| warning: false
#| message: false
#| include: true 
#| fig.asp: 1.2
ylim_max <- max(highest_building$co2readings) + 200
plot_all_curves(sf::st_drop_geometry(buildings_long_df_med), ylim_max)
#
#
#
#
#
#
#
#
#| warning: false
#| message: false
#| include: true 

# add a column showing how many times a building has been on this list
# buildings_under_threshold |> 
#   knitr::kable(
#     col.names = c("Name", "Median CO<sup>2</sup>", "Building type", "Location")
#   )
buildings_under_threshold |> 
  sf::st_drop_geometry() |> 
gt_buildings_under_threshold()
#
#
#
#
#
#| warning: false
#| message: false
#| out.width: "100%"
bbox_buildings <- sf::st_bbox(buildings_wide_df)
anim <-
  buildings_wide_df |>
  dplyr::mutate(day = as.Date(date)) |>
  ggplot2::ggplot() +
  ggplot2::geom_sf(data = countries_sf, fill = "white") +
  ggplot2::geom_sf(aes(colour = ppmavg), size = 2) +
  gganimate::transition_time(day) +
  gganimate::enter_grow() +
  # gganimate::exit_shrink() +
  shadow_mark(past = TRUE, future = FALSE, alpha = 0.6 
  # color = "grey"
  ) +
  # xlim(0, 17) +
  # ylim(44.340868, 55.22535) +
  xlim(bbox_buildings[1] - 1, bbox_buildings[3] + 1) +
  ylim(bbox_buildings[2] - 1, bbox_buildings[4] + 1) +
  scale_color_viridis_c(
    name = "Mean CO2 ppm",
    breaks = c(420, 600, 800, 1200, 2000, 4000),
    transform = "log2",
    option = "turbo"
  ) +
  theme(
    plot.background = ggplot2::element_rect(fill = NA, colour = NA),
    plot.title = ggplot2::element_text(size = ggplot2::rel(1.5)),
    legend.background = ggplot2::element_rect(fill = NA, colour = NA),
    legend.key = ggplot2::element_rect(fill = NA, colour = NA),
    legend.key.width = unit(0.6, "lines"),
    legend.key.height = unit(1, "lines"),
    strip.background = ggplot2::element_rect(fill = "#cbd6dfff", colour = NA),
    panel.background = ggplot2::element_rect(fill = "#cbd6dfff", colour = NA),
    panel.border = ggplot2::element_rect(
      fill = NA,
      colour = "black",
      linewidth = 0.5
    ),
    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_line(colour = "black", linewidth = 0.25),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14)
  ) +
  ggtitle("{frame_time}")
frames_vec <- (length(unique(lubridate::date(buildings_wide_df$date)))/2) |> round(digits = 0)
animate(
  anim,
  nframes = frames_vec,
  driver = 'png',
  # quality = 40,
  # nframes = 260,
  fps = 25
) |> magick::image_trim()
# anim_save(here::here("data/derivative/animation.gif"), anim2)

#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
buildings_wide_df <- 
  buildings_wide_df |> 
  add_meteorological_week()
#
#
#
#| include: false
#| eval: false
plot_buildings_boxplot_date_vs_co2(buildings_wide_df) 
#
#
#
#| include: true
#| eval: true
#| warning: false
#| message: false

plot_buildings_week_co2(buildings_wide_df)
#
#
#
#
#
#
#
#
#
#
#
#| include: true
#| eval: true
#| warning: false
#| message: false

plot_metweek_type(buildings_wide_df)
#
#
#
#
#
#| warning: false
#| message: false
#| include: false 
measurements_this_year <- 
  buildings_wide_df |> 
  dplyr::filter(dplyr::between(
        date,
        lubridate::today() - lubridate::weeks(52),
        lubridate::today()
    ))|>
       nrow() 
#
#
#
#
#
#
#
#| include: true
#| eval: true
#| warning: false
#| message: false
plot_all_histogram(buildings_wide_df)
#
#
#
#
#
#
#
#
#| eval: false

communities_count <- 
buildings_wide_df_short |> 
    # dplyr::mutate(type = "building") |> 
    dplyr::select(uid = obs_number, community_name, type) |> 
    sf::st_drop_geometry() |> 
    tidyr::drop_na()

communities_count_transit <-
  transit_long_df_short |>
  # dplyr::mutate(type = "transit") |>
  dplyr::group_by(uid, community_name, type) |>
  dplyr::count() |>
  dplyr::select(-n) |>
  sf::st_drop_geometry() |>
  tidyr::drop_na()

communities_count <-
  dplyr::bind_rows(communities_count, communities_count_transit) 

communities_count <-
  communities_count |>
  dplyr::group_by(community_name, type) |>
  dplyr::count() 



communities_labels <-
  communities_count |>
  tidyr::pivot_wider(names_from = type, values_from = n) |>
  dplyr::mutate(
    building = tidyr::replace_na(building, 0),
    transit = sum(transit, building, na.rm = FALSE)
  ) |>
  dplyr::mutate(
    building = dplyr::na_if(building, 0)
  ) |>
  tidyr::pivot_longer(
    !community_name,
    names_to = "type",
    values_to = "label_n"
  ) |>
  tidyr::drop_na()

communities_count <-
  dplyr::left_join(
    communities_count,
    communities_labels,
    by = dplyr::join_by(community_name, type)
  ) |>
  dplyr::arrange(dplyr::desc(label_n))

communities_count$community_name <- factor(
  communities_count$community_name, 
  levels = unique(communities_count$community_name) |> rev()
  )

communities_count <- 
  communities_count |> 
  dplyr::ungroup() |> 
  dplyr::filter(community_name != "") |> 
    dplyr::mutate(
        # community_name = forcats::fct_relevel(community_name, country_order)
        # community_name = forcats::fct_infreq(community_name) |> forcats::fct_rev()

        type = forcats::fct_relevel(
          type, 
          "transit", 
          "building"
          ) |> forcats::fct_rev()
        )

#
#
#
#| eval: false
communities_count |>
  tidyr::drop_na() |>
  dplyr::rowwise() |>
  dplyr::mutate(
    label_n = dplyr::if_else(
      type == "transit" && n < 6 && label_n != n,
      label_n + 6,
      label_n
    )
  ) |>
  # dplyr::filter(n > 1) |>
  ggplot2::ggplot(aes(
    x = community_name,
    y = n,
    fill = forcats::fct_rev(type)
  )) +
  geom_col() +
  # ggrepel::geom_text_repel(
  geom_text(
    aes(y = label_n, label = n),
    vjust = -0.5,
    colour = "black",
    # min.segment.length = 1000,
    # direction = "y"
    # box.padding = 0.1
    # point.padding = 0.1
  ) +
  # scico::scale_fill_scico_d() +
  scale_fill_manual(values = c("#FFBB34", "#295059")) +
  labs(x = "Country", y = "Number of measurements") +
  tidyplots_theme() +
  theme(
    legend.title = element_blank(),
    axis.text.x = element_text(
      angle = 45,
      # vjust = 0.5,
      hjust = 1
    )
  )

#
#
#
#
#
#| warning: false
#| message: false
#| out.width: "100%"
bbox_transit <- sf::st_bbox(transit_long_df_short)
anim <-
  transit_long_df_short |>
  dplyr::mutate(day = as.Date(date)) |>
  ggplot2::ggplot() +
  ggplot2::geom_sf(data = countries_sf, fill = "white") +
  ggplot2::geom_sf(aes(colour = co2Array), size = 2) +
  gganimate::transition_time(day) +
  gganimate::enter_grow() +
  # gganimate::exit_shrink() +
  shadow_mark(past = TRUE, future = FALSE, alpha = 0.6 
  # color = "grey"
  ) +
  # xlim(0, 17) +
  # ylim(44.340868, 55.22535) +
  xlim(bbox_transit[1] - 1, bbox_transit[3] + 1) +
  ylim(bbox_transit[2] - 1, bbox_transit[4] + 1) +
  scale_color_viridis_c(
    name = "Mean CO2 ppm",
    breaks = c(420, 600, 800, 1200, 2000, 4000),
    transform = "log2",
    option = "turbo"
  ) +
  theme(
    plot.background = ggplot2::element_rect(fill = NA, colour = NA),
    plot.title = ggplot2::element_text(size = ggplot2::rel(1.5)),
    legend.background = ggplot2::element_rect(fill = NA, colour = NA),
    legend.key = ggplot2::element_rect(fill = NA, colour = NA),
    legend.key.width = unit(0.6, "lines"),
    legend.key.height = unit(1, "lines"),
    strip.background = ggplot2::element_rect(fill = "#cbd6dfff", colour = NA),
    panel.background = ggplot2::element_rect(fill = "#cbd6dfff", colour = NA),
    panel.border = ggplot2::element_rect(
      fill = NA,
      colour = "black",
      linewidth = 0.5
    ),
    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_line(colour = "black", linewidth = 0.25),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14)
  ) +
  ggtitle("{frame_time}")
# frames_vec <- (length(unique(lubridate::date(transit_long_df_short$date)))/2) |> round(digits = 0)
animate(
  anim,
  nframes = 31,
  driver = 'png',
  # quality = 40,
  # nframes = 260,
  fps = 5
) |> magick::image_trim()
# anim_save(here::here("data/derivative/animation.gif"), anim2)

#
#
#
#| echo: false
#| warning: false
#| message: false
#| include: false 
#| eval: true

# not evaluated because osmdata is not working
most_measured_transit <- 
transit_long_df_short |> 
summarise_most_measured_transit()
  
#
#
#
#
#
#
#
#
#
#
#| warning: false
#| message: false
#| include: false 
transit_count <- 
transit_long_df_short |> 
  count_transit()
#
#
#
#| warning: false
#| message: false
#| include: false 
# transit_count |> 
#   plot_transit_count_bar()
#
#
#
#
#
#
#
#
#
#| include: true
#| eval: true
#| warning: false
#| message: false

# not evaluated because osmdata is not working

transit_long_df_short |> 
  tidyr::drop_na(route) |> 
  plot_transit_month_box()
#
#
#
#
#
#
#
#
#
#| include: true
#| eval: true
#| warning: false
#| message: false

# not evaluated because osmdata is not working

transit_long_df |> 
  plot_transit_all_box()
#
#
#
#
#
#
#| warning: false
#| message: false
#| include: false 
transit_long_df <- 
  transit_long_df |> 
  add_meteorological_week()
#
#
#
#| include: false
#| eval: false
#| warning: false
#| message: false

transit_long_df |> 
  plot_transit_met_week()
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| warning: false
grateful::cite_packages(output = "paragraph", out.dir = ".")
#
#
#
#
#
#
