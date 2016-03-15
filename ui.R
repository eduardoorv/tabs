shinyUI(
  navbarPage("App Title",
             tabPanel("DATOS", fileInput("archivo", "Archivo", multiple = FALSE), 
                      verbatimTextOutput("summary")),
             tabPanel("ESTADISTICA", plotOutput("hist")),
             tabPanel("GRAFICAS", plotOutput("plot"))
))
