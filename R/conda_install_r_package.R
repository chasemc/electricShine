conda_install <- function(conda_path, conda_env="eshine", lib, repo=FALSE){
  if (!file.exists(conda_path)){
    stop(paste0("Couldn't find: ", conda_path))
  }
  if (repo) {
    system2(conda_path,
            c("install",
              paste0("-n ", conda_env),
              paste0("-c ", repo),
              lib,
              "-y"),
            stdout = "")
  } else {
    system2(conda_path,
            c("install",
              paste0("-n ", conda_env),
              lib,
              "-y"),
            stdout = "")
  }
}


install_r_packages <- function(package, repo="https://cran.r-project.org",miniconda_installation_path, env_name = "eshine"){

  script <- paste0("install.packages('",
                   package,
                   "',",
                   "repos='",
                   repo,
                   "')")


  script <-  paste0("Rscript -e ",
                    shQuote(script, type = "cmd"))



  script <- paste0("source ",
                   shQuote(
                     file.path(miniconda_installation_path,
                               "bin",
                               "activate")
                   ),
                   " ",
                   shQuote(
                     file.path(miniconda_installation_path,
                               "envs",
                               env_name)
                   ),
                   " && ",
                   script,
                   " && ",
                   shQuote(
                     file.path(miniconda_installation_path,
                               "bin",
                               "deactivate")
                   )
  )
  system(script)
}



install_r_remotes <- function(package, repo="https://cran.r-project.org", env_path){

  rscript_path <- file.path(env_path,
                            "bin",
                            "R")

  script <- paste0("install.packages('",
                   "remotes",
                   "',",
                   "repos='",
                   repo,
                   "')")

  script <-  paste0("-e ",
                    shQuote(script))
  system2(rscript_path,
          # env = c("CONDA_BUILD_SYSROOT"="$(xcrun --show-sdk-path)"),
          script)
}
