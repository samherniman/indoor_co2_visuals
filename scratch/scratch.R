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
    "((C|c)ostco|(L|l)owes|(H|h)ome (D|depot))"
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
      ) ~ "The Home Depot"
      #   stringr::str_detect(
      #     nwrname,
      #     "(A|a)ldi"
      #   ) ~ "Aldi",
      #   stringr::str_detect(
      #     nwrname,
      #     "(L|l)idl"
      #   ) ~ "Lidl"
      # )
    )
  )
#|>
# dplyr::filter(
#   nwrname !=
#     "Paul Kuzka Reifenspezialdienst u. Kraftfahrzeugteile GmbH & Co. KG"
# )

selections_df |>
  # dplyr::group_by(obs_number) |>
  # dplyr::summarise(
  #   co2_median = median(co2readings, na.rm = TRUE),
  #   name_category = dplyr::first(name_category)
  # ) |>
  sf::st_drop_geometry() |>
  tidyplot(
    x = name_category,
    y = co2readings,
    color = co2readings
  ) |>
  # add_violin() |>
  add_data_points_beeswarm(size = 3) |>
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
