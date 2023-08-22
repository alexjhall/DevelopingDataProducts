## UI file

## Load packages
source(here::here("Shiny/Packages.R"))

## Import data
data <-
    read_csv(here("Data/Ballarat/Clean/data.csv"))


# Define UI for application that draws a histogram
fluidPage(
    
    
    
    # Application title
    titlePanel("Predicting Ballarat Lake Wendouree Temperature"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            helpText("Make seletions to predict the temperature!"),
            
            sliderInput("relative_humidity_input",
                        "Relative humidity (%):",
                        min = 0,
                        max = 100,
                        value = 50,
                        ticks = FALSE),
            
            sliderInput("atmospheric_pressure_input",
                        "Atmospheric pressure (Pa):",
                        min = 94,
                        max = 100,
                        value = 97,
                        step = 0.25,
                        ticks = FALSE),
            
            sliderInput("vapour_pressure_input",
                        "Vapour pressure (Pa):",
                        min = 0,
                        max = 3,
                        value = 1.5,
                        step = 0.25,
                        ticks = FALSE),
            
            sliderInput("wind_speed_average_input",
                        "Average wind speed (km/h):",
                        min = 0,
                        max = 60,
                        value = 30,
                        ticks = FALSE),
            
            sliderInput("wind_direction_input",
                        "Wind direction (°):",
                        min = 0,
                        max = 360,
                        value = 180,
                        ticks = FALSE),
            
            selectInput("time_of_day_input",
                        "Time of day:",
                        choices = list(
                            "Early morning",
                            "Morning",
                            "Noon",
                            "Evening",
                            "Night"
                        ),
                        selected = "Noon"),
            
            selectInput("season_input",
                        "Season:",
                        choices = list(
                            "Summer",
                            "Autumn",
                            "Winter"
                            ),
                        selected = "Summer")

        ),

        
        # Show a plot of the generated distribution
        mainPanel(
            h2("Introduction and instructions"),
            p("This R shiny web application has been built as part of the Developing Data Products module in the John 
              Hopkins Data Science Specialisation course."),
            p("This app allows the user to predict that air temperature at Lake Wendouree in Ballarat, Victoria, Australia.
              The data was sourced from the",
              a("City of Ballarat Data Exchange", href = "https://data.ballarat.vic.gov.au/explore/"),
              "which allows access to various weather sensors located at the rowing course at Lake Wendouree
              such as temperature, pressure, wind measurements etc. After data cleaning, a linear regression model was fit
              and this app allows the user to manipulate various independent variables to predict the air temperature
              dependent variable.",
              "Data was collected from the sensors every 15 minutes and was aggregated to an hourly level. Importantly, 
              times with missing data for at least one sensor were removed. Therefore the model was fit with data from a
              period in 2020 and a period in 2023 where there was complete data across all of the sensors.",
              "For an unknown reason, this excluded data from September, October and November (Spring)."
            ),
            p("Full code and details can be found at this",
              a("GitHub repository.", href = "https://github.com/alexjhall/DevelopingDataProducts"),
            ),
            p("To use the app, just make selections using the sliders and selection boxes on the left.",
              "The predicted temperature and lower and upper bounds of the 95% confidence interval will be displayed."
            ),
            

            
            ## Predicted temperature
            h2("Predicted temperature according to selected inuputs:"),
            p(
                textOutput("predictedTemp", inline = T),
                "°C",
                "(",
                textOutput("predictedTempIntervalLower", inline = T),
                " - ",
                textOutput("predictedTempIntervalUpper", inline = T),
                "°C)"
            ),
            
            ## test
            textOutput("predictedTempInterval")

            
        )
    )
)
