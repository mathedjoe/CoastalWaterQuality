
zipfile = list.files(pattern = "zip")
unzip(zipfile)
popfile = list.files(pattern = "Sex.csv")
pop_raw = read.csv(popfile)
library(tidyverse)
world = read_rds("world_plus_ts.rds")
world_long = world %>% 
  pivot_longer(cols = starts_with("x") , names_to = "Year", values_to = "waterquality")  %>%
  mutate(Year = as.numeric(gsub("x","", Year)))

pop = pop_raw %>% 
  select(Code = ISO3_code, Year = Time, starts_with("Pop") ) %>% 
  filter(Year >= 1998, Year <= 2007, Code %in% world$Code) %>% 
  left_join(world_long)

write_rds(pop, "world_plus_pop.rds")   
