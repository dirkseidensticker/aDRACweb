#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# see: http://shiny.rstudio.com/gallery/basic-datatable.html
# see: http://www.r-bloggers.com/getting-data-from-an-online-source/


library(DT)
library(shiny)
library(RCurl)
library(data.table)

data <- data.table::fread(
  'https://raw.githubusercontent.com/dirkseidensticker/aDRAC/master/aDRAC.csv',
  encoding = "UTF-8"
)

# Define the overall UI
ui <- shinyUI(
  fluidPage(
    titlePanel("aDRAC (Archives des datations radiocarbone d'Afrique centrale)"),
    
    # Create a new Row in the UI for selectInputs
    fluidRow(
      column(3,
             selectInput("SITE",
                         "Site:",
                         c("All",
                           unique(as.character(data$SITE))))
      ),
      column(3,
             selectInput("COUNTRY",
                         "Country:",
                         c("All",
                           unique(as.character(data$COUNTRY))))
      ),
      column(3,
             selectInput("MATERIAL",
                         "Dated Material:",
                         c("All",
                           unique(as.character(data$MATERIAL))))
      ),
      column(3,
             selectInput("SOURCE",
                         "Source:",
                         c("All",
                           unique(as.character(data$SOURCE))))
      )
    ),
    # Create a new row for the table.
    fluidRow(
      DT::dataTableOutput("table")
    )
  )
)

# Define a server for the Shiny app
server <- shinyServer(function(input, output) {
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- data
    if (input$SITE != "All") {
      data <- data[data$SITE == input$SITE,]
    }
    if (input$COUNTRY != "All") {
      data <- data[data$COUNTRY == input$COUNTRY,]
    }
    if (input$MATERIAL != "All") {
      data <- data[data$MATERIAL == input$MATERIAL,]
    }
    if (input$SOURCE != "All") {
      data <- data[data$SOURCE == input$SOURCE,]
    }
    data
  }))
  
})

# Run the application 
shinyApp(ui = ui, server = server)
