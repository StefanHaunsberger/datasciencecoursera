library(shiny)    

shinyUI(basicPage( 
  
  # Load Google charts JS library
  # googleChartsInit(),
  
  h2("Visualization of prepared data from x"),
  
  tabsetPanel(id = "tabs",
              tabPanel("Table view", value = "tab_table", "This is Tab A content",
                       
                         pageWithSidebar(
                           headerPanel("Example 3: animated geo chart"),
                           sidebarPanel(
                             sliderInput("Year", "Election year to be displayed:", 
                                         min=1932, max=2012, value=2012,  step=4,
                                         sep="", animate=TRUE)
                           ),
                           mainPanel(
                             h3(textOutput("year")), 
                             htmlOutput("gvis")
                           )
                         )
                       
                       ),
              tabPanel("Map view", value = "tap_map", "Here's some content for tab B.")
  )
  
))