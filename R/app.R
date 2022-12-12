library(shiny)
library(lipdR)
library(tidyr)


# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {




  output$summary2 <- renderPrint({
    print(tibble(queryLipdverse(variable.name = input$variable.name,
                                archive.type = input$archiveType,
                                paleo.proxy = NULL,
                                paleo.units = NULL,
                                coord = c(input$min.lat,
                                          input$max.lat,
                                          input$min.lon,
                                          input$max.lon),
                                age.min = NULL,
                                age.max = NULL,
                                pub.info = NULL,
                                country = NULL,
                                continent = NULL,
                                ocean = FALSE,
                                seasonality = NULL,
                                season.not = NULL,
                                interp.vars = NULL,
                                interp.details = NULL,
                                compilation = NULL,
                                verbose = FALSE,
                                skip.update = FALSE
                  )), n=input$obs)
  })

}

# Define UI for dataset viewer app ----
ui <- fluidPage(

  # App title ----
  titlePanel("Reactivity"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      # Input: Text for providing a caption ----
      # Note: Changes made to the caption in the textInput control
      # are updated in the output area immediately as you type
      textInput(inputId = "variable.name",
                label = "variable.name:",
                value = NULL),

      textInput(inputId = "archiveType",
                label = "archiveType:",
                value = NULL),

      textInput(inputId = "paleo.proxy",
                label = "paleo.proxy:",
                value = NULL),

      textInput(inputId = "paleo.units",
                label = "paleo.units:",
                value = NULL),

      numericInput(inputId = "min.lat",
                   label = "min.lat:",
                   value = -90),

      numericInput(inputId = "max.lat",
                   label = "max.lat:",
                   value = 90),

      numericInput(inputId = "min.lon",
                   label = "min.lon:",
                   value = -180),

      numericInput(inputId = "max.lon",
                   label = "max.lon:",
                   value = 180),


      # Input: Numeric entry for number of obs to view ----
      numericInput(inputId = "obs",
                   label = "Number of observations to view:",
                   value = 10)

    ),

    # Main panel for displaying outputs ----
    mainPanel(

      verbatimTextOutput("summary2"),


    )
  )
)

shinyApp(ui, server)
