`%||%` <- function(x, y) {
  if (is.na(x) || is.null(x)) y else x
}
describe_most_measured <- function(x) {
  sentence_mm <-
    x |>
    glue::glue_data(
      "{nwrname}, a {osmtag %||% co2atlaskey} in {location_description} (min: {ppm_min}, mean: {ppm_avg}, max: {ppm_max})"
    ) |>
    stringr::str_flatten_comma(last = " and ")

  if (nrow(x) == 1) {
    return(glue::glue(
      "The most measured building was {sentence_mm}, which was measured {x$n[1]} times."
    ))
  }

  if (nrow(x) > 1) {
    glue::glue(
      "The most measured buildings were {sentence_mm}, which were measured {x$n[1]} times each."
    )
  }
}

describe_most_measured_transit <- function(x) {
  sentence_mm <-
    x |>
    glue::glue_data(
      "{route} {lineName} in the {network} transit network in {location_description} (min: {ppm_min}, mean: {ppm_avg}, max: {ppm_max})"
    ) |>
    stringr::str_flatten_comma(last = " and ")

  if (nrow(x) == 1) {
    return(glue::glue(
      "The most measured transit line was {sentence_mm}, which was measured {x$n[1]} times."
    ))
  }

  if (nrow(x) > 1) {
    glue::glue(
      "The most measured transit lines were {sentence_mm}, which were measured {x$n[1]} times each."
    )
  }
}

convert_hemisphere <- function(x) {
  ((x + 25) %% 52) + 1
}

describe_buildings <- function(x, measure = "highest") {
  if (nrow(x) == 1) {
    return(glue::glue(
      "The building with the {measure} measured CO^2^ levels was {x$description_str} with a median CO^2^ value of {x$median_co2} ppm."
    ))
  }

  if (nrow(x) > 1) {
    return(
      glue::glue(
        "The buildings with the {measure} measured CO^2^ levels were {stringr::str_flatten_comma(x$description_str, last = ' and ')} with median CO^2^ values of {x$median_co2} ppm."
      ) |>
        dplyr::first()
    )
  }
}

range01 <- function(x, ...) {
  (x - min(x, ...)) / (max(x, ...) - min(x, ...))
}

replace_quotes <- function(x) {
  dplyr::na_if(x, "")
}

get_osm_by_id <- function(transit_osm) {
  lines_osm <-
    osmdata::opq_osm_id(id = transit_osm$osm_line) |>
    osmdata::opq_string() |>
    osmdata::osmdata_sf() |>
    osmdata::unique_osmdata()

  if (is.null(lines_osm$osm_multilines)) {
    return(NULL)
  }

  lines_osm <- lines_osm$osm_multilines |>
    dplyr::mutate(dplyr::across(
      dplyr::starts_with(
        c(
          "network",
          # 'network:metro',
          # 'network:short',
          "operator"
          # 'operator:fr',
          # 'operator:it',
          # 'operator:short'
        )
      ),
      replace_quotes
    )) |>
    dplyr::rowwise() |>
    dplyr::mutate(
      network_best = network %||% 'network:metro' %||% 'network:short',
      operator_best = operator %||%
        'operator:fr' %||%
        'operator:it' %||%
        'operator:short'
    ) |>
    dplyr::select(
      osm_id,
      name,
      from,
      network_best,
      operator_best,
      route,
      ref,
      to
    ) |>
    dplyr::group_by(osm_id) |>
    dplyr::distinct(osm_id, .keep_all = TRUE)

  return(lines_osm)
}
