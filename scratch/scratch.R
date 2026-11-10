test_df <-
  buildings_wide_df |>
  dplyr::filter(countryname %in% eu_countries$country)

# pak::pak("dbscan")
buildings_dbscan <- dbscan::optics(sf::st_coordinates(test_df), minPts = 20)
plot(buildings_dbscan)
# buildings_dbscan$order
plot(sf::st_coordinates(test_df), col = "grey")

res <- dbscan::extractDBSCAN(buildings_dbscan, eps_cl = .2)
dbscan::hullplot(sf::st_coordinates(test_df), res)

# pak::pak("samherniman/autocruller")

buildings_wide_df_count <-
  buildings_wide_df |>
  dplyr::group_by(combined_id) |>
  dplyr::summarise(
    n = dplyr::n(),
    nwrname = dplyr::first(nwrname),
    osmtag = dplyr::first(osmtag),
    countryname = dplyr::first(countryname),
    co2ppm = median(ppmavg)
  ) |>
  dplyr::slice_max(n, n = 40)

mapview::mapview(buildings_wide_df_count, zcol = "n")


# code not used ----------------------------------------------------------

# Attempt at using h3 to standardize geocoded locations

# buildings_wide_df_short_geo <-
buildings_h3 <-
  buildings_wide_df_short |>
  sf::st_coordinates()

buildings_h3 <-
  h3::geo_to_h3(buildings_h3[, ncol(buildings_h3):1], 5)

buildings_wide_df_short_geo <-
  buildings_wide_df_short |>
  dplyr::mutate(
    h3_geo = sf::st_coordinates(geometry) |> h3::geo_to_h3(4)
  )


buildings_wide_df_short_geo <-
  buildings_wide_df_short_geo$h3_geo |>
  unique() |>
  h3::h3_to_geo_sf() |>
  sf::st_coordinates() |>
  data.frame() |>
  tidygeocoder::reverse_geocode(
    lat = Y,
    long = X,
    method = 'osm',
    address = address_found,
    # return_input = TRUE,
    full_results = TRUE
  )
# saveRDS(buildings_wide_df_short_geo, here::here("data/derivative/buildings_wide_df_short_geo.rds"))

buildings_long_df <- autocruller::ac_unnest_longer(buildings_wide_df)

buildings_count <-
  buildings_wide_df |>
  dplyr::add_count(combined_id) |>
  dplyr::filter(n >= 10) |>
  add_meteorological_week()


plot_buildings_week_co2(buildings_count)
plot_metweek_type(buildings_count)

library(duckplyr)
selections_df <-
  buildings_long_df |>
  dplyr::filter(stringr::str_detect(
    nwrname,
    "((C|c)ostco|(L|l)owes|(H|h)ome (D|depot)|Ikea|IKEA)"
    # "((A|a)ldi|(L|l)idl|(R|r)ewe)"
  )) |>
  dplyr::mutate(
    name_category = dplyr::case_when(
      stringr::str_detect(
        nwrname,
        "(C|c)ostco"
      ) ~ "Costco",
      stringr::str_detect(
        nwrname,
        "(L|l)owes"
      ) ~ "Lowes",
      stringr::str_detect(
        nwrname,
        "(H|h)ome (D|depot)"
      ) ~ "The Home Depot",
      stringr::str_detect(
        nwrname,
        "IKEA"
      ) ~ "IKEA"
      # stringr::str_detect(
      #   nwrname,
      #   "(R|r)ewe"
      # ) ~ "Rewe",
      # stringr::str_detect(
      #   nwrname,
      #   "(A|a)ldi"
      # ) ~ "Aldi",
      # stringr::str_detect(
      #   nwrname,
      #   "(L|l)idl"
      # ) ~ "Lidl"
      # )
    )
  )
#|>
# dplyr::filter(
#   nwrname !=
#     "Paul Kuzka Reifenspezialdienst u. Kraftfahrzeugteile GmbH & Co. KG"
# )

selections_df |>
  dplyr::group_by(obs_number) |>
  dplyr::summarise(
    co2_median = median(co2readings, na.rm = TRUE),
    name_category = dplyr::first(name_category)
  ) |>
  sf::st_drop_geometry() |>
  tidyplot(
    x = name_category,
    y = co2_median,
    color = co2_median
  ) |>
  # add_violin() |>
  add_data_points_beeswarm(size = 3) |>
  add_boxplot(
    linewidth = 1.4,
    fill = "white",
    color = "grey30",
    show_outliers = FALSE
  ) |>
  # adjust_y_axis(transform = "log2") |>
  adjust_size(width = NA, height = NA, unit = "cm") |>
  adjust_font(fontsize = 16) |>
  adjust_x_axis_title("Store") |>
  adjust_y_axis_title("CO2 ppm") |>
  remove_legend() |>
  # adjust_title("CO2 Averages at music venues") |>
  adjust_caption("Data from indoorCO2map.com", fontsize = 10)


# seasonality vs co2

buildings_long <-
  buildings_wide_df |>
  autocruller::ac_unnest_longer()

buidlings_summary <-
  buildings_long |>
  dplyr::filter(
    co2readings > 420
  ) |>
  dplyr::group_by(obs_number) |>
  dplyr::mutate(
    season = dplyr::case_when(
      lubridate::month(date) <= 3 | lubridate::month(date) > 9 ~ "Winter",
      .default = "Summer"
    ) |>
      as.factor()
  ) |>
  dplyr::group_by(combined_id, season) |>
  dplyr::summarise(
    med = median(co2readings)
  )

iso_3166_a2 <- rvest::read_html(
  "https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2"
) |>
  rvest::html_table(na.strings = "") |> # take care not to interpret Namibia as NA!
  purrr::pluck(4) |>
  dplyr::select(
    code = Code,
    name = `Country name (using title case)`
  )

pak::pkg_install("ropensci/rnaturalearthdata")
pak::pkg_install("ropensci/rnaturalearthhires")
install.packages("rnaturalearth")
world_sf <- rnaturalearth::ne_countries()


# transit graph ----------------------------------------------------------

test <-
  transit_long_df_short |>
  dplyr::filter(uid == 1703)
test$osm_id_line
test <-
  test |>
  dplyr::mutate(osm)

lines_osm <-
  osmdata::opq_osm_id(id = test$osm_id_line[1], type = "route") #|>
osmdata::opq_string() |>
  osmdata::osmdata_sf() |>
  osmdata::unique_osmdata()


# animation --------------------------------------------------------------
library(gganimate)
library(rnaturalearth)
library(rnaturalearthhires)
countries_sf <- rnaturalearth::ne_countries(scale = 50L)
buildings_wide_df <- autocruller::ac_get_co2("web")

anim <-
  buildings_wide_df |>
  dplyr::mutate(day = as.Date(date)) |>
  ggplot2::ggplot() +
  ggplot2::geom_sf(data = countries_sf, fill = "white") +
  ggplot2::geom_sf(aes(colour = ppmavg), size = 4) +
  transition_time(day) +
  shadow_mark(past = T, future = F, alpha = 0.4) +
  xlim(0, 17) +
  ylim(44.340868, 55.22535) +
  scale_color_viridis_c(
    name = "Mean CO2 ppm",
    breaks = c(420, 600, 800, 1200, 2000, 4000),
    transform = "log2",
    option = "turbo"
  ) +
  theme(
    plot.background = ggplot2::element_rect(fill = NA, colour = NA),
    legend.background = ggplot2::element_rect(fill = NA, colour = NA),
    legend.key = ggplot2::element_rect(fill = NA, colour = NA),
    legend.key.width = unit(1, "lines"),
    legend.key.height = unit(4, "lines"),
    strip.background = ggplot2::element_rect(fill = "#aed4f2", colour = NA),
    panel.background = ggplot2::element_rect(fill = "#aed4f2", colour = NA),
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

anim2 <- animate(
  anim,
  nframes = 635,
  driver = 'png',
  # quality = 40,
  # nframes = 260,
  fps = 25
)
anim_save(here::here("data/derivative/animation.gif"), anim2)


anim_na <-
  buildings_wide_df |>
  dplyr::mutate(day = as.Date(date)) |>
  ggplot2::ggplot() +
  ggplot2::geom_sf(data = countries_sf, fill = "white") +
  ggplot2::geom_sf(aes(colour = ppmavg), size = 6) +
  transition_time(day) +
  shadow_mark(past = T, future = F, alpha = 0.4) +
  xlim(-130, -50) +
  ylim(20, 56) +
  scale_color_viridis_c(
    name = "Mean CO2 ppm",
    breaks = c(420, 600, 800, 1200, 2000, 4000),
    transform = "log2",
    option = "turbo"
  ) +
  theme(
    plot.background = ggplot2::element_rect(fill = NA, colour = NA),
    legend.background = ggplot2::element_rect(fill = NA, colour = NA),
    legend.key = ggplot2::element_rect(fill = NA, colour = NA),
    legend.position = "none",
    strip.background = ggplot2::element_rect(fill = "#aed4f2", colour = NA),
    panel.background = ggplot2::element_rect(fill = "#aed4f2", colour = NA),
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
  )
anim_na2 <- animate(
  anim_na,
  nframes = 635,
  driver = 'png',
  # quality = 40,
  # nframes = 260,
  fps = 25
)

anim_save(here::here("data/derivative/animation_na.gif"), anim_na2)

anim_aus <-
  buildings_wide_df |>
  dplyr::mutate(day = as.Date(date)) |>
  ggplot2::ggplot() +
  ggplot2::geom_sf(data = countries_sf, fill = "white") +
  ggplot2::geom_sf(aes(colour = ppmavg), size = 8) +
  transition_time(day) +
  shadow_mark(past = T, future = F, alpha = 0.4) +
  xlim(100, 160) +
  ylim(-40, 25) +
  scale_color_viridis_c(
    name = "Mean CO2 ppm",
    breaks = c(420, 600, 800, 1200, 2000, 4000),
    transform = "log2",
    option = "turbo"
  ) +
  theme(
    plot.background = ggplot2::element_rect(fill = NA, colour = NA),
    legend.background = ggplot2::element_rect(fill = NA, colour = NA),
    legend.key = ggplot2::element_rect(fill = NA, colour = NA),
    legend.position = "none",
    strip.background = ggplot2::element_rect(fill = "#aed4f2", colour = NA),
    panel.background = ggplot2::element_rect(fill = "#aed4f2", colour = NA),
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
  )
anim_aus2 <- animate(
  anim_aus,
  nframes = 635,
  driver = 'png',
  # quality = 40,
  # nframes = 260,
  fps = 25
)

anim_save(here::here("data/derivative/animation_aus.gif"), anim_aus2)

anim_eu <-
  buildings_wide_df |>
  dplyr::mutate(day = as.Date(date)) |>
  ggplot2::ggplot() +
  ggplot2::geom_sf(data = countries_sf, fill = "white") +
  ggplot2::geom_sf(aes(colour = ppmavg), size = 3) +
  transition_time(day) +
  shadow_mark(past = T, future = F, alpha = 0.2) +
  xlim(-16, 32) +
  ylim(34, 62) +
  scale_color_viridis_c(
    name = "Mean CO2 ppm",
    breaks = c(420, 600, 800, 1200, 2000, 4000),
    transform = "log2",
    option = "turbo"
  ) +
  theme(
    plot.background = ggplot2::element_rect(fill = NA, colour = NA),
    legend.background = ggplot2::element_rect(fill = NA, colour = NA),
    legend.key = ggplot2::element_rect(fill = NA, colour = NA),
    legend.key.width = unit(1, "lines"),
    legend.key.height = unit(4, "lines"),
    strip.background = ggplot2::element_rect(fill = "#aed4f2", colour = NA),
    panel.background = ggplot2::element_rect(fill = "#aed4f2", colour = NA),
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
anim_eu2 <-
  animate(
    anim_eu,
    nframes = 635,
    driver = 'png',
    # quality = 40,
    # nframes = 260,
    fps = 25
  )
anim_save(here::here("data/derivative/animation_eu.gif"), anim_eu2)

# anim_bar <-
buildings_wide_df |>
  dplyr::mutate(day = as.Date(date)) |>
  ggplot2::ggplot() +
  geom_bar()
# ggplot2::geom_sf(data = countries_sf, fill = "white") +
# ggplot2::geom_sf(aes(colour = ppmavg), size = 4) +
transition_time(day) +
  # shadow_mark(past = T, future = F, alpha = 0.2) +
  xlim(100, 160) +
  ylim(-40, 25) +
  scale_color_viridis_c(
    name = "Mean CO2 ppm",
    breaks = c(420, 600, 800, 1200, 2000, 4000),
    transform = "log2",
    option = "turbo"
  ) +
  theme(
    plot.background = ggplot2::element_rect(fill = NA, colour = NA),
    legend.background = ggplot2::element_rect(fill = NA, colour = NA),
    legend.key = ggplot2::element_rect(fill = NA, colour = NA),
    legend.position = "none",
    strip.background = ggplot2::element_rect(fill = "#aed4f2", colour = NA),
    panel.background = ggplot2::element_rect(fill = "#aed4f2", colour = NA),
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
  )


# london opticians -------------------------------------------------------
geocode_and_join <- function(x) {
  x_geo <-
    geocode_buildings_or_transit(x) |>
    dplyr::rowwise() |>
    sf::st_as_sf(
      coords = c("X", "Y"),
      crs = sf::st_crs(x)
    )

  x <- sf::st_join(
    x,
    x_geo,
    left = TRUE,
    largest = TRUE
  ) |>
    dplyr::ungroup()

  return(x)
}

london_sf <- sf::st_read(
  # here::here("data/raw/london.geojson")
  "/Users/samherniman/projects/indoor_co2_map/data/raw/london.geojson"
)

lon_sf <- sf::st_intersection(buildings_wide_df, london_sf)
lon_sf <-
  lon_sf |>
  dplyr::filter(
    # co2readings > 410,
    osmtag %in% c("pharmacy", "chemist")
  ) |>
  geocode_and_join()

buildings_long_df <- autocruller::ac_unnest_longer(lon_sf)

test <-
  buildings_long_df |>
  dplyr::filter(
    co2readings > 410
  ) |>
  # dplyr::rowwise() |>
  dplyr::mutate(
    address = paste(
      house_number,
      road,
      quarter,
      suburb,
      postcode,
      sep = ", "
    ) |>
      stringr::str_remove_all("NA, ")
  ) |>
  dplyr::group_by(combined_id, nwrname) |>
  dplyr::summarise(
    # borough = dplyr::first(borough),
    med_co2 = median(co2readings, na.rm = TRUE),
    max_co2 = max(co2readings, na.rm = TRUE),
    n_measurements = dplyr::n_distinct(obs_number),
    address = dplyr::first(address)
  )

test |>
  dplyr::ungroup() |>
  dplyr::select(-combined_id) |>
  gt() |>
  row_order(med_co2) |>
  # tab_header(title = "Measurements under 500 ppm") |>
  cols_label(
    nwrname = "Shop",
    med_co2 = "Median CO2 ppm",
    max_co2 = "Maximum CO2 ppm",
    n_measurements = "Number of times measured",
    address = "Address"
    # windows = "Windows",
    # osmtag = "Building type",
    # location_description = "Location"
  ) |>
  tab_options(
    table_body.hlines.width = 0
  )


# how many sub 410s are there --------------------------------------------

source(here::here("functions/functions.R"))

library(duckplyr)
buildings_wide_df <- autocruller::ac_get_co2("web")

buildings_long_df <- autocruller::ac_unnest_longer(buildings_wide_df)

test <-
  buildings_long_df |>
  dplyr::group_by(obs_number) |>
  dplyr::summarise(
    n_below = sum(co2readings < 410),
    n_all = dplyr::n(),
    percent_below = n_below / n_all
  ) |>
  dplyr::filter(
    # n_below > 0
    percent_below > 0.3
  )
hist(test$percent_below)

test2 <- buildings_long_df |>
  dplyr::filter(
    obs_number %in%
      c(
        19480,
        20817,
        14851,
        6709,
        16124,
        8731,
        8167,
        9405,
        225,
        1100,
        7969,
        12976,
        14898,
        12477,
        15617,
        13533,
        18503,
        22450,
        2524,
        23374,
        23829,
        21197,
        7608,
        11022,
        20307,
        15015,
        22023,
        572,
        9569,
        15175,
        17068,
        24037
      )
  )
