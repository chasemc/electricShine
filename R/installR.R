#' Install R from MRAN date into electricShine folder
#'
#' @param exe find exe name
#' @param path path to electricShine directory
#' @param date MRAN date from which to install R
#'
#' @return nothing
#' @export
#'

installR <- function(date,
                     exe = "R-[0-9.]+.+-win\\.exe",
                     path){

  gluey <- glue::glue("https://cran.microsoft.com/snapshot/{date}/bin/windows/base/")


  readCran <- base::readLines(gluey, warn = FALSE)
  filename <- stats::na.omit(stringr::str_extract(readCran, exe))[1]

  URL <- base::paste(gluey, filename, sep = '')

  tmp <- base::file.path(tempdir(), filename)
  utils::download.file(URL, tmp, mode = "wb")

  to_copy_into <- base::file.path(path, "r_win")

  base::dir.create(to_copy_into)

  to_copy_into <- base::shQuote(to_copy_into)
  base::system(glue::glue("{tmp} /VERYSILENT /DIR={to_copy_into}"))


}


