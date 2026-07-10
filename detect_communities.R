source(here::here("functions/functions.R"))
# pak::pak("h3")
library(h3)
library(duckplyr)
library(leaflet)

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


h3_index <- geo_to_h3(buildings_wide_df, res = 2)
tbl <- table(h3_index) |>
  tibble::as_tibble()
hexagons <- h3_to_geo_boundary_sf(tbl$h3_index) |>
  dplyr::mutate(index = tbl$h3_index, measurements = tbl$n)
nrow(hexagons)

hexagons <- hexagons |>
  dplyr::filter(measurements >= 30)

head(hexagons)


pal <- colorBin("YlOrRd", domain = hexagons$measurements)

map <- leaflet(data = hexagons, width = "100%") %>%
  addProviderTiles(
    "Esri.WorldTopoMap"
    # "Stamen.Toner"
  ) %>%
  addPolygons(
    weight = 2,
    color = "white",
    fillColor = ~ pal(measurements),
    fillOpacity = 0.8,
    label = ~ sprintf("%i measurements (%s)", measurements, index)
  )

map
