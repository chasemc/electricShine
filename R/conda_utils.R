
find_conda_program <- function(conda_top_dir){

  conda_path <- file.path(conda_top_dir,
                          "bin",
                          "conda")
  if (!file.exists(conda_path)) {
    stop("Couldn't find conda")
  }

  check_conda_version(conda_path)
  return(conda_path)
}


check_conda_version <- function(conda_path){
  if (!file.exists(conda_path)){
    stop(paste0("Couldn't find: ", conda_path))
  }
  res <- system2(conda_path, "-V", stdout = T)

  if (grepl("conda", res)){
    message(paste0("Using: ", res, "\n", conda_path))
  } else {
    stop("Something went wrong detecting conda")

  }
}
