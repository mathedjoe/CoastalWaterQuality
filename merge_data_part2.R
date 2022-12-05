zipfile = list.files(pattern = "zip")
unzip(zipfile)
gdpfile = "gdp-per-capita-maddison-2020 (1).csv"
gdp_raw = read.csv(gdpfile)
library(tidyverse)
world = read_rds("world_plus_pop.rds") %>% 
  select(-GDP)

gdp = world %>% 
  left_join(gdp_raw %>%  
       select(Code,Year,GDP = GDP.per.capita))
 # select(Code = Code, Year = Year, starts_with("GDP") ) %>% 
  #filter(Year >= 1998, Year <= 2007, Code %in% world$Code) %>% 
 # left_join(world_long)

write_rds(gdp, "world_plus_pop_gdp.rds")   


