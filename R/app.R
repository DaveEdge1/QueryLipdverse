library(shiny)
#library(remotes)
library(tidyr)
#remotes::install_github("nickmckay/lipdR")
library(lipdR)
library(ggplot2)
theme_set(theme_bw())
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)




# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {

  #queryTable <- lipdR:::newQueryTable()

  #world <- ne_countries(scale = "medium", returnclass = "sf")
  world <- map_data("world")

  D<-reactive({
    queryLipdverse(variable.name = input$variable.name,
                   archive.type = input$archiveType,
                   paleo.proxy = input$paleo.proxy,
                   paleo.units = input$paleo.units,
                   coord = c(ymin(),
                             ymax(),
                             xmin(),
                             xmax()),
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
    )
  })

  # output$summaryHeaders <- reactive({
  #   c(names(D()))
  # })


  output$summary2 <- renderPrint({
    print(tibble(D()), n=input$obs)
  })

  output$summary3 <- renderPrint({
    print(class(D()))
  })

  # yMin <- reactive({
  #   min(D()$geo_latitude)
  # })
  # yMax <- reactive({
  #   max(D()$geo_latitude)
  # })
  # xMin <- reactive({
  #   min(D()$geo_longitude)
  # })
  # xMax <- reactive({
  #   max(D()$geo_longitude)
  # })

  # world <- reactive({
  #   world1[world1$lat > input$min.lat &
  #           world1$lat < input$max.lat &
  #           world1$long > input$min.lon &
  #           world1$long < input$max.lon,]
  # })

  #newColor <- observe(input$pointColor)

  output$plot2 <- renderPlot({
    ggplot(data=world, aes(x = long, y = lat, group = group)) +
      geom_polygon(color="black", fill="white") +
      # coord_map(
      #   projection = "mercator", #orientation = c(0, 90, 0),
      #   xlim = c(xmin(),xmax()),
      #   ylim = c(ymin(),ymax())
      #   )+
      coord_cartesian(        xlim = c(xmin(),xmax()),
                              ylim = c(ymin(),ymax()))+
      geom_point(data = D(), inherit.aes = FALSE,
                 mapping = aes(x=as.numeric(geo_longitude),
                               y=as.numeric(geo_latitude),
                               color=get(input$pointColor))) +
      # scale_y_continuous(limits = c(ymin(),ymax())) +
      # scale_x_continuous(limits = c(xmin(),xmax())) +
      xlab("") +
      ylab("") +
      theme(legend.title = element_blank())
  })

  #D()$geo_longitude



  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("newLIPD", ".zip", sep = "")
    },
    content = function(file) {
      writeLipd(readLipd(D()))
    }
  )

  x_range <- function(e) {
    if(is.null(e)) return(c(-180,180))
    c(round(e$xmin, 1), round(e$xmax, 1))
  }

  y_range <- function(e) {
    if(is.null(e)) return(c(-90,90))
    c(round(e$ymin, 1), round(e$ymax, 1))
  }

  #output$xmin <- reactive({x_range(input$plot_brush)[1]})

  xmin <- reactive({x_range(input$plot_brush)[1]})
  xmax <- reactive({x_range(input$plot_brush)[2]})

  #output$ymin <- reactive({y_range(input$plot_brush)[1]})

  ymin <- reactive({y_range(input$plot_brush)[1]})
  ymax <- reactive({y_range(input$plot_brush)[2]})



}

# Define UI for dataset viewer app ----
ui <- fluidPage(

  # App title ----
  titlePanel("LIPDverse Query"),

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


      # numericInput(inputId = "age.min",
      #              label = "age.min:",
      #              value = NULL),
      #
      # numericInput(inputId = "age.max",
      #              label = "age.max:",
      #              value = NULL),


      # Input: Numeric entry for number of obs to view ----
      numericInput(inputId = "obs",
                   label = "Number of observations to view:",
                   value = 10),

      # Button
      downloadButton("downloadData", "Download (must use app in browser)")

    ),

    # Main panel for displaying outputs ----
    mainPanel(

      plotOutput("plot2",
                 brush = "plot_brush"),

      selectInput("pointColor", "Select variable for coloring points",
                  choices =c(names(queryTable))),
      #c(verbatimTextOutput("summaryHeaders")),

      verbatimTextOutput("summary2"),

      verbatimTextOutput("summary3")


    )
  )
)

app <- shinyApp(ui = ui, server = server)
runApp(app, port = 3880, launch.browser = FALSE)
