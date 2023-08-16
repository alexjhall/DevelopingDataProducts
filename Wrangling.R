## Data wrangling

## Load libraries
library(tidyverse)
library(here)
library(lubridate)

## Load data

# Get list of datafiles
data_list_source <- str_subset(dir(here("Data/Ballarat/")), ".csv")

## Read data into list of dataframes

# Init list
data_list <- list()

# Loop to read in
for(i in seq_along(data_list_source)){
    
    data_list[[i]] <- data.frame(read.csv(here("Data/Ballarat", data_list_source[i]), sep = ";"))
}

## Set list names
names(data_list) <- data_list_source

## Clean datasets
## ****************************************************

## Air pressure
## *************************
air_pressure <- data_list[["air-pressure-observations.csv"]]

## Turn date_time into datetime object
air_pressure$date_time <- 
    lubridate::ymd_hms(substr(air_pressure$date_time, 1, 20))

## Force timezone
air_pressure$date_time <- 
    force_tz(air_pressure$date_time, tzone = "Australia/Sydney")

## Sort data
air_pressure <- air_pressure %>% arrange(desc(date_time))

## Select cols
air_pressure <-
    air_pressure %>%
    select(
        -location_description,
        -latitude,
        -longitude,
        -point
    )


## Take mean by hour
air_pressure_hour <- 
    air_pressure %>%
    group_by(date_time_hour = floor_date(date_time, "1 hour")) %>%
    summarise(
        vapour_pressure = mean(vapour_pressure),
        atmospheric_pressure = mean(atmospheric_pressure),
        vapour_pressure_hpa = mean(vapour_pressure_hpa),
        atmospheric_pressure_hpa = mean(atmospheric_pressure_hpa)
    ) %>%
    ungroup() %>%
    arrange(desc(date_time_hour))






## Air Temp
## *************************

air_temp <- data_list[["air-temperature-observations.csv"]]

## Turn date_time into datetime object
air_temp$date_time <- 
    lubridate::ymd_hms(substr(air_temp$date_time, 1, 20))

## Force timezone
air_temp$date_time <- 
    force_tz(air_temp$date_time, tzone = "Australia/Sydney")

## Sort data
air_temp <- air_temp %>% arrange(desc(date_time))

## Select cols and filter to rowing
air_temp <-
    air_temp %>%
    filter(location_description == "Rowing Course") %>%
    select(
        -location_description,
        -latitude,
        -longitude,
        -point
    )


## Take mean by hour
air_temp_hour <- 
    air_temp %>%
    group_by(date_time_hour = floor_date(date_time, "1 hour")) %>%
    summarise(
        air_temperature = mean(air_temperature)
    ) %>%
    ungroup() %>%
    arrange(desc(date_time_hour))



## Humidity
## *************************
humidity <- data_list[["humidity-observations.csv"]]

## Turn date_time into datetime object
humidity$date_time <- 
    lubridate::ymd_hms(substr(humidity$date_time, 1, 20))

## Force timezone
humidity$date_time <- 
    force_tz(humidity$date_time, tzone = "Australia/Sydney")

## Sort data
humidity <- humidity %>% arrange(desc(date_time))

## Select cols and filter to rowing
humidity <-
    humidity %>%
    filter(location_description == "Rowing Course") %>%
    select(
        -location_description,
        -latitude,
        -longitude,
        -point
    )


## Take mean by hour
humidity_hour <- 
    humidity %>%
    group_by(date_time_hour = floor_date(date_time, "1 hour")) %>%
    summarise(
        relative_humidity = mean(relative_humidity)
    ) %>%
    ungroup() %>%
    arrange(desc(date_time_hour))


## Solar radiation
## *************************



## Wind
## *************************




