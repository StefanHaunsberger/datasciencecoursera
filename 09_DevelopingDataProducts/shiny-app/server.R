require(shiny)
require(googleVis)
require(dplyr)

shinyServer(function(input, output) {
  
    output$text <- renderPrint({paste0("You are viewing tab \"", input$tabs, "\"")});
  
    output$distPlot = renderPlot({
        dist = rnorm(input$ops)
        hist(dist)
    });
    
    #################################
    # Generating gvisGeoChart
    ## Data
    col.choice = reactive({
                    names(column.select.choices)[as.integer(input$tab_map.data.disp)]
                })
    mapData = reactive({
        colNum = match(col.choice(), colnames(df));
        d = df %>%
            filter(Year == input$yearMap) %>%
            select(Country, colNum, Year, Region);
        d = d[order(d[,2], decreasing = TRUE),];
    })
    ## Map
    output$geoChart = renderGvis({
        gvisGeoChart(data = mapData(), locationvar = "Country",
                     # colorvar = "PopTotal",
                     colorvar = as.character(col.choice()),
                     options = list(width = 800,
                                    height = 600,
                                    projection = "kavrayskiy-vii",
                                    colorAxis = "{colors:['#91BFBD', '#FC8D59']}",
                                    legend.number.Format = "{numberFormat:'#,###'}",
                                    tooltip.number.Format = "{numberFormat:'#,###'}"));
    })
    
#     output$top10Table = renderGvis({
#         d = mapData()[1:10,]
#         if (class(d[,2]) == "integer") {
#             fm = list();
#             fm[[col.choice()]] = "#,###";
#             gvisTable(d, formats = fm, options = list(pageSize = 10))
#         } else {
#             gvisTable(d, options = list(pageSize = 10))
#         }
#     })
    output$top10Table = renderTable(mapData()[1:10,]);
    output$tab_map.mp.label = renderText(sprintf("Map view of indicator '%s' in year '%i'",
                                                  col.choice(), input$yearMap));
    
    ########################################
    # Motion Chart
    output$motionChart = renderGvis({
        gvisMotionChart(df, idvar = "Country", timevar = "Year", options = list(height=768, width=1024))
    })
    
    ########################################
    # Data table
    ## Selected regions
    region.selected = reactive({
        if (is.null(input$region)) {
            regions.unique
        } else {
            # as.vector(regions.unique[as.integer(input$region)])
            regions.unique[as.integer(input$region)]
        }
    })
    ## Create data table
    ## Generate data
    tableData = reactive({
        d = df %>%
            filter(Year == input$yearTable, Region %in% region.selected()) %>%
            select(Country, PopTotal, Year, Region) %>%
            arrange(desc(Country));
    })
    ## Table options
    tableOptions = reactive({
        list(
            page=ifelse(input$pageable==TRUE,'enable', 'disable'),
            # pageSize=input$pagesize,
            pageSize = ifelse(input$pageable==TRUE,input$pagesize, 0)
            # width=550
        )
    });
    ## Actual googleVis table
    output$dataTable = renderGvis({
        # cat(paste("values:", paste0(region.selected(), collapse = " ; ")))
        gvisTable(tableData(), options = tableOptions())
        # gvisTable(tableData())
    })
    
})