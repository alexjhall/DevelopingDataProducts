## Scratchpad file


## Looking to check expected ranges and starting value for shiny app.

## Load data
data <-
    read_csv(here("Data/Ballarat/Clean/data.csv"))

hist(data$wind_speed_average)
summary(data$wind_speed_average)


hist(data$vapour_pressure)
summary(data$vapour_pressure)


hist(data$atmospheric_pressure)
summary(data$atmospheric_pressure)


hist(data$relative_humidity)
summary(data$relative_humidity)

hist(data$time_of_day)
summary(data$time_of_day)

unique(data$time_of_day)
    
        
hist(data$wind_direction)
summary(data$wind_direction)










## Looking at Ballarat data and required cleaning.



## ******************************************
## Air pressure

x <- air_pressure[air_pressure$atmospheric_pressure < 94, ]
view(x)

hist(air_pressure$vapour_pressure_hpa)

range(air_pressure$vapour_pressure)


## ******************************************
## Air temp

x <- air_temp[air_temp$air_temperature < 0, ]
view(x)

hist(air_temp$air_temperature)




## ******************************************
## Humidity

x <- air_temp[air_temp$air_temperature < 0, ]
view(x)

hist(humidity$relative_humidity)

range(air_pressure$vapour_pressure)


## ******************************************
## solar

x <- air_temp[air_temp$air_temperature < 0, ]
view(x)

hist(solar$solar_radiation)

# plot solar over time to find dead spot
plot(x = solar_hour$date_time_hour, y = solar_hour$solar_radiation)



## ******************************************
## wind

x <- air_temp[air_temp$air_temperature < 0, ]
view(x)

hist(wind$wind_direction)
qplot(wind$wind_direction_cardinal)

# plot solar over time to find dead spot
plot(x = solar_hour$date_time_hour, y = solar_hour$solar_radiation)


































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