#' Meta-function
#'
#' @param path path to create installer
#' @param date date for MRAN
#' @param package github username/repo
#'
#' @return Nothing
#' @export
#'
electricShine <- function(path,
                          date = "2019-01-01",
                          package){


  electricShine::create_directory_template(path)

  path <- base::file.path(path,"electricShine")

  electricShine::installR(date = date,
                          path = path)

  electricShine::create_app_file(package = basename(package),
                                 path = path)
  electricShine::trim_r(file.path(path,"r_win"))

  electricShine::install_user_app(package = package,
                                  path = path,
                                  date = date)

}
