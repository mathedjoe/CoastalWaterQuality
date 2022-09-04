library(tidyverse) # data wrangling and plotting


timeseries_file <- "data_raw/timeseries-global.zip" # large file
data_folder <- "data_raw/timeseries_global"

dir.create(data_folder)

unzip(timeseries_file, exdir = data_folder)

list.files(file.path(data_folder, "timeseries-global"))

timeseries_data_file <- file.path(data_folder, "timeseries-global", "timeseries_global.xlsx")

ts_raw <- readxl::read_excel(timeseries_data_file)


ts_by_country <- ts_raw |>
  select(Country, starts_with("x")) |> 
  pivot_longer(-Country, names_to = "year", values_to = "waterqlty") |> 
  group_by(Country, year) |> 
  summarize( waterqlty = mean(waterqlty, na.rm = TRUE)) |> 
  ungroup() |> 
  pivot_wider( names_from = "year", values_from = "waterqlty")

write.csv(ts_by_country, "water_quality_time_series_by_country.csv", row.names = FALSE)
