
#' Create renderer.js file
#'
#' @param path path of where to write renderer.js
#'
#' @return nothing, writes renderer.js to path provided and provides feedback if succcessful or not
#' @export
#'
create_renderer_js <- function(path){

  file <-
    '// This file is required by the index.html file and will
  // be executed in the renderer process for that window.
  // All of the Node.js APIs are available in this process.
  '
  electricShine::write_text(text = file,
                            filename = "renderer.js",
                            path = path)

}
