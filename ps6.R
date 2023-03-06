library(shiny)
library(tidyverse)

uah <- read_csv("UAH-lower-troposphere-long.csv")
uah_subset <- reactive({
  uah %>% sample_n(input$uah)
})
ui <- fluidPage(
  
  titlePanel("PS6"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("uah", "UAH",
                  min = 10,
                  max = 1000,
                  value = 200),
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
        tabPanel("Table", tableOutput("table"), 
                 tabPanelBody("panel3", "Panel 3 content"))
      )
    )
  )
)

server <- function(input, output) {
  output$plot <- renderPlot({
    uah %>% 
      sample_n(input$uah) %>% 
      ggplot(aes(x = year, fill = temp)) +
      geom_histogram(binwidth = 0.1) +
      scale_fill_manual(values = input$color)
  })
  output$table <- renderTable({
    uah %>% 
      slice(1:input$uah)
  })
}

shinyApp(ui = ui, server = server)
