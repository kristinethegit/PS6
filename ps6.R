library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("PS6"),
  
  # Sidebar with a slider input for number of bins 
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
    
    # Show a plot of the generated distribution
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

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$plot <- renderPlot({
    diamonds %>% 
      sample_n(input$n) %>% 
      ggplot(aes(x = carat, fill = color)) +
      geom_histogram(binwidth = 0.1) +
      scale_fill_manual(values = input$color)
  })
  
  output$table <- renderTable({
    iris %>% 
      slice(1:input$n)
  })
  
  output$about <- renderPlot({
    plot(cars)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

