shinyUI(
  navbarPage("App Title",
             tabPanel("DATOS", fileInput("archivo", "Archivo", multiple = FALSE), 
                      verbatimTextOutput("tail")),
             tabPanel("ESTADISTICA", verbatimTextOutput("hist")),
             tabPanel("GRAFICAS", plotOutput("plot"))
))
