library(ggplot2)
library(tidyplots)
library(gt)
library(patchwork)

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

filter_to_month <- function(x, start_date) {
  x |>
    dplyr::filter(dplyr::between(
      date,
      start_date |> lubridate::floor_date(unit = "month"),
      start_date |> lubridate::ceiling_date(unit = "month")
    ))
}


join_transit_osm <- function(
  transit_long_df,
  lines_osm_path = here::here("data/derivative/lines_osm.fgb")
) {
  lines_osm <- sf::st_read(lines_osm_path)

  transit_long_df <-
    transit_long_df |>
    dplyr::mutate(osm_id_line = stringr::str_extract(line, "[:digit:]+"))

  transit_osm <-
    transit_long_df |>
    dplyr::mutate(
      osm_start = stringr::str_replace_all(
        startingPoint,
        c("n_" = "node/", "r_" = "relation/", "w_" = "way/")
      ),
      osm_line = stringr::str_replace_all(
        line,
        c("n_" = "node/", "r_" = "relation/", "w_" = "way/")
      ),
      osm_end = stringr::str_replace_all(
        endpoint,
        c("n_" = "node/", "r_" = "relation/", "w_" = "way/")
      )
    ) |>
    dplyr::filter(
      !(osm_id_line %in% unique(lines_osm$osm_id))
    )

  lines_osm2 <- get_osm_by_id(transit_osm)

  if (!is.null(lines_osm$osm_multilines)) {
    sf::st_write(lines_osm2, lines_osm_path, append = TRUE)
  }

  lines_osm <- sf::st_read(lines_osm_path)

  transit_long_df <- dplyr::left_join(
    sf::st_drop_geometry(transit_long_df),
    sf::st_drop_geometry(lines_osm),
    by = dplyr::join_by(osm_id_line == osm_id)
  ) |>
    dplyr::mutate(
      long_first = stringr::str_split_i(longitudeArray, ",", 1) |> as.numeric(),
      lat_first = stringr::str_split_i(latitudeArray, ",", 1) |> as.numeric()
    ) |>
    sf::st_as_sf(
      coords = c("long_first", "lat_first"),
      crs = sf::st_crs(4326)
    ) |>
    sf::st_make_valid()

  return(transit_long_df)
}

form_new_countries_sentence <- function(
  buildings_wide_df,
  buildings_wide_df_short
) {
  old_countries <-
    buildings_wide_df |>
    dplyr::filter(dplyr::between(
      date,
      lubridate::ymd("2024-01-01"),
      start_date |> lubridate::floor_date(unit = "month")
    )) |>
    sf::st_drop_geometry()
  old_countries <- unique(old_countries$countryname)
  old_countries <- append(old_countries, NA)

  new_countries <- unique(buildings_wide_df_short$countryname)[
    !(unique(buildings_wide_df_short$countryname) %in% old_countries)
  ]

  new_countries_sentence <-
    if (length(new_countries) > 0) {
      glue::glue(
        "Additionally, the first {ifelse(length(new_countries)==1, 'measurement was added in', 'measurements were added in')} {stringr::str_flatten_comma(new_countries, last = ' and ')} this month. Welcome to the glorious world of CO~2~ monitoring {stringr::str_flatten_comma(new_countries, last = ' and ')}!"
      )
    }

  return(new_countries_sentence)
}

geocode_buildings_or_transit <- function(x) {
  x_geo <-
    x |>
    sf::st_coordinates() |>
    as.data.frame() |>
    tidygeocoder::reverse_geocode(
      lat = Y,
      long = X,
      method = 'osm',
      address = address_found,
      full_results = TRUE
    )
  x_geo <-
    x_geo |>
    dplyr::mutate(
      country = stringr::str_replace_all(
        country,
        "Schweiz/Suisse/Svizzera/Svizra",
        "Switzerland"
      ) |>
        stringr::str_replace_all("België / Belgique / Belgien", "Belgium")
    )
  return(x_geo)
}


summarise_most_measured <- function(x) {
  x |>
    dplyr::group_by(combined_id) |>
    dplyr::summarise(
      n = dplyr::n(),
      nwrname = dplyr::first(nwrname),
      osmtag = dplyr::first(osmtag),
      countryname = dplyr::first(countryname),
      location_description = dplyr::first(location_description),
      min_day = min(date),
      max_day = max(date),
      ppm_min = min(ppmavg) |> round(),
      ppm_avg = mean(ppmavg) |> round(),
      ppm_max = max(ppmavg) |> round()
    ) |>
    dplyr::slice_max(n = 1, order_by = n)
}

tidyplots_theme <- function() {
  ggplot2::theme(
    plot.margin = ggplot2::unit(c(0.5, 0.5, 0.5, 0.5), "mm"),
    plot.background = ggplot2::element_rect(fill = NA, colour = NA),
    legend.background = ggplot2::element_rect(fill = NA, colour = NA),
    legend.key = ggplot2::element_rect(fill = NA, colour = NA),
    strip.background = ggplot2::element_rect(fill = NA, colour = NA),
    panel.background = ggplot2::element_rect(fill = NA, colour = NA),
    panel.border = ggplot2::element_rect(
      fill = NA,
      colour = "black",
      linewidth = 0.5
    ),
    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_line(colour = "black", linewidth = 0.25)
  )
}

plot_histogram_co2 <- function(x) {
  x |>
    dplyr::filter(
      ppmavg >= 410,
      ppmavg < 3000
    ) |>
    dplyr::mutate(
      percent_rebreathed = ((ppmavg - 420) / 38000) * 100
    ) |>
    sf::st_drop_geometry() |>
    ggplot(aes(ppmavg)) +
    geom_histogram(binwidth = 30) +
    # geom_rect(
    #   xmin = median(buildings_wide_df_short$ppmavg),
    #   xmax = median(buildings_wide_df_short$ppmavg),
    #   ymin = 1,
    #   ymax = 600,
    #   fill = "red") +
    ylab("Number of observations") +
    xlab("Mean CO2") +
    tidyplots_theme()
}
