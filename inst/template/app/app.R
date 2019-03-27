library(shiny)
.libPaths(file.path(R.home(), "library"))
shinyApp(ui = IDBacApp::app_ui(),
server = IDBacApp::app_server
)
