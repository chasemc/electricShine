#' main server of app
#'
#' @param input shiny input
#' @param output shiny output
#' @param session shiny session
#'
#' @return shiny server
#' @export
app_server <- function(input, output, session) {
  
  
  data <- new.env()
  temp <- system.file("data", package="datasets")
  lazyLoad(file.path(temp, "Rdata"), envir = data)
  remove(temp)
  princAll <- lapply(ls(data),
                     function(x){
                       
                       if (class(data[[x]]) == "data.frame" && ncol(data[[x]]) > 1) {
                         
                         zz <- try(stats::prcomp(data[[x]], scale = TRUE))
                         if (class(zz) == "try-error" ){
                           return(NULL)
                         } else {
                           return(zz)
                         }
                         
                       } else {
                         return(NULL)
                       }
                     })
  names(princAll) <- ls(data)
  
  selectedData <- reactive({
    princAll[[input$dataset]]
  })
  
  
  output$selector <- renderUI({
    selectInput("dataset", "Choose a state:",
                as.list(
                  names(which(!sapply(princAll, is.null))))
    )
  })
  
  output$plot1 <- renderPlot({
    stats::biplot(selectedData())
    
  })
  
  
}
