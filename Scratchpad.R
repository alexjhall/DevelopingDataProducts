## Scratchpad file

## install package to investigate
install.packages("worldfootballR")

## Load packages
library(tidyverse)
library(worldfootballR)

## Football working... Too complicated. Can't connect to external source.
df <- fb_match_results(country = "ENG", gender = "M", season_end_year = 2021, tier = "1st")



## Clean date
air_pressure$date_only <-
    lubridate::ymd(substr(air_pressure$date_time, 1, 10))

## full datetime as datetime
air_pressure$date_time_full <-
    lubridate::ymd_hms(air_pressure$date_time)



## Clean time
air_pressure$time_only <-
    lubridate::ymd(substr(air_pressure$date_time, 1, 10))

# Sort by datetimefull
air_pressure <- air_pressure %>% arrange(desc(date_time_full))


## test
x <- lubridate::ymd_hms(air_pressure$date_time)

y <- force_tz(x, tzone = "Australia/Sydney")
x[1]
y[1]
air_pressure$date_time[1]


x[1]

## test again
z <- lubridate::ymd_hms(substr(air_pressure$date_time, 1, 20))
z[1]



unique(air_pressure$location_description)