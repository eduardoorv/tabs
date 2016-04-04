shinyUI(
  navbarPage("App Title",
             tabPanel("DATOS", fileInput("archivo", "Archivo", multiple = FALSE),
                      selectInput("select", label = h3("Select box"), choices = list("hidro", "sismo", "total"), selected = "hidro"),
                      tableOutput("tail")),
             tabPanel("ESTADISTICA",  downloadButton('downloadData', 'Download'), 
                      radioButtons("filetype", "File type:",choices = c("csv", "xls")),
                      tableOutput("hist")),
             tabPanel("GRAFICAS", plotOutput("plot"),  
                      selectInput("select2", label = h3("Select box"), 
                                  choices = list("perdida", "exposicion", "output", "prob_excedencia", "periodo_retorno", "prob_acumulada"), 
                                  selected = "Pérdida"),
                      downloadButton('downloadPlot', 'Download Plot'), 
                      radioButtons("imagetype", "Image type:",choices = c("png", "jpeg", "pdf"))), 
             theme = "Flatly.css")
)
