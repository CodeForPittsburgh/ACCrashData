library(magrittr)
library(dplyr)
library(rgdal)

# cumulative (2004-2014) allegheny crash data
d <- read.csv("crash-data-sorted-by-crn.csv", stringsAsFactors = F)

# bike crashes
b <- d %>% filter(BICYCLE == 1)
has_coords <- complete.cases(b$DEC_LAT)
b <- b[has_coords, ]

# pgh neighborhoods from:
#   https://data.wprdc.org/dataset/pittsburgh-neighborhoods770b7
pgh <- readOGR(dsn="Pittsburgh_Neighborhoods", 
               layer = "Pittsburgh_Neighborhoods")

# coords in city
sp_pts <- b %>% 
  select(DEC_LONG, DEC_LAT) %>%
  SpatialPoints(proj4string = CRS(proj4string(pgh)))

in_pgh <- sp::over(sp_pts, pgh) %>%
  select(objectid) %>%
  complete.cases()

b[in_pgh, ] %>% write.csv("bike_crashes_pgh_2004-2014.csv")
