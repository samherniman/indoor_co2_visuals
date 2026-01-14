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
    dplyr::mutate(
      osmtag = stringr::str_replace_all(
        osmtag,
        "government",
        "government building"
      )
    ) |>
    glue::glue_data(
      "{nwrname}, a {osmtag} in {location_description} (min: {ppm_min}, mean: {ppm_avg}, max: {ppm_max})"
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
      "The building with the {measure} measured CO~2~ levels was {x$description_str} with a median CO~2~ value of {x$median_co2} ppm."
    ))
  }

  if (nrow(x) > 1) {
    return(
      glue::glue(
        "The buildings with the {measure} measured CO~2~ levels were {stringr::str_flatten_comma(x$description_str, last = ' and ')} with median CO~2~ values of {x$median_co2} ppm."
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


summarise_most_measured_buildings <- function(x) {
  x |>
    sf::st_drop_geometry() |>
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

summarise_most_measured_transit <- function(x) {
  x |>
    dplyr::group_by(line) |>
    dplyr::summarise(
      n = length(unique(uid)),
      lineName = dplyr::first(ref),
      route = dplyr::first(route),
      network = dplyr::first(network_best),
      operator = dplyr::first(operator_best),
      countryname = dplyr::first(country),
      location_description = dplyr::first(location_description),
      min_day = min(date),
      max_day = max(date),
      ppm_min = min(co2Array) |> round(),
      ppm_avg = mean(co2Array) |> round(),
      ppm_max = max(co2Array) |> round()
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
    axis.ticks = ggplot2::element_line(colour = "black", linewidth = 0.25),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14)
  )
}

plot_histogram_co2 <- function(x) {
  median_val <- x |>
    sf::st_drop_geometry() |>
    dplyr::filter(
      ppmavg >= 410
    )

  median_val <- median(median_val$ppmavg, na.rm = TRUE)

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
    geom_vline(
      aes(xintercept = median_val),
      color = "red",
      linetype = "dashed",
      linewidth = 1
    ) +
    annotate(
      "label",
      x = median_val + 400,
      y = 40,
      label = paste0("Median = ", round(median_val))
    ) +
    ylab("Number of observations") +
    xlab("Mean CO2 per observation") +
    tidyplots_theme()
}


plot_countries_count <- function(x) {
  x |>
    tidyplot(
      x = iso_name,
      y = n,
      color = type.x
    ) |>
    add_barstack_absolute() |>
    adjust_x_axis(
      rotate_labels = TRUE
    ) |>
    sort_x_axis_labels() |>
    sort_color_labels(.reverse = TRUE) |>
    add_data_labels(
      label = n,
      color = "black",
      label_position = "above",
      fontsize = 14
    ) |>
    adjust_size(width = NA, height = NA, unit = "cm") |>
    adjust_font(fontsize = 14) |>
    adjust_y_axis_title("Number of measurements") |>
    adjust_x_axis_title("Country") |>
    adjust_legend_title("Type") |>
    adjust_colors(new_colors = colors_discrete_metro) |>
    # remove_legend() |>
    adjust_padding(top = 0.3) |>
    adjust_title("Building measurements per country") |>
    adjust_caption("Data from indoorCO2map.com", fontsize = 10)
}


plot_building_types_1 <- function(buildings_wide_df) {
  buildings_wide_df |>
    # buildings_long_df |>
    dplyr::filter(
      dplyr::between(
        date,
        (lubridate::ceiling_date(start_date, unit = "month") -
          lubridate::years(1)),
        start_date |> lubridate::ceiling_date(unit = "month")
      ),
      ppmavg >= 410
    ) |>
    # sf::st_drop_geometry() |>
    dplyr::mutate(
      newtag = dplyr::if_else(
        osmtag %in% common_building_types$osmtag,
        osmtag,
        "other"
      ) |>
        stringr::str_replace_all("_", " ") |>
        stringr::str_to_sentence(),
      # month =  paste0(lubridate::month(date, label = TRUE), " ", lubridate::year(date)) |> factor()
      month = lubridate::floor_date(date, unit = "month") |> lubridate::date()
    ) |>
    dplyr::group_by(month, newtag) |>
    dplyr::tally() |>
    tidyr::drop_na() |>
    tidyplot(x = month, y = n, color = newtag) |>
    add_barstack_absolute(width = 31) |>
    adjust_x_axis(rotate_labels = TRUE) |>
    adjust_y_axis_title("Number of observations") |>
    adjust_x_axis_title("Date (month)") |>
    adjust_size(width = NA, height = NA, unit = "cm") |>
    adjust_colors(colors_discrete_seaside) |>
    # adjust_font(family = "Atkinson Hyperlegible") |>
    remove_legend_title()
}


plot_building_types_2 <- function(buildings_long_df) {
  buildings_long_df |>
    dplyr::filter(
      co2readings >= 410
    ) |>
    dplyr::mutate(
      newtag = dplyr::if_else(
        osmtag %in% common_building_types$osmtag,
        osmtag,
        "other"
      ) |>
        stringr::str_replace_all("_", " ") |>
        stringr::str_to_sentence()
    ) |>
    dplyr::group_by(obs_number) |>
    dplyr::summarise(
      ppmavg = median(ppmavg, na.rm = TRUE),
      newtag = dplyr::first(newtag)
    ) |>
    dplyr::mutate(
      percent_rebreathed = ((ppmavg - 420) / 38000) * 100
    ) |>
    sf::st_drop_geometry() |>
    tidyplot(
      x = newtag,
      y = percent_rebreathed,
      fill = ppmavg
    ) |>
    # add_data_points_beeswarm(size = 3, alpha = 0.4) |>
    add_boxplot(
      linewidth = 1.4,
      fill = "white",
      color = "grey30",
      show_outliers = FALSE
    ) |>
    # add_curve_fit(linewidth = 2,  alpha = 0.5,  se = FALSE) |>
    # add_data_points(size = 2, alpha = 0.4) |>
    adjust_x_axis(
      title = "Building type",
      rotate_labels = TRUE
      # breaks = seq(0, 52, by = 4)
    ) |>
    # adjust_y_axis(
    #   transform = "log2",
    #   # limits = c(420, NA)
    #   ) |>
    adjust_size(width = NA, height = NA, unit = "cm") |>
    adjust_font(fontsize = 16) |>
    remove_legend() |>
    # adjust_legend_title("Building type") |>
    adjust_y_axis_title("Percent rebreathed CO2") |>
    adjust_caption("Data from indoorCO2map.com", fontsize = 10)
}

list_buildings_under_threshold <- function(
  buildings_long_df_med,
  co2_threshold = 500
) {
  buildings_long_df_med |>
    dplyr::filter(median_co2 < co2_threshold) |>
    dplyr::group_by(obs_number) |>
    dplyr::summarise(
      name = dplyr::first(nwrname),
      co2 = dplyr::first(median_co2),
      osmtag = dplyr::first(osmtag) |> stringr::str_to_sentence(),
      location_description = dplyr::first(location_description)
    ) |>
    dplyr::select(
      -obs_number
    )
}

create_co2_tibble <- function(x) {
  tibble::tibble(
    time = 1:length(x$obs_number),
    co2 = x$co2readings,
    building = x$nwrname
  )
}


plot_building_co2_vs_time <- function(co2df) {
  ggplot(co2df, aes(x = time, y = co2, color = building)) +
    geom_smooth(color = "grey80") +
    geom_point(size = 4) +
    ylim(400, NA) +
    xlab("Time (minutes)") +
    ylab(bquote(CO^2)) +
    theme_minimal() +
    theme(
      text = element_text(size = 16),
      panel.grid = element_blank(),
      axis.text.x = element_text(size = 16),
      axis.line = element_line(colour = "black", size = 1, linetype = "solid"),
      legend.position = "none"
    )
}

plot_all_curves <- function(buildings_long_df_med, ylim_max) {
  # box plot
  buildings_box <-
    buildings_long_df_med |>
    dplyr::group_by(obs_number) |>
    ggplot(aes(x = 1, y = co2readings)) +
    geom_boxplot(outliers = FALSE) +
    ylim(400, ylim_max) +
    ylab("CO2") +
    theme_void() +
    theme(
      plot.title = element_text(size = 12),
      panel.grid = element_blank(),
      axis.text.x = element_blank(),
      legend.position = "none"
    )

  # graph with the curves

  buildings_lines <-
    buildings_long_df_med |>
    dplyr::group_by(obs_number) |>
    sf::st_drop_geometry() |>
    ggplot(aes(x = time_range, y = co2readings, group = obs_number)) +
    geom_smooth(
      se = FALSE,
      color = "grey80",
      linewidth = 0.5
    ) +
    # geom_smooth(
    #   data = lowest_building,
    #   mapping = aes(x = time_range, y = co2readings, color = obs_number),
    #   se = FALSE
    # ) +
    # geom_point(
    #   data = lowest_building,
    #   mapping = aes(x = time_range, y = co2readings),
    #   color = "blue",
    #   size = 4
    # ) +
    geom_smooth(
      data = highest_building,
      mapping = aes(x = time_range, y = co2readings, color = obs_number),
      se = FALSE
    ) +
    geom_point(
      data = highest_building,
      mapping = aes(x = time_range, y = co2readings, color = co2readings),
      size = 4
    ) +
    # scale_color_viridis_c()+
    scico::scale_color_scico(palette = "managua", direction = -1) +
    # annotate(
    #   "label",
    #   x = .7,
    #   y = mean(lowest_building$ppmavg, na.rm = TRUE) + 140,
    #   label = unique(lowest_building$nwrname) |>
    #     stringr::str_flatten_comma(last = ' and ')
    # ) +
    annotate(
      "label",
      x = .2,
      y = mean(highest_building$ppmavg, na.rm = TRUE) - 140,
      label = unique(highest_building$nwrname) |>
        stringr::str_flatten_comma(last = ' and ')
    ) +
    ylim(400, ylim_max) +
    labs(title = "Highest recording this month") +
    xlab("Time (from recording start to end)") +
    ylab(bquote(CO ~ 2)) +
    theme_minimal() +
    theme(
      text = element_text(size = 16),
      plot.title = element_text(size = 12),
      panel.grid = element_blank(),
      axis.text.x = element_text(size = 16),
      axis.line = element_line(
        colour = "black",
        linewidth = 1,
        linetype = "solid"
      ),
      legend.position = "none"
    )

  # put them together
  buildings_lines + buildings_box + plot_layout(widths = c(10, 1))
}


gt_buildings_under_threshold <- function(buildings_under_threshold) {
  buildings_under_threshold |>
    dplyr::mutate(
      osmtag = stringr::str_replace_all(osmtag, "_", " ")
    ) |>
    gt() |>
    tab_header(title = "Measurements under 500 ppm") |>
    cols_label(
      name = "Name",
      co2 = "CO2 ppm",
      osmtag = "Building type",
      location_description = "Location"
    ) |>
    tab_options(
      table_body.hlines.width = 0
    )
}

add_meteorological_week <- function(x) {
  x |>
    dplyr::mutate(
      meteorological_week = dplyr::if_else(
        sf::st_coordinates(geometry)[, 2] < 0,
        lubridate::week(date) |>
          convert_hemisphere() |>
          factor(levels = seq(0, 52, by = 1)),
        lubridate::week(date) |> factor(levels = seq(0, 52, by = 1))
      )
    )
}

plot_buildings_boxplot_date_vs_co2 <- function(buildings_wide_df) {
  buildings_wide_df |>
    dplyr::mutate(
      year_month = paste0(lubridate::year(date), "-", lubridate::month(date))
    ) |>
    tidyplot(
      x = year_month,
      y = ppmavg
    ) |>
    add_boxplot() |>
    adjust_x_axis(
      title = "Date",
      rotate_labels = TRUE
    ) |>
    adjust_size(width = NA, height = NA, unit = "cm") |>
    adjust_font(fontsize = 16) |>
    adjust_y_axis_title("CO2 ppm average") |>
    remove_legend() |>
    adjust_caption("Data from indoorCO2map.com", fontsize = 10)
}

plot_buildings_week_co2 <- function(buildings_wide_df) {
  buildings_wide_df |>
    dplyr::group_by(meteorological_week) |>
    dplyr::summarise(
      ppmavg = median(ppmavg, na.rm = TRUE)
    ) |>
    tidyplot(
      x = meteorological_week,
      y = ppmavg
    ) |>
    add_curve_fit(linewidth = 2, alpha = 0.5, se = FALSE) |>
    add_data_points(size = 2, alpha = 0.4) |>
    adjust_x_axis(
      title = "Week of the year (meteorological)",
      # rotate_labels = TRUE,
      breaks = seq(0, 52, by = 4)
    ) |>
    adjust_size(width = NA, height = NA, unit = "cm") |>
    adjust_font(fontsize = 16) |>
    adjust_legend_position("top") |>
    adjust_y_axis_title("CO2 ppm median") |>
    adjust_caption("Data from indoorCO2map.com", fontsize = 10)
}

plot_metweek_type <- function(buildings_wide_df) {
  buildings_wide_df |>
    dplyr::mutate(
      newtag = dplyr::if_else(
        osmtag %in% common_building_types$osmtag,
        osmtag,
        "other"
      ) |>
        stringr::str_replace_all("_", " ") |>
        stringr::str_to_sentence()
    ) |>
    dplyr::group_by(meteorological_week, newtag) |>
    dplyr::summarise(
      ppmavg = median(ppmavg, na.rm = TRUE)
    ) |>
    tidyplot(
      x = meteorological_week,
      y = ppmavg,
      color = newtag
    ) |>
    add_curve_fit(linewidth = 2, alpha = 0.5, se = FALSE) |>
    add_data_points(size = 2, alpha = 0.4) |>
    adjust_x_axis(
      title = "Week of the year (meteorological)",
      # rotate_labels = TRUE,
      breaks = seq(0, 52, by = 4)
    ) |>
    adjust_y_axis(
      limits = c(NA, 1200)
    ) |>
    adjust_size(width = NA, height = NA, unit = "cm") |>
    adjust_font(fontsize = 16) |>
    adjust_legend_title("Building type") |>
    adjust_y_axis_title("CO2 ppm median") |>
    adjust_caption("Data from indoorCO2map.com", fontsize = 10)
}

plot_all_histogram <- function(buildings_wide_df) {
  buildings_wide_df |>
    tidyplot(
      x = date
    ) |>
    add_histogram(
      bins = ceiling(
        (lubridate::interval(
          buildings_wide_df$date |> min(),
          buildings_wide_df$date |> max()
        )) /
          lubridate::dweeks(1)
      )
    ) |>
    adjust_x_axis(
      title = "Date",
      breaks = scales::breaks_width("2 months"),
      labels = scales::label_date("%Y-%m"),
      rotate_labels = TRUE
    ) |>
    adjust_size(width = NA, height = NA, unit = "cm") |>
    adjust_font(fontsize = 16) |>
    adjust_y_axis_title("Observations per week") |>
    remove_legend() |>
    adjust_caption("Data from indoorCO2map.com", fontsize = 10)
}


# Transit ----------------------------------------------------------------

count_transit <- function(x) {
  x |>
    dplyr::rowwise() |>
    dplyr::mutate(
      location_description = stringr::str_replace_all(
        location_description,
        "United States of America",
        "USA"
      )
      #   city_country = city %||% country,
      #   line_loc = glue::glue("{network_best} ({city_country})")
    ) |>
    dplyr::group_by(location_description) |>
    dplyr::summarise(
      n = dplyr::n_distinct(uid)
    ) |>
    tidyr::drop_na() |>
    sf::st_drop_geometry() |>
    dplyr::ungroup() |>
    dplyr::filter(n > 2)
}

plot_transit_count_bar <- function(x) {
  x |>
    dplyr::filter(n > 2) |>
    tidyplot(
      x = location_description,
      y = n,
      color = location_description
    ) |>
    add_barstack_absolute() |>
    adjust_x_axis(
      rotate_labels = 65
    ) |>
    sort_x_axis_labels() |>
    add_data_labels(
      label = n,
      color = "black",
      label_position = "above",
      fontsize = 14
    ) |>
    adjust_size(width = NA, height = NA, unit = "cm") |>
    adjust_font(fontsize = 12) |>
    adjust_y_axis_title("Number of measurements") |>
    adjust_x_axis_title("Community") |>
    remove_legend() |>
    adjust_padding(top = 0.3) |>
    adjust_title("Transit measurements per community") |>
    adjust_caption("Data from indoorCO2map.com", fontsize = 10)
}


plot_transit_month_box <- function(x, co2_filter = 410) {
  x |>
    tidyr::drop_na(route) |>
    dplyr::filter(
      co2Array >= co2_filter
      # location_description %in% transit_count$location_description
    ) |>
    dplyr::mutate(
      route = stringr::str_to_sentence(route) |>
        stringr::str_replace_all("_", " ")
    ) |>
    tidyplot(
      x = route,
      y = co2Array,
      fill = co2Array
    ) |>
    add_data_points_beeswarm(size = 1, alpha = 0.15) |>
    add_boxplot(
      linewidth = 1.4,
      fill = "white",
      color = "grey30",
      show_outliers = FALSE
    ) |>
    # add_curve_fit(linewidth = 2,  alpha = 0.5,  se = FALSE) |>
    # add_data_points(size = 2, alpha = 0.4) |>
    adjust_x_axis(
      title = "Transit type",
      rotate_labels = TRUE
    ) |>
    # sort_x_axis_labels() |>
    adjust_y_axis(
      transform = "log10",
      limits = c(420, NA)
    ) |>
    adjust_size(width = NA, height = NA, unit = "cm") |>
    adjust_font(fontsize = 16) |>
    remove_legend() |>
    # adjust_legend_title("Building type") |>
    adjust_y_axis_title("CO2 ppm") |>
    add_title("CO2 Distribution (this month)") |>
    adjust_caption("Data from indoorCO2map.com", fontsize = 10)
}

plot_transit_all_box <- function(x, co2_filter = 410) {
  x |>
    tidyr::drop_na(route) |>
    dplyr::filter(
      co2Array >= co2_filter
      # location_description %in% transit_count$location_description
    ) |>
    dplyr::mutate(
      route = stringr::str_to_sentence(route) |>
        stringr::str_replace_all("_", " ")
    ) |>
    # dplyr::group_by(route) |>
    # dplyr::summarise(
    #   ppmavg = median(co2Array, na.rm = TRUE),
    #   location_description = dplyr::first(location_description)
    #   ) |>
    tidyplot(
      x = route,
      y = co2Array,
      fill = co2Array
    ) |>
    # add_data_points_beeswarm(size = 1, alpha = 0.1) |>
    add_boxplot(
      linewidth = 1.4,
      fill = "white",
      color = "grey30",
      show_outliers = FALSE
    ) |>
    # add_curve_fit(linewidth = 2,  alpha = 0.5,  se = FALSE) |>
    # add_data_points(size = 2, alpha = 0.4) |>
    adjust_x_axis(
      title = "Transit type",
      rotate_labels = TRUE
    ) |>
    # sort_x_axis_labels() |>
    # adjust_y_axis(
    #   transform = "log2",
    #   limits = c(420, NA)
    #   ) |>
    adjust_size(width = NA, height = NA, unit = "cm") |>
    adjust_font(fontsize = 16) |>
    remove_legend() |>
    # adjust_legend_title("Building type") |>
    adjust_y_axis_title("CO2 ppm") |>
    add_title("CO2 Distribution (all data)") |>
    adjust_caption("Data from indoorCO2map.com", fontsize = 10)
}

plot_transit_met_week <- function(x) {
  x |>
    dplyr::group_by(meteorological_week) |>
    dplyr::summarise(
      ppmavg = median(co2Array, na.rm = TRUE)
    ) |>
    tidyplot(
      x = meteorological_week,
      y = ppmavg
      # color = route
    ) |>
    add_curve_fit(linewidth = 2, alpha = 0.5, se = FALSE) |>
    add_data_points(size = 2, alpha = 0.4) |>
    adjust_x_axis(
      title = "Week of the year (meteorological)",
      rotate_labels = TRUE,
      breaks = seq(0, 52, by = 4)
    ) |>
    adjust_y_axis(
      limits = c(NA, 1200)
    ) |>
    adjust_size(width = NA, height = NA, unit = "cm") |>
    adjust_font(fontsize = 16) |>
    adjust_legend_title("Transit type") |>
    adjust_y_axis_title("CO2 ppm median") |>
    # reorder_x_axis_labels(seq(0, 52, by = 1)) |>
    adjust_caption("Data from indoorCO2map.com", fontsize = 10)
}


iso_3166_a2 <- rvest::read_html(
  "https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2"
) |>
  rvest::html_table(na.strings = "") |> # take care not to interpret Namibia as NA!
  purrr::pluck(4) |>
  dplyr::select(
    code = Code,
    iso_name = `Country name (using title case)`
  ) |>
  dplyr::mutate(
    code = stringr::str_to_lower(code),
    iso_name = stringr::str_replace_all(
      iso_name,
      c(
        "Netherlands, Kingdom of the" = "Netherlands",
        "United Kingdom of Great Britain and Northern Ireland" = "United Kingdom"
      )
    )
  )
