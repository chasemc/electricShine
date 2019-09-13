#' run_app
#'
#' @param port The TCP port that the application should listen on
#' if NULL, a random one is assigned
#'
#' @return NA
#' @export
#'

run_app <- function(port = NULL) {
  
  if (is.null(port)) {
    shiny::shinyApp(ui = demoApp::app_ui(),
                    server = demoApp::app_server)
  } else {
    port <- try(as.integer(port))
    if (is.integer(port) && port > 0L) {
      shiny::shinyApp(ui = demoApp::app_ui(),
                      server = demoApp::app_server,
                      options = list(port = port))
    }
  }
  
}
  
  