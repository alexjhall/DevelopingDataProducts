## Modelling

## Load libraries
library(tidyverse)
library(here)
library(lubridate)
library(shiny)
library(GGally) ## for ggpairs plot
library(corrplot) ## for correlation matrix
library(performance)

## Load data
data <-
    read_csv(here("Data/Ballarat/Clean/data.csv"))

## Reduced data
data_reduc <-
    data %>%
    select(
        -date_time_hour,
        -vapour_pressure_hpa,
        -atmospheric_pressure_hpa,
        -wind_direction_cardinal,
        -hour_of_day,
        -month_of_year,
        -wind_speed_gust ## Very similar to wind_speed_average
    )

## numeric vars only
data_reduc_numeric <-
    data_reduc %>%
    select(
        -season,
        -time_of_day
    )

## Look at correlations
## Correlation matrix
corrplot(cor(data_reduc_numeric), method = "number")


## Check model variables stepwise.
## Intercept only model
intercept_only <- lm(air_temperature ~ 1, data = data_reduc)

## All vars model
all_vars <- lm(air_temperature ~ ., data = data_reduc)

## perform forwards stepwise
forward_step <- step(intercept_only,
                     direction = "forward",
                     scope = formula(all_vars),
                     trace = 0)

## Check results
forward_step$anova

## Summary
summary(forward_step)

## Best model is everything, apart from solar_radiation.
model_to_test <- lm(air_temperature ~ 
                    wind_speed_average +
                    time_of_day +
                    season +
                    vapour_pressure + 
                    atmospheric_pressure + 
                    relative_humidity +
                    wind_direction,
                    data=data)

## summary
summary(model_to_test)

## Diagnostics
performance::check_model(model_to_test)
## Seems good enough.














## ************************************
## Model exploration.
## Couldn't find a good predictor of wind speed....
## Opted to just show predicted temp instead.


## model to look at
model <- lm(air_temperature ~ 
                wind_speed_average +
                # air_temperature +
                time_of_day +
                season +
                # date_time_hour +
                vapour_pressure + 
                atmospheric_pressure + 
                relative_humidity +
                solar_radiation +
                wind_direction +
                wind_speed_average +
                wind_speed_gust
            ,
            data=data)

## Summary
summary(model)






## Start testing models.
model <- lm(wind_speed_average ~ ., data=data)

## Summary
summary(model)


## Start testing models.
model <- lm(air_temperature ~ 
            # date_time_hour +
            vapour_pressure + 
            atmospheric_pressure + 
            relative_humidity +
            solar_radiation +
            wind_direction +
            wind_speed_average +
            wind_speed_gust,
            data=data)

## Summary
summary(model)


## Start testing models.
model <- lm(wind_speed_average ~ 
            air_temperature +
            # date_time_hour +
            vapour_pressure + 
            atmospheric_pressure + 
            relative_humidity +
            solar_radiation
            # wind_direction +
            # wind_speed_average +
            # wind_speed_gust
            ,
            data=data)

## Summary
summary(model)


## Now with new date/time variables

## Start testing models.
model <- lm(air_temperature ~ 
            wind_speed_average +
            # air_temperature +
            time_of_day +
            season +
            # date_time_hour +
            vapour_pressure + 
            atmospheric_pressure + 
            relative_humidity +
            solar_radiation +
            wind_direction +
            wind_speed_average +
            wind_speed_gust
            ,
            data=data)

## Summary
summary(model)







