library(shiny)
library(tidyverse)

uah <- read_csv("UAH-lower-troposphere-long.csv")

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
                 p(HTML("<strong>It allows users to explore the UAH lower troposphere dataset with different parameters.</strong>")),
                 tabPanelBody("panel1", "This site under the tab 'Plot' shows a scatterplot on the temperatures, throughout the years. Under the 'Table' tab, the full dataset of the UAH lower troposphere.")),
        tabPanel("Plot", 
                 p("This is a plot showing the relationship between year and temperature."),
                 plotOutput("plot"), 
                 tabPanelBody("panel2", "")),
        tabPanel("Table", 
                 tableOutput("table"), 
                 verbatimTextOutput("obs_count"),
                 tabPanelBody("panel3", HTML("<em>End of dataset</em>")))
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
  output$obs_count <- renderPrint({
    var <- switch(input$x_axis, 
                  "Year" = "year", 
                  "Month" = "month", 
                  "Day" = "day")
    count <- nrow(uah %>% slice(1:input$uah) %>% filter(!is.na(!!sym(var))))
    paste("Number of non-missing observations for", input$x_axis, ":", count)
  })
}

shinyApp(ui = ui, server = server)

