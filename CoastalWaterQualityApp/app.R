#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

world_plus_ts <- read_rds("../world_plus_ts.rds") 

# Define UI for application that draws a histogram
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
                        value = 1998),
            selectInput("country", 
                        "Which Country?",
                        choices = unique(world_plus_ts$region),
                        selected = "Algeria")
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("map"),
           plotOutput("timeseriesplot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$map <- renderPlot({
      world_plus_ts |> 
        ggplot() +
        geom_map( map = world,
                  aes(long, lat, 
                      map_id = region, 
                      fill = !! as.symbol(paste0("x", input$year)) ),
                  color = "#333333", size = 0.1
        ) +
        theme_void()
    })
    
    output$timeseriesplot <- renderPlot({
      world_plus_ts |> 
        filter(region == input$country) |> 
        select(region, starts_with("x")) |> 
        slice(1) |> 
        pivot_longer(-region, names_to = "year") |> 
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
