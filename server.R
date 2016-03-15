function(input, output, session){
  
  data <- reactive({
    if(is.null(input$archivo)) return(NULL)
    else
      read.csv(input$archivo$datapath, sep = ",", header = TRUE)
  })
  
  output$summary <- renderPrint({
    summary(data())
  })
  
  output$hist <- renderPlot({
    hist(data()[,1])
  })
  
  output$plot <- renderPlot({
    plot(data())
  })
  
}
