## Modelling

## Load libraries
library(tidyverse)
library(here)
library(lubridate)
library(shiny)

## Load data
data <-
    read_csv(here("Data/Ballarat/Clean/data.csv"))

## Start testing models.
model <- lm(wind_speed_average ~ ., data=data)

## Summary
summary(model)


## Start testing models.
model <- lm(wind_speed_average ~ 
            # date_time_hour +
            vapour_pressure + 
            atmospheric_pressure + 
            air_temperature +
            relative_humidity +
            solar_radiation +
            wind_direction,
            data=data)

## Summary
summary(model)
