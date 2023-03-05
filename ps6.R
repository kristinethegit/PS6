library(shiny)
library(tidyverse)
#testing
ui <- fluidPage(
  
  titlePanel("PS6"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
      sliderInput("n", "How many diamonds:",
                  min = 10,
                  max = 1000,
                  value = 200),
      radioButtons("color", "Choose color",
                   choices = c("skyblue", "lawngreen", "orangered",
                                        "purple", "gold"))
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotOutput("plot"), 
                 tabPanelBody("panel2", "Panel 2 content")),
        tabPanel("Table", tableOutput("table"), 
                 tabPanelBody("panel3", "Panel 3 content")),
        tabPanel("About", plotOutput("about"), 
                 tabPanelBody("panel1", "Panel 1 content"))
      )
    )
  )
)

server <- function(input, output) {
  
  output$plot <- renderPlot({
    diamonds %>% 
      sample_n(input$n) %>% 
      ggplot(aes(x = carat, fill = color)) +
      geom_histogram(binwidth = 0.1) +
      scale_fill_manual(values = input$color)
  })
  output$about <- renderPlot({
    plot(cars)
  })
  output$table <- renderTable({
    iris %>% 
      slice(1:input$n)
  })
  
}

shinyApp(ui = ui, server = server)

