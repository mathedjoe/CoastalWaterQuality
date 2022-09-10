# pre-process water quality data, merging with other global data sources

# unzip the timeseries of water quality data
timeseries_file <- "data_raw/timeseries-global.zip" # large file
data_folder <- "data_raw/timeseries_global"

if(!dir.exists(data_folder)) dir.create(data_folder)
unzip(timeseries_file, exdir = data_folder)
# list.files(file.path(data_folder, "timeseries-global"))

timeseries_data_file <- file.path(data_folder, "timeseries-global", "timeseries_global.xlsx")

ts_raw <- readxl::read_excel(timeseries_data_file) # takes a few seconds

# reformat time series to compute means by country
water_df <- ts_raw |>
  select(Country, starts_with("x")) |> 
  pivot_longer(-Country, names_to = "year") |> 
  group_by(Country, year) |> 
  summarize( value = mean(value, na.rm = TRUE) ) |>   
  ungroup() |> 
  pivot_wider( names_from = "year")  |> 
  mutate( Country = case_when(Country == "Northern Mariana Islands and Guam" ~ "Northern Mariana Islands",
                              Country == "North Korea" ~ "Korea, North",
                              Country == "South Korea" ~ "Korea, South",
                              Country == "Republique du Congo" ~ "Congo, Republic of the",
                              Country == "Viet Nam" ~ "Vietnam",
                              TRUE ~ Country))

# merge with other global data
file_worldgdp <- 'https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv'
world_df <- read.csv(file_worldgdp) |> 
  rename(Country = COUNTRY, GDP = GDP..BILLIONS., Code = CODE) 

map_df <- left_join(world_df, water_df)

# assess merging process for mismatched countries (fix up above using case_when) 
country_fails <- setdiff( water_df$Country, map_df$Country[!is.na(map_df$x1998)])
country_fails

# export the merged data for use in app, etc
write_rds(map_df, "world_plus_ts.rds")