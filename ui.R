shinyUI(
  navbarPage("App Title",
             tabPanel("DATOS", fileInput("archivo", "Archivo", multiple = FALSE),
                      selectInput("select", label = h3("Select box"), choices = list("hidro", "sismo", "total"), selected = "hidro"),
                      verbatimTextOutput("tail")),
             tabPanel("ESTADISTICA", tableOutput("hist")),
             tabPanel("GRAFICAS", plotOutput("plot"),  
                      selectInput("select2", label = h3("Select box"), 
                                  choices = list("perdida", "exposicion", "output", "prob excedencia", "periodo de retorno", "prob acumulada"), 
                                  selected = "Pérdida")
), theme = "Flatly.css"
))
