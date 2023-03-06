library(shiny)
library(tidyverse)

uah <- read_csv("UAH-lower-troposphere-long.csv")
uah_subset <- reactive({
  uah %>% sample_n(input$uah)
})

##UI
ui <- fluidPage(
  
  titlePanel("PS6"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("uah", "UAH",
                  min = 1,
                  max = 14500,
                  value = 4000),
      radioButtons("x_axis", "Select variable for x-axis:", 
                   choices = c("Year", "Month", "Day"))
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("About",
                 p("It allows users to explore the UAH lower troposphere dataset with different parameters."),
                 tabPanelBody("panel1", "")),
        tabPanel("Plot", 
                 p("This is a plot showing the relationship between year and temperature."),
                 plotOutput("plot"), 
                 tabPanelBody("panel2", "")),
        tabPanel("Table", 
                 tableOutput("table"), 
                 tabPanelBody("panel3", "This table shows the UAH dataset."))
      )
    )
  )
)

server <- function(input, output) {
  output$plot <- renderPlot({
    uah <- input$uah
    x <- rnorm(uah)
    y <- rnorm(uah)
    plot(x, y, col="darkgreen", pch=19, xlab = "year", ylab = "temperature")
  })
  output$table <- renderTable({
    uah %>% 
      slice(1:input$uah) %>% 
      group_by(nrow("year"))
  })
}

shinyApp(ui = ui, server = server)
