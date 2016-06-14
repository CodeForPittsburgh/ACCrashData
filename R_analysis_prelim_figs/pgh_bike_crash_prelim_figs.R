# PGH bike crash plots
#
# contact: Mike Feyder 
#         feyderm@gmail.com

library(rgdal)
library(magrittr)
library(ggplot2)
library(ggthemes)
library(dplyr)
library(scales)

# bike crashes within pgh city limits
d <- read.csv("bike_crashes_pgh_2004-2014.csv")

# pgh neighborhoods from:
#   https://data.wprdc.org/dataset/pittsburgh-neighborhoods770b7
pgh <- readOGR(dsn="Pittsburgh_Neighborhoods", 
               layer = "Pittsburgh_Neighborhoods")

# Note: confusingly, longitude is y and latitude is x:
# http://gis.stackexchange.com/questions/11626/does-y-mean-latitude-and-x-mean-longitude-in-every-gis-software

# map
map <- ggplot2::fortify(pgh) %>%
  ggplot() +
  geom_polygon(aes(x = long, y = lat, group = group)) +
  geom_point(data = d, aes(x = DEC_LONG, y = DEC_LAT), color = "#FFC324") +
  theme_map() +
  coord_map("mercator") +
  ggtitle("Bike Crashes (2004-2014)") +
  theme(plot.title = element_text(size = 15, face="bold"),
        plot.background = element_rect(fill = "grey55"))

png("pgh_bike_crashes_2004_2014_map.png", 
    width = 700, 
    height = 700, 
    units = "px")
map
dev.off()

# consistent color theme
theme_pgh <- function() 
{
  theme_hc(bgcolor = "darkunica") + 
  theme(panel.grid.major.y = element_line(color = "grey30"),
        plot.title = element_text(size = 15, face="bold", color = "grey70"))
}

# crashes by year
by_year <- d %>%
  group_by(CRASH_YEAR) %>%
  summarise(n = n()) %>%
  ggplot() +
  geom_line(aes(x = CRASH_YEAR, y = n), 
            color = "#FFC324") +
  geom_point(aes(x = CRASH_YEAR, y = n), 
             color = "#FFC324", 
             size = 3.5) +
  scale_y_continuous(limits = c(0, 70), 
                     breaks = pretty_breaks(7)) +
  xlab("") +
  ylab("Number of Crashes") +
  ggtitle("Bike Crashes by Year") +
  theme_pgh()

png("pgh_bike_crashes_2004_2014_by_year.png")
by_year
dev.off()

# crashes by month
months <- c("January", "February", "March", "April",
            "May", "June", "July", "August", "September",
            "October", "November", "December")

by_month <- d %>%
  group_by(CRASH_MONTH) %>% 
  summarise(n = n()) %>%
  ggplot() +
  geom_line(aes(x = CRASH_MONTH, y = n), 
            color = "#FFC324") +
  geom_point(aes(x = CRASH_MONTH, y = n), 
             stat = "identity", 
             color = "#FFC324", 
             size = 3.5) +
  scale_x_continuous(breaks = 1:12, 
                     labels = months) +
  scale_y_continuous(limits = c(0,80), 
                     breaks = pretty_breaks(8)) +
  xlab("") +
  ylab("Number of Crashes") +
  ggtitle("Bike Crashes by Month") +
  theme_pgh() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1))

png("pgh_bike_crashes_2004_2014_by_month.png")
by_month
dev.off()

# crashes by weekday
weekdays = c("Sunday", "Monday", "Tuesday", "Wednesday",
              "Thursday", "Friday", "Saturday")

by_weekday <- d %>%
  group_by(DAY_OF_WEEK) %>%
  summarise(n = n()) %>%
  ggplot() +
  geom_line(aes(x = DAY_OF_WEEK, y = n), color = "#FFC324") +
  geom_point(aes(x = DAY_OF_WEEK, y = n), color = "#FFC324", size = 3.5) +
  scale_x_continuous(breaks = 1:7, labels = weekdays) +
  scale_y_continuous(limits = c(0, 100), breaks = pretty_breaks(10)) +
  xlab("") +
  ylab("Number of Crashes") +
  ggtitle("Bike Crashes by Weekday") +
  theme_pgh()

png("pgh_bike_crashes_2004_2014_by_weekday.png")
by_weekday
dev.off()


# crashes by hour
time <- c("midnight", 1:11, "noon", 1:11, "")

by_hour <- d %>%
  filter(TIME_OF_DAY != 9999) %>%
  ggplot() +
  stat_bin(geom = "point",
           aes(x = TIME_OF_DAY), 
           binwidth = 100, 
           color = "#FFC324",
           size = 3.5,
           center = 50) +
  stat_bin(geom = "line",
           aes(x = TIME_OF_DAY), 
           binwidth = 100, 
           color = "#FFC324",
           center = 50) +
  scale_x_continuous(breaks = (0:24)*100, labels = time) +
  scale_y_continuous(limits = c(0, 80), breaks = pretty_breaks(8)) +
  xlab("") +
  ylab("Number of Crashes") +
  ggtitle("Bike Crashes by Hour") +
  theme_pgh() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1))

png("pgh_bike_crashes_2004_2014_by_hour.png")
by_hour
dev.off()

# crashes by street
top_st <- d %>%
  group_by(STREET_NAME) %>% 
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  slice(1:10)

desc_st <- top_st$STREET_NAME %>% as.character %>% rev()
top_st$STREET_NAME <- ordered(x = top_st$STREET_NAME, 
                              levels = desc_st)
top_st %>%
  ggplot() +
  geom_point(aes(x = n, y = STREET_NAME), 
             color = "#FFC324", 
             size = 3.5) +
  xlab("Number of Crashes") +
  ylab("") +
  scale_x_continuous(limits = c(0, 30)) +
  pgh_theme()
  
by_st <- top_st %>%
  ggplot() +
  geom_bar(aes(y = n, x = STREET_NAME), 
           stat = "identity",
           color = "#FFC324") +
  xlab("") +
  ylab("Number of Crashes") +
  scale_y_continuous(limits = c(0, 30)) +
  pgh_theme() +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.major.x = element_line(color = "grey30")) +
  coord_flip() +
  ggtitle("Bike Crashes by Street\n(top 10)")

png("pgh_bike_crashes_2004_2014_by_street.png")
by_st
dev.off()

# fatal bike crashes (only 4)
d %>%
  group_by(FATAL_COUNT) %>%
  summarise(n = n())

# almost all on streets w/ 25 or 35 mph limits
d %>%
  group_by(SPEED_LIMIT) %>%
  summarise(n = n())
