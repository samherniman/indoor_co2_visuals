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
