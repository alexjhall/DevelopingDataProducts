## Server file


## Load packages
library(shiny)
# library(tidyverse)
library(here)



# Define server logic required to draw a histogram
function(input, output, session) {
    
    ## Import data
    data <-
        read_csv(here("data.csv"))
    

    
    ## Build model
    model <- lm(air_temperature ~ 
                wind_speed_average +
                time_of_day +
                season +
                vapour_pressure + 
                atmospheric_pressure + 
                relative_humidity +
                wind_direction,
                data=data)
    
    
    ## Make predictions from model
    model_prediction <- reactive({
        
        ## Create dataframe based on ui inputs
        input_df <-
            data.frame(
                wind_speed_average = input$wind_speed_average_input,
                time_of_day = input$time_of_day_input,
                season = input$season_input,
                vapour_pressure = input$vapour_pressure_input,
                atmospheric_pressure = input$atmospheric_pressure_input,
                relative_humidity = input$relative_humidity_input,
                wind_direction = input$wind_direction_input
            )
        
        ## Make predictions
        predict(
            object = model,
            newdata = input_df
        )
        
    })
    
    ## Make predictions from model
    model_prediction_interval <- reactive({
        
        ## Create dataframe based on ui inputs
        input_df <-
            data.frame(
                wind_speed_average = input$wind_speed_average_input,
                time_of_day = input$time_of_day_input,
                season = input$season_input,
                vapour_pressure = input$vapour_pressure_input,
                atmospheric_pressure = input$atmospheric_pressure_input,
                relative_humidity = input$relative_humidity_input,
                wind_direction = input$wind_direction_input
            )
        
        ## Make predictions
        predict(
            object = model,
            newdata = input_df,
            interval = "confidence"
        )
        
    })
    
    
    ## Output prediction value
    output$predictedTemp <- renderText({
        round(model_prediction(), 2)
    })
    
    ## Output prediction interval - Lower
    output$predictedTempIntervalLower <- renderText({
        round(model_prediction_interval()[2], 2)
    })
    
    ## Output prediction interval - Upper
    output$predictedTempIntervalUpper <- renderText({
        round(model_prediction_interval()[3], 2)
    })
    
    
    
    
    
}
