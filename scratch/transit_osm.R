get_osm_transit <- function(
  x,
  types_v = c(
    "bus",
    "tram",
    "subway",
    "train",
    "light_rail",
    "trolleybus",
    "monorail",
    "ferry"
  ),
  timeout = 200
) {
  x <- sf::st_transform(x, sf::st_crs(4326))
  x_bbox <- sf::st_bbox(x)

  q_routes <- osmdata::opq(
    bbox = x_bbox,
    timeout = timeout
  ) |>
    osmdata::add_osm_feature(
      key = "route",
      value = types_v
    ) |>
    osmdata::osmdata_sf()

  q_stops <- osmdata::opq(
    bbox = x_bbox,
    timeout = timeout
  ) |>
    osmdata::add_osm_feature(
      key = "public_transport",
      value = c("stop_position", "platform", "station")
    ) |>
    osmdata::osmdata_sf()

  q_bus_stops <- osmdata::opq(
    bbox = x_bbox,
    timeout = timeout
  ) |>
    osmdata::add_osm_feature(
      key = "highway",
      value = "bus_stop"
    ) |>
    osmdata::osmdata_sf()

  route_lines_sf <- simplify_layer(q_routes, "osm_lines", "route")
  route_multilines_sf <- simplify_layer(q_routes, "osm_multilines", "route")
  stop_points_sf <- simplify_layer(q_stops, "osm_points", "stop")
  bus_stop_points_sf <- simplify_layer(q_bus_stops, "osm_points", "stop")

  combine_sf <- list(
    route_lines_sf,
    route_multilines_sf,
    stop_points_sf,
    bus_stop_points_sf
  )

  combine_sf <- combine_sf[!sapply(combine_sf, is.null)]

  if (length(combine_sf) == 0) {
    return(NULL)
  }

  combine_sf <- dplyr::bind_rows(combine_sf) |>
    sf::st_as_sf() |>
    dplyr::distinct(osm_id, feature_type, .keep_all = TRUE) |>
    sf::st_make_valid()
}

simplify_layer <- function(
  x,
  layer_name,
  feature_type,
  cols_v = c(
    "osm_id",
    "name",
    "route",
    "ref",
    "operator",
    "network",
    "public_transport",
    "highway",
    "railway"
  )
) {
  osm_sf <- x[[layer_name]]

  if (is.null(osm_sf) || nrow(osm_sf) == 0) {
    return(NULL)
  }

  keep_cols <- intersect(cols_v, names(osm_sf))

  osm_sf |>
    dplyr::select(dplyr::all_of(keep_cols), geometry) |>
    dplyr::mutate(feature_type = feature_type) |>
    sf::st_as_sf() |>
    sf::st_make_valid()
}
library(osmdata)
set_overpass_url("https://overpass-api.de/api/interpreter")
communities_sf <- sf::st_read(here::here("data/raw/communities.gpkg")) |>
  dplyr::rename(community_name = name) |>
  dplyr::filter(community_name == "Woodbridge") |>
  sf::st_make_valid()
transit <- get_osm_transit(communities_sf)
## st_write(transit, "transit_combined.gpkg", delete_dsn = TRUE)
stops <- transit |>
  dplyr::filter(feature_type == "stop")

find_centroid <- function(x) {
  stops_to_combine <-
    sf::st_is_within_distance(
      x,
      dist = 100,
      sparse = TRUE,
      remove_self = TRUE
    ) |>
    unique() |>
    unlist() |>
    unique()
  x[stops_to_combine, ] |>
    sf::st_combine() |>
    sf::st_centroid()
}

test3 <- stops |>
  dplyr::group_by(feature_type, name) |>
  dplyr::summarise(geometry = find_centroid(geometry))

# combine_duplicated_stops <- function(x) {
#   stops_to_combine <-
#     sf::st_is_within_distance(
#       x,
#       dist = 100,
#       sparse = TRUE,
#       remove_self = FALSE
#     ) |>
#     unique()
#   # x_lst <- lapply(stops_to_combine, \(y) combine_centroid(y, x))
#   # x_lst <- do.call(rbind, x_lst)
# }

# combine_centroid <- function(x, indexes) {
#   x <- x[indexes, ]
#   y <- x |>
#     sf::st_drop_geometry() |>
#     dplyr::ungroup() |>
#     dplyr::distinct() |>
#     # tidyr::fill(.direction = "updown") |>
#     dplyr::summarise(
#       osm_ids = unique(osm_id) |> list(),
#       osm_id = dplyr::first(osm_id, na_rm = TRUE),
#       name = dplyr::first(name, na_rm = TRUE),
#       ref = dplyr::first(ref, na_rm = TRUE),
#       operator = dplyr::first(operator, na_rm = TRUE),
#       public_transport = dplyr::first(public_transport, na_rm = TRUE),
#       highway = dplyr::first(highway, na_rm = TRUE),
#       railway = dplyr::first(railway, na_rm = TRUE),
#       feature_type = dplyr::first(feature_type, na_rm = TRUE),
#       route = dplyr::first(route, na_rm = TRUE),
#       network = dplyr::first(network, na_rm = TRUE)
#     )
#   y$geometry <- x |> sf::st_combine() |> sf::st_centroid()
#   return(y)
# }

# stops2 <- stops |>
#   dplyr::filter(name %in% c("St Andrews Place", "Water Bridge", "Woodbridge"))

# plot(sf::st_geometry(transit))

mapview::mapview(test3)
