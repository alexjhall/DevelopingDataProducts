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

## Each dataset requires slightly different treatment, so can't create one function to clean them all.
## In fairness, could have done a lot of common steps with a function, even if it didn't do everything.

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

## Remove error data
air_pressure <- air_pressure %>%
    filter(vapour_pressure >= 0 & vapour_pressure <= 5,
           atmospheric_pressure > 80)

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
    filter(location_description == "Rowing Course",
           air_temp$air_temperature > -100) %>%
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
    filter(location_description == "Rowing Course",
           relative_humidity >=0 & relative_humidity <=100) %>%
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
solar <- data_list[["solar-radiation-observations.csv"]]

## Turn date_time into datetime object
solar$date_time <- 
    lubridate::ymd_hms(substr(solar$date_time, 1, 20))

## Force timezone
solar$date_time <- 
    force_tz(solar$date_time, tzone = "Australia/Sydney")

## Sort data
solar <- solar %>% arrange(desc(date_time))

## Select cols and filter to rowing
solar <-
    solar %>%
    filter(
        solar_radiation >=0,
        # 'dead spot' where solar collected as 0 night and day...
        (date_time < "2021-10-29" | date_time > "2023-03-17") 
        ) %>%
    select(
        -location_description,
        -latitude,
        -longitude,
        -point
    )

## Mutate to correct 


## Take mean by hour
solar_hour <- 
    solar %>%
    group_by(date_time_hour = floor_date(date_time, "1 hour")) %>%
    summarise(
        solar_radiation = mean(solar_radiation)
    ) %>%
    ungroup() %>%
    arrange(desc(date_time_hour))


## Wind
## *************************
wind <- data_list[["wind-observations.csv"]]

## Turn date_time into datetime object
wind$date_time <- 
    lubridate::ymd_hms(substr(wind$date_time, 1, 20))

## Force timezone
wind$date_time <- 
    force_tz(wind$date_time, tzone = "Australia/Sydney")

## Sort data
wind <- wind %>% arrange(desc(date_time))

## Work out wind direction boundaries
## To be used later in reassigning direction
wind_direction_ranges <-
    wind %>%
    group_by(wind_direction_cardinal) %>%
    summarise(
        wind_direction_min = min(wind_direction),
        wind_direction_max = max(wind_direction)
    ) %>%
    ungroup() %>% arrange(wind_direction_min)


## Select cols and filter to rowing
wind <-
    wind %>%
    select(
        -location_description,
        -latitude,
        -longitude,
        -point,
        # Remove some variables not displayed in table in data source url, therefore thought to be superseded
        -polar,
        -average_wind_speed,
        -gust_speed
    )


## Take mean by hour
wind_hour <- 
    wind %>%
    group_by(date_time_hour = floor_date(date_time, "1 hour")) %>%
    summarise(
        wind_speed_average = mean(wind_speed_average),
        wind_speed_gust = mean(wind_speed_gust),
        wind_direction = mean(wind_direction)
    ) %>%
    ungroup() %>%
    arrange(desc(date_time_hour))


## Case when to assign wind direction factors based on earlier ranges
wind_hour <- 
    wind_hour %>%
    mutate(
    wind_direction_cardinal = case_when(
        wind_direction > 348.7 | wind_direction <= 11.2 ~ "N",
        wind_direction > 11.2 & wind_direction <= 33.7 ~ "NNE",
        wind_direction > 33.7 & wind_direction <= 56.2 ~ "NE",
        wind_direction > 56.2 & wind_direction <= 78.7 ~ "ENE",
        wind_direction > 78.7 & wind_direction <= 101.2 ~ "E",
        wind_direction > 101.2 & wind_direction <= 123.7 ~ "ESE",
        wind_direction > 123.7 & wind_direction <= 146.2 ~ "SE",
        wind_direction > 146.2 & wind_direction <= 168.7 ~ "SSE",
        wind_direction > 168.7 & wind_direction <= 191.2 ~ "S",
        wind_direction > 191.2 & wind_direction <= 213.7 ~ "SSW",
        wind_direction > 213.7 & wind_direction <= 236.2 ~ "SW",
        wind_direction > 236.2 & wind_direction <= 258.7 ~ "WSW",
        wind_direction > 258.7 & wind_direction <= 281.2 ~ "W",
        wind_direction > 281.2 & wind_direction <= 303.7 ~ "WNW",
        wind_direction > 303.7 & wind_direction <= 326.2 ~ "NW",
        wind_direction > 326.2 & wind_direction <= 348.7 ~ "NNW"
    )
    )


## Merge datasets
## *************************

## Put dataframes into list
dataframe_hour_list <-
    list(
        air_pressure_hour,
        air_temp_hour,
        humidity_hour,
        solar_hour,
        wind_hour
    )

## Merge
# Missing lots of wind data in the middle
data <- 
    dataframe_hour_list %>%
    reduce(full_join, by = 'date_time_hour')


## Check for complete cases
data_complete <-
    data[complete.cases(data),]

## Some cleaning identified in scratchpad and implemented in individual filter steps for each dataset above.
write.csv(
    data_complete, 
    file = here("Data/Ballarat/Clean/data.csv"),
    row.names=FALSE
)





## Save to single csv. Load data for shiny app from here.










