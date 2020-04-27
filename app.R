library(shiny)
library(maps)
library(mapproj)

source("helpers.R")

#set up UI
ui <- fluidPage(

  #Label Title Page
  titlePanel("US Arrests"),

  #Setup Sidebar layout with Title and Inputs
  sidebarLayout(
    sidebarPanel(
      helpText("Visual of US Arrests"),

  #Create input for variables
      selectInput("var",
                  label = "Choose a variable to display",
                  choices = c("Murder Arrests (per 100,000)",
                              "Assault Arrests (per 100,000)",
                              "Rape Arrests (per 100,000)",
                              "Urban Population Percentage"),
                  selected = "Urban Population Percentage"),

  #Create slider for range input
      sliderInput("range",
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),

  #Create main panel with selected visual outputs
    mainPanel(
      plotOutput("map"),
      textOutput("selected_var"),
      textOutput("min_max")


    )
  )
)

#Develop server
server <- function(input, output) {

  #Create visual map output
  output$map <- renderPlot({
    data <- switch(input$var,
                   "Murder Arrests (per 100,000)" = USArrests$Murder,
                   "Assault Arrests (per 100,000)" = USArrests$Assault,
                   "Rape Arrests (per 100,000)" = USArrests$Rape,
                   "Urban Population Percentage" = USArrests$UrbanPop)

    color <- switch(input$var,
                    "Total Murder" = "red",
                    "Total Assault" = "blue",
                    "Total Rape" = "purple",
                    "Total Urban Population" = "green")

    legend <- switch(input$var,
                     "Total Murder" = "Total Murder",
                     "Total Assault" = "Total Assault",
                     "Total Rape" = "Total Rape",
                     "Total Urban Population" = "Total Urban Population")

    percent_map(data, color, legend, input$range[1], input$range[2])

  })

  #Create output for input selection text
  output$selected_var <- renderText({
    paste("You have selected", input$var)
  })

  #Create output for range selection text
  output$min_max <- renderText({
    paste("You have chosen a range that goes from",
          input$range[1], "to", input$range[2])
  })


}



shinyApp(ui, server)


