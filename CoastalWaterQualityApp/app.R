#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# load required packages
library(shiny) # client-server web applications with R
library(shinythemes)
library(tidyverse) # data wrangling and static plotting
library(plotly) # interactive plotting

# read pre-processed data, includes water quality and other global factors
map_df <- read_rds("../world_plus_pop_gdp.rds") %>% 
  filter(!is.na(waterquality),!is.na(GDP)) %>% 
  arrange(Country,Year)

# Define the User Interface, with placeholders for plots, etc
ui <- navbarPage(theme = shinytheme("cerulean"),
            title =" Algae Explorer",
                 
                 tabPanel("Water Quality Map",
                          
                          
                          # Application title
                          titlePanel(h1("Coastal Water Quality, 1998-2007", align = "center",
                          style={'background-color: lightblue;
                             margin-left: -15px;
                              margin-right: -15px;
                              padding-left: 15px;'})),
                           
                          
                          fluidRow(
                            column(4, 
                                   div( style = "border-style: solid; border-color: lightblue;",
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
                                               selected = "Albania"),
                            )),
                            
                            column(8,
                                   div( style = "border-style: hidden; border-color: lightblue;",
                                        plotOutput("timeseriesplot", height = 200) ) )
                          ),
               
                          
                      
              fluidRow(
                            h3("Interactive Water Quality Map", align = "center")),
                          
                          # Sidebar with a slider input for number of bins 
                          fluidRow(
                            
                            column(12,
                                   div( style = "border-style: solid; border-color: lightgreen;",
                                   plotlyOutput("map", height = 500 ),)
                            )),
            
                  ),
                        
                 
                 tabPanel("Global Factors",
                          
                          titlePanel(h1("Coastal Water Quality vs. Global Factors, 1998-2007", align = "center",
                                        style={'background-color: lightblue;
                                              margin-left: -15px;
                                             margin-right: -15px;
                                              padding-left: 15px;'})),

                   sidebarLayout(
                           
                      sidebarPanel(
                          selectInput(
                            inputId = "countries2", 
                            label = "Select Country",
                                      choices = unique(map_df$Country),
                                     selected = "Albania" ),
                          
                          selectInput("globalfactors","Which Global Factor?",c("PopTotal","PopFemale","PopMale","GDP"))),
                
                     
                         
                          mainPanel(
                            div( style = "border-style: solid; border-color: lightblue;",
                                  plotOutput("plot",height = 600)),
                            
                            tags$div(
                              tags$span(style = "color: lightgreen;", "The Green Line Represents Water Quality")),
                            
                            tags$div(
                              tags$span(style = "color: lightblue;", "The Blue Line Represents the Global Factor")),
                          
                              h6('*GDP is Per Capita')
                          
                      ))),
              
                 navbarMenu("More Info",
                            tabPanel("Summary",
                                     
                                     titlePanel(h1("Summary", align = "center",
                                                   style={'background-color: lightblue;
                                                        margin-left: -15px;
                                                        margin-right: -15px;
                                                       padding-left: 15px;'})),
                                     
                                     h3("What is being Measured?"), 
                                     h4("Our water quality data is measured by using the mean amount of Chlorophyll A 
                                        in nanograms per cubic meter, per year, for every coastal country."),
                                     h3("What is Chlorophyll A?"),
                                     h4("Chlorophyll A is often a direct indicator of algae growth,
                                        which then indicates water quality. Higher values of Chlorophyll A indicate higher levels of 
                                        algae which can indicate poor water quality. This is because too much algae can 
                                        lead to decreased levels of oxygen in the water, which harms other organisms in the 
                                        ecosystem. Lower levels of Chlorophyll A tend to indicate better water quality."),
                                     h3("How was our Data Collected?"),
                                     h4("This data was collected by using a tool from NASA called the Sea Viewing Wide Field-of-View sensor, aka SeaWiFS.
                                        We then found this data, which had already been collected and interpreted, online. The link to more information about 
                                        NASA's SeaWiFS and the website we pulled our data from will be listed below."),
                                     h4(tags$a(href="https://oceancolor.gsfc.nasa.gov/SeaWiFS/BACKGROUND/","Click here for info about SeaWiFS")),
                                     h4(tags$a(href="https://sedac.ciesin.columbia.edu/data/collection/icwq", "Click here for original data")),
                                     h3('What is Going on in the Baltic Sea?'),
                                     h4("As you may have noticed, Finland, on average, has the highest concetration of Chlorophyll A over the given time period.The countries around
                                        it have high concentrations as well. So what's going on there? Well, the Baltic Sea has had issues with excessive nutrients
                                        causing Eutrophication since at least the 1950s. Eutrophication, simply put, is when there is an overgrowth in organic matters (like algae)
                                        caused by an excess of certain nutrients. This is then leads to loss of biodiversity for many reasons, 
                                        one of the main reasons being oxygen depletion. This is still a problem that is affecting Finland and the surrounding
                                        countries to this day. There will be a link listed below if you'd like to read more about this issue."),
                                     h4(tags$a(href="https://www.wwfbaltic.org/our-vision-for-the-baltic-sea/reduce-eutrophication/", 
                                               "Click here for more info on Eutrophication in the Baltic Sea"))),
                            
                              
                                     
                            tabPanel("Credits",
                                     titlePanel(h1("Credits", align = "center",
                                                   style={'background-color: lightblue;
                                      margin-left: -15px;
                                      margin-right: -15px;
                                      padding-left: 15px;'})),
                                     
                                     h3("Data Source"),
                                     h4(tags$a(href="https://sedac.ciesin.columbia.edu/data/collection/icwq", "Click here for original data")),
                                     h3("Other Important Links"),
                                     h4(tags$a(href="https://ozcoasts.org.au/indicators/biophysical-indicators/chlorophyll_a/", 
                                               "Description of Chlorophyll A and Why it is Important")),
                                     h4(tags$a(href="https://www.epa.gov/national-aquatic-resource-surveys/indicators-chlorophyll",
                                               "Another Description of Chlorophyll A and its Indications")),
                                     h4(tags$a(href="https://helcom.fi/baltic-sea-trends/eutrophication/", 
                                               "Helpful Definition and Explaination of Eutrophication")),
                                     h4(tags$a(href="https://oceancolor.gsfc.nasa.gov/SeaWiFS/BACKGROUND/", "SeaWiFS Website")),
                                     h4(tags$a(href="Baltic Sea Eutrophication")),
                                     h4("This Shiny App was created by Kenna Foerg with help from Joe Champion")),
                            tabPanel("Get Code",
                                     
                                     titlePanel(h1("Get Code", align = "center",
                                                   style={'background-color: lightblue;
                                                    margin-left: -15px;
                                                     margin-right: -15px;
                                                     padding-left: 15px;'})),
                                     
                                  h4(tags$a(href="https://github.com/mathedjoe/CoastalWaterQuality", "Click here to Get the Code")),
                                     
                                     ),
                            tabPanel("Here's What I Have to Say to New Math Students",
                                     
                                     titlePanel(h1("Advice to New Math Students", align = "center",
                                                   style={'background-color: lightblue;
                                                     margin-left: -15px;
                                                     margin-right: -15px;
                                                     padding-left: 15px;'})),
                                     
                                     h3("Advice For A Student Who Is Struggling to Understand 
                                        Connections Between Different Math Courses They Have Taken"),
                                     h4("The biggest thing that you can do is talk to your professors. Ask them what
                                        kind of work they are currently doing and what work they've done in the past. 
                                        Then, if something they say interests you, do more research on it! Try to find 
                                        elements of your coursework in whatever it is you are researching about. That way
                                       you are able to learn the applications of the work you are doing and also know if 
                                        it is something you want to pursue further."),
                                      h3("The Ties Between This Project, Earlier Coursework, and My Future Plans"),
                                      h4("I used R and RStudio a lot throughout various statistics courses, but I never 
                                         really got to see the whole potential of what could be done with this program. I 
                                         learned many of the basics, but most of the time I was just copying code from a 
                                         professor and then identifying the right times to reuse that code. This project has
                                         allowed me to build on the basic skills that I learned and create something that I 
                                         really care about. Beyond that, I have always been interested in the field of data analytics
                                         and visualization, and this was a great way to introduce me to that on a smaller scale. I 
                                         got experience finding, cleaning, merging, and using data all in a relatively short period of 
                                         time."),
                                      h3("What I Would Have Found Interesting About This Project as a Freshman"),
                                      h4("I think the biggest thing that would interest me would be the fact that this 
                                         type of data visualization is even possible for an undergrad. Not only that,
                                         but I think I would also be surprised to know how relatively easy it actually is to 
                                         create. At the beginning of my degree I was much more focused on just getting through my 
                                         classes instead of looking into what more I could do with what I was learning, so 
                                         knowing that one day I would be able to do this would surprise me. I also think I would 
                                         be interested to see a project that is not just entirely pure math, but something that 
                                         anyone would be able to look at and understand/interact with. On a personal note, I also 
                                         have always loved the ocean, so the subject matter would interest me as well.")
                                         )
                                  )
)
                 
    



# Define server logic to update the app whenever users interact with the UI
server <- function(input, output) {

    output$map <- renderPlotly({

      this_year <-input$year
      
      # update the 'country' whenever a user clicks on the map
      country_click <- event_data(event='plotly_click')
      if(! is.null(country_click)) {
        country_clicked <- map_df$Country[country_click$pointNumber + 1]
        updateSelectInput(inputId = "country", selected = country_clicked)
      } 
      
      # interactive map (updates when year is changed)
      plot_geo(map_df %>% filter(Year == this_year)) |> 
        add_trace(
          z = ~waterquality, 
          color = ~waterquality, 
          colors = 'YlGn',
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
        ggplot() +
        aes(x = Year, y = waterquality) + 
        geom_line(size = 1.5) +
        geom_point(size = 4) +
        labs(title = paste("Trend Over Time:", input$country), 
             x = NULL, y = "Chlorophyll A in ng/cc")+
       scale_x_continuous(breaks = 1998:2007) +
       scale_y_continuous(expand = expansion(c(1.5,1.5)))+
        theme_minimal()
     
    })
    
  #  d <- reactive({
   #   globalfactors<- switch(input$globalfactors,
    #                         PopTotal = PopTotal,
     #                        PopFemale = PopFemale,
      #                       PopMale = PopMale)
 #   })
    
   
    
   output$plot <- renderPlot({
     
     this_gf <-input$globalfactors
   
      map_df |> 
       filter(Country == input$countries2) |> 
        ggplot() +
        aes(x = Year)+
        geom_line(aes(y = get(input$globalfactors)/10000), color = "skyblue2", size = 1.5) + 
        geom_line(aes(y = waterquality), color = "palegreen3", size = 1.5) +
        labs(title = paste("Trend Over Time:", input$countries2), 
             x = NULL, y = "Chlorophyll A in ng/cc")+
        scale_x_continuous(breaks = 1998:2007) +
        scale_y_continuous(
          
          name = "Chlorophyll A in ng/cc",
          expand = expansion(c(1.5,1.5)),
          
          sec.axis = sec_axis(trans~.*10, name = "Population (in Millions) / Dollars (in thousands for GDP)"))+
      theme_minimal()
        
    })

}

# Run the application 
shinyApp(ui = ui, server = server)
