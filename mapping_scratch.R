# let's see if we can map the water quality data

library(tidyverse) # data wrangling and plotting
# install.packages("plotly")
library(plotly) # interactive map

# preprocessed data
map_df <- read_rds("world_plus_ts.rds") |> 
  filter(!is.na(x1998))


# specify light grey boundaries for country boundaries
l <- list(color = toRGB("grey"), width = 0.5)

# specify map projection/options
g <- list(
  showframe = FALSE,
  showcoastlines = FALSE,
  landcolor = '#eeeeee',
  countrycolor = '#cccccc',
  showcountries = TRUE,
  showland = TRUE,
  projection = list(type = 'natural earth')
)

# make one interactive map
plot_geo(map_df) |> 
  add_trace(
    z = ~eval(parse(text = "x1998")), color = ~eval(parse(text = "x1998")), colors = 'Blues',
    text = ~Country, locations = ~Code, marker = list(line = l)
  ) |> 
  colorbar(title = 'x1998') |> 
  layout(
    title = 'Water Quality',
    geo = g
  )


