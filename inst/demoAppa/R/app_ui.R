#' main app ui
#'
#' @return shiny ui
#' @export
#'
app_ui <- function(){
  fluidPage(
    h3('Datasets Principle Components Analysis'),
    p("Whether it's good to or not, takes 'data.frame' objects in `datasets` package
      and performs PCA with scaling."),
    sidebarPanel(
      uiOutput("selector")
    ),
    mainPanel(
      plotOutput('plot1')
    )
  )
}