library(shiny)

shinyUI(fluidPage( 
    
    titlePanel("Visualization of Population Indicators with Shiny"),
    
    tabsetPanel(id = "tabs",
        tabPanel("Description", value = "tab_description",
                 titlePanel("Description"),
                 
                 navlistPanel(
                     # "Header",
                     tabPanel("General",
                              # h3("This is the first panel"),
                              includeMarkdown(file.path("description-general.Rmd"))
                     ),
                     tabPanel("Dataset",
                              # h3(""),
                              includeMarkdown(file.path("description-data.Rmd"))
                     ),
                     tabPanel("Data Visualization",
                              includeMarkdown(file.path("description-visualization.Rmd"))
                     )
                 )
        ),
        tabPanel("Map view", value = "tab_map",
                 h2("Animated map view of selected indicators a year."),
             sidebarLayout(
                sidebarPanel(
                    h3("Choose Input Values"),
                    sliderInput("yearMap", "Year to be displayed:", 
                                min=min(df$Year), max=max(df$Year),
                                value=as.integer(format(Sys.Date(), "%Y")), 
                                step=1, sep="", animate=TRUE),
                    selectInput(inputId = "tab_map.data.disp", label = "Select Input Data",
                                choices = column.select.choices, selected = 3),
                    hr(),
                    h4("Top 10"),
                    tableOutput("top10Table")
                ),
                mainPanel(
                    h2(textOutput("tab_map.mp.label")),
                    htmlOutput("geoChart")
                )
             )
        ),
        tabPanel("Data Table View", value = "tab_table",
                 h2("Table View of selected Data"),
             sidebarLayout(
                 sidebarPanel(
                    sliderInput("yearTable", "Year to be displayed:", 
                                min=min(df$Year), max=max(df$Year), value=as.integer(format(Sys.Date(), "%Y")),  step=1,
                                sep=""),
                    selectInput(inputId = "region", label = "Select Region",
                                choices = regions.select.choices, multiple = TRUE),
                    checkboxInput(inputId = "pageable", label = "Pageable", value = TRUE),
                    conditionalPanel("input.pageable == true",
                         numericInput(inputId = "pagesize",
                                      label = "Countries per page", 25)
                    )
                 ),
                 mainPanel(
                    # "Motion Chart with variable constellations",
                    htmlOutput("dataTable")
                 )
             )
        ),
        tabPanel("Motion Chart", value = "tab_motion",
                 h2("Motion Chart with variable input parameters"),
                 mainPanel(
                     htmlOutput("motionChart")
                 )
        )
    )
                         
))