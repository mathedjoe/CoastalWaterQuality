#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# load required packages
library(shiny) # client-server web applications with R
library(tidyverse) # data wrangling and static plotting
library(plotly) # interactive plotting

# read pre-processed data, includes water quality and other global factors
map_df <- read_rds("../world_plus_ts.rds") |> 
  filter(!is.na(x1998))

# Define the User Interface, with placeholders for plots, etc
ui <- fluidPage(
  
  # Application title
  titlePanel("Coastal Water Quality, 1998-2007"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("year",
                  "Which year?",
                  min = 1998,
                  max = 2007,
                  step = 1,
                  value = 1998,
                  sep="", 
                  animate = animationOptions(interval = 1200)),
      selectInput("country", 
                  "Which Country?",
                  choices = unique(map_df$Country),
                  selected = "Abania")
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput("map"),
      plotOutput("timeseriesplot")
    )
  )
)

# Define server logic to update the app whenever users interact with the UI
server <- function(input, output) {
  
  output$map <- renderPlotly({
    
    this_year <- paste0("x", input$year)
    
    # update the 'country' whenever a user clicks on the map
    country_click <- event_data(event='plotly_click')
    if(! is.null(country_click)) {
      country_clicked <- map_df$Country[country_click$pointNumber + 1]
      updateSelectInput(inputId = "country", selected = country_clicked)
    } 
    
    # interactive map (updates when year is changed)
    plot_geo(map_df) |> 
      add_trace(
        z = ~eval(parse(text = this_year)), 
        color = ~eval(parse(text = this_year)), 
        colors = 'Blues',
        text = ~Country, 
        locations = ~Code, 
        marker = list(line = list(color = "#eeeeee", width = 0.5))
      ) |> 
      colorbar(title = this_year) |> 
      layout(
        title = '',
        geo = list(
          showframe = FALSE,
          showcoastlines = FALSE,
          landcolor = '#eeeeee',
          countrycolor = '#cccccc',
          showcountries = TRUE,
          showland = TRUE,
          projection = list(type = 'natural earth')
        )
      )
  })
  
  # static plot of water quality time series (updates when country changes)
  output$timeseriesplot <- renderPlot({
    map_df |> 
      filter(Country == input$country) |> 
      select(Country, starts_with("x")) |> 
      slice(1) |> 
      pivot_longer(-Country, names_to = "year") |> 
      mutate(year = as.numeric(gsub("x", "", year))) |> 
      ggplot() +
      aes(x = year, y = value) + 
      geom_line() +
      geom_point() +
      scale_x_continuous( breaks = 1998:2007) 
    # scale_y_continuous(limits = c(0,1))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)