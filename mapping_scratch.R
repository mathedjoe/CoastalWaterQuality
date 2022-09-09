# let's see if we can map the water quality data

library(tidyverse) # data wrangling and plotting


# world map data
world <- map_data("world")
# usa <- map_data("state") |> 
#   mutate(region = str_to_sentence(region))

# pre-process the data 
timeseries_file <- "data_raw/timeseries-global.zip" # large file
data_folder <- "data_raw/timeseries_global"

if(!dir.exists(data_folder)) dir.create(data_folder)

unzip(timeseries_file, exdir = data_folder)

list.files(file.path(data_folder, "timeseries-global"))

timeseries_data_file <- file.path(data_folder, "timeseries-global", "timeseries_global.xlsx")

ts_raw <- readxl::read_excel(timeseries_data_file) # takes a few seconds


ts_by_country <- ts_raw |>
  select(Country, starts_with("x")) |> 
  pivot_longer(-Country, names_to = "year", values_to = "waterqlty") |> 
  group_by(Country, year) |> 
  summarize( waterqlty = mean(waterqlty, na.rm = TRUE)) |> 
  ungroup() |> 
  pivot_wider( names_from = "year", values_from = "waterqlty") |> 
  mutate( region = case_when(Country == "United States" ~ "USA",
                             Country == "United Kingdom" ~ "UK",
                             Country == "Viet Nam" ~ "Vietnam",
                             TRUE ~ Country))



world_plus_ts <- world |> 
  # bind_rows(usa) |> 
  left_join(ts_by_country ) 


country_matches <- world_plus_ts |> 
  group_by(region) |> 
  summarize( n = n(), 
             perc_miss = sum(is.na(x1998) )/n ) |> 
  filter(perc_miss == 0 ) |> 
  pull(region)

country_fails <- setdiff( ts_by_country$region, country_matches)

country_fails

write_rds(world_plus_ts, "world_plus_ts.rds")

# make a map of water quality
world_plus_ts |> 
ggplot() +
  geom_map( map = world,
    aes(long, lat, map_id = region, fill = x1998 ),
    color = "#333333", size = 0.1
  ) +
  theme_void()


world_plus_ts |> 
  filter(region == "Algeria") |> 
  select(region, starts_with("x")) |> 
  slice(1) |> 
  pivot_longer(-region, names_to = "year") |> 
  mutate(year = as.numeric(gsub("x", "", year))) |> 
  ggplot() +
  aes(x = year, y = value) + 
  geom_line() +
  geom_point() +
  scale_x_continuous( breaks = 1998:2007) +
  scale_y_continuous(limits = c(0,1))
