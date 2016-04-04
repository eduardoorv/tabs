options(shiny.maxRequestSize = 9*1024^2)

function(input, output, session){
  
  clean_file <- function(lines_char){
    
    validated_lines <- grep ("\\s+(\\d+)\\s+(\\d+)\\s+([^=]*=\\d*\\.*\\d*|[^_]+_[^\\s]*)\\s+([^\\s]+)\\s+([^\\s]+)\\s+([^\\s]+)\\s+([^\\s]+)\\s+([^\\s]+)\\s+([^\\s]+)\\s*$",
                             lines_char,
                             perl = TRUE)  
    
    
    clean_file <- gsub("\\s+(\\d+)\\s+(\\d+)\\s+([^=]*=\\d*\\.*\\d*|[^_]+_[^\\s]*)\\s+([^\\s]+)\\s+([^\\s]+)\\s+([^\\s]+)\\s+([^\\s]+)\\s+([^\\s]+)\\s+([^\\s]+)\\s*$",
                       "\\1, \\3, \\4, \\5, \\6, \\7, \\8, \\9",
                       x = lines_char[validated_lines],
                       perl = TRUE)
    
  }
  
  data_frame <- function(clean_data){
    
    val_matrix <- array(dim = c(length(clean_data), 8))
    
    for(i in 1:length(clean_data)){
      
      val_matrix[i,] <- unlist(strsplit(x = clean_data[i], split = ","))
      
    }
    
    data_frame_char <- data.frame(val_matrix, stringsAsFactors = FALSE)
    
    names(data_frame_char) <- c("Temporalidad", "Escenario", "Frecuencia", "EP", "VarP", "a", "b", "EXP")
    
    for(i in c("Temporalidad", "Frecuencia", "EP", "VarP", "a", "b", "EXP")){
      
      data_frame_char[,i] <- as.numeric(data_frame_char[,i])
      
    }
    
    data_frame <- data_frame_char
    
  }
  
  nu <- function(df){
    
    a <- min(df$EXP)
    b <- max(df$EXP)
    p <- seq(a, b, length.out = 50)
    
    k <- length(p)
    r <- rep(0,k)
    for(i in 1:k){
      r[i] = sum((1 - pbeta(p[i]/df$EXP, df$a,df$b ))*df$Frecuencia)
    }
    
    expo <- p/b
    
    prob_exc <- 1 - exp(-r)
    
    per_ret <- 1/r
    
    prob_acum <- 1 - prob_exc
    
    dat_fr <- data.frame(p, expo, r, prob_exc, per_ret, prob_acum)
    
    names(dat_fr) <- c("perdida", "exposicion", "output", "prob_excedencia", "periodo_retorno", "prob_acumulada")
    
    return(dat_fr)
  }
    
  data <- reactive({
      
    if(is.null(input$archivo))  return(NULL)
      
    else{
        
      conn <- file(input$archivo$datapath, "r")
      y <- clean_file(readLines(conn, n = -1))
      close(conn)
      dat <- data_frame(y)
      #switch (input$select, "sismo" =dat[dat$EXP == 1,], "hidro" = dat[dat$EXP != 1,], "total" = dat)
      if (input$select == "sismo") {
        dat[dat$Temporalidad == 1,]
      }else{ 
        if(input$select == "hidro"){
          dat[dat$Temporalidad != 1,]
      } else dat
      }
    }
  })
    
  output$tail <- renderTable({
    tail(data())
  })
  
  output$hist <- renderTable({
    
    #switch (input$select, "sismo" = nu(data()[data()$EXP == 1,]), "hidro" = nu(data()[data()$EXP != 1,]), "total" = nu(data()))
    nu(data())
    
  })
  
  output$downloadData <- downloadHandler(
    
    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste("Datos", input$filetype, sep = ".")
    },
    
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      sep <- switch(input$filetype, "csv" = ",", "xls" = "\t")
      
      # Write to a file specified by the 'file' argument
      write.table(nu(data()), file, sep = sep,
                  row.names = FALSE)
    }
  )
  
  plotInput <- reactive({
    
    data_table <- nu(data())
    #plot(data_table[["perdida"]], data_table[[input$select2]])#, xlab = "Pérdida", ylab = input$select2)
    p <- ggplot(data_table, aes_string(names(data_table)[1], input$select2)) + geom_line()
    
  })
  
  output$plot <- renderPlot({
    
    data_table <- nu(data())
    #plot(data_table[["perdida"]], data_table[[input$select2]])#, xlab = "Pérdida", ylab = input$select2)
     ggplot(data_table, aes_string(names(data_table)[1], input$select2)) + geom_line()
  
     })
  
  output$downloadPlot <- downloadHandler(
    filename = function() { paste(input$select2, '.', input$imagetype, sep='') },
    content = function(file) {
      ggsave(file,plotInput())
    }
  )
  
}



