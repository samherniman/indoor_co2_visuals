source(here::here("functions/functions.R"))
library(duckplyr)
library(ggplot2)

library(osrm.backend)
library(osrm)
library(sf)

transit_long_df <- autocruller::ac_get_co2("transit")

test <-
  transit_long_df |>
  dplyr::group_by(line) |>
  dplyr::filter(tsa == 1) |>
  dplyr::summarise(
    lineName = dplyr::first(lineName),
    n = n()
  )

# line
# r_112662
# r_2905798
# r_2905886
# r_2905896
# r_8214799

test <-
  transit_long_df |>
  dplyr::filter(stringr::str_detect(line, "r_112662|r_2905886")) |>
  dplyr::mutate(
    uid = as.factor(uid),
    day = lubridate::date(date) |> as.factor()
  )
test$line |> unique()
test2 <-
  test |>
  dplyr::group_by(uid) |>
  arrange(desc(tsa))

ggplot(test2, aes(x = tsa, y = co2Array, color = day, fill = day)) +
  geom_smooth() +
  theme_light()
