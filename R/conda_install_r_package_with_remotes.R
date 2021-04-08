#' Currently broken, installs to local r need to fix env-vars like in previous release
#'
#' @inheritParams conda_params
#' @param repo_location {remotes} package function, one of c("github", "gitlab", "bitbucket", "local")
#' @param repo e.g. if repo_location is github: "chasemc/demoApp" ; if repo_location is local: "C:/Users/chase/demoApp"
#' @param dependencies_repo cran-like repo to install R package dependencies from
#' @param package_install_opts optional arguments passed to remotes::install_github, install_gitlab, install_bitbucket, or install_local
#'
#' @return
#' @export
#'
install_remote_package <- function(conda_top_dir,
                                        conda_env = "eshine",
                                        repo_location = "github",
                                        repo = "chasemc/demoapp",
                                        dependencies_repo = "https://cran.r-project.org",
                                        package_install_opts = NULL){

  accepted_sites <- c("github", "gitlab", "bitbucket", "local")

  if (length(repo_location) != 1L) {
    stop("install_user_app(repo_location) must be character vector of length 1")
  }

  if (!repo_location %in% accepted_sites) {
    stop(paste0("install_user_app(repo_location) must be one of:\n", accepted_sites))
  }

  if (!nchar(repo) > 0) {
    # TODO: Maybe make this a regex?
    stop("install_user_app(repo) must be character with > 0 characters")
  }

  if (!is.null(package_install_opts)) {
    if (!is.list(package_install_opts)) {
      stop("package_install_opts  must be a list of arguments.")
    }
  }

  repo <- as.list(repo)

  passthr <- c(repo, repos = dependencies_repo,
               c(package_install_opts,
                 list(force = TRUE)
               ))

  remotes_code <- paste0("install_", repo_location)
  remotes_code <- getFromNamespace(remotes_code,
                                   ns = "remotes")
  remotes_function_file <- tempfile()
  remotes_function_file <- normalizePath(remotes_function_file, winslash = "/", mustWork = FALSE)

  saveRDS(object = list("remotes_code" = remotes_code,
                        "passthr" = passthr),
          file = remotes_function_file)

  script <- .construct_remotes_docall(remotes_function_file = remotes_function_file)
  script <- .construct_remotes_rscript(script = script)
  script <- .construct_remotes_conda_call(script = script,
                                          conda_top_dir = conda_top_dir,
                                          conda_env = conda_env)
  system(script)

  }


  .construct_remotes_docall <- function(remotes_function_file){
    script <- paste0("do.call(readRDS(",
                     "'",
                     remotes_function_file,
                     "'",
                     ")\\$remotes_code, readRDS(",
                     "'",
                     remotes_function_file,
                     "'",
                     ")\\$passthr)")
    return(script)
  }

  .construct_remotes_rscript <- function(script){
    script <- paste0("Rscript -e ",
                     "\"",
                     script,
                     "\"")
    return(script)

  }

  .construct_remotes_conda_call <- function(script, conda_top_dir, conda_env){

    script <- paste0("source ",
                     shQuote(
                       file.path(conda_top_dir,
                                 "bin",
                                 "activate")
                     ),
                     " ",
                     shQuote(
                       file.path(conda_top_dir,
                                 "envs",
                                 conda_env)
                     ),
                     " && ",
                     script,
                     " && ",
                     shQuote(
                       file.path(conda_top_dir,
                                 "bin",
                                 "deactivate")
                     )
    )
    return(script)

  }


