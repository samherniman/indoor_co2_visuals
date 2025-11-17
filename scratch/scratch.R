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
