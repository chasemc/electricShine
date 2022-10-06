#' Install Node.js
#'
#' @param node_url path to node.js.org
#' @param nodejs_path parent folder of node.exe (~nodejs_path/node.exe)
#' @param nodejs_version version of node.js (eg "v10.16.0")
#' @param force_install try and install even if nodejs exists  (TRUE/FALSE)
#' @param permission_to_install whether to skip .prompt_install_nodejs()
#'
#' @return installed or checked nodejs_path
#' @export
#'
install_nodejs <- function(node_url = "https://nodejs.org/dist",
                           nodejs_path = file.path(system.file(package = "electricShine"), "nodejs"),
                           force_install = FALSE,
                           nodejs_version = "v15.5.0",
                           permission_to_install  = FALSE){

  nodejs_version <- .check_node_version_format(nodejs_version)

  # Get operating system:
  os <- electricShine::get_os()
  
  if (identical(os, "win")) {
    platform <- "win"
    ext <- "zip"
  } else if (identical(os, "mac")) {
    platform <- "darwin"
    ext <- "tar.gz"
  } else if (identical(os, "unix")) {
    platform <- "linux"
    ext <- "tar.xz"
  }
  
  
  if (base::version$arch[[1]] == "x86_64") {
    arch <- "x64"
  } else {
    #TODO: I think this has been fixed and isn't true. But double-check
    stop("Unfortunately this build machine is unsupported")
  }
  
  # Check if node and npm are already installed
  # warning no needed if not exist
  nodejs_path <-  suppressWarnings({normalizePath(nodejs_path, winslash = "/")})

  subfolder <- file.path(nodejs_path,
                         glue::glue("node-{nodejs_version}-{platform}-{arch}"),
                         fsep = "/")
  # check within given folder first
  if (dir.exists(subfolder)) {
    nodejs_path <- subfolder
    node_exists <- .check_node_works(node_top_dir = nodejs_path,
                                     expected_version = nodejs_version)
  } else {
    node_exists <- .check_node_works(node_top_dir = nodejs_path,
                                     expected_version = nodejs_version)
  }

  npm_exists <- .check_npm_works(node_top_dir = nodejs_path)


  if (!base::isFALSE(node_exists) && !base::isFALSE(npm_exists)) {

    message("Skipping install_nodejs(), nodejs alreagy installed.")

  } else {

    if (permission_to_install == FALSE) {

      permission_to_install <- .prompt_install_nodejs(nodejs_path)

    }

    if (permission_to_install == FALSE) {
      message("nodejs is required for electricShine to work. Please point nodejs_path
              to a valid nodejs path or select 'yes' when prompted to install")
    } else {

      # Put together binary name and url
      binary_name <- glue::glue("node-{nodejs_version}-{platform}-{arch}.{ext}")
      node_url <- file.path(node_url,
                            nodejs_version,
                            binary_name)

      # Download to temporary directory
      temp <- base::file.path(tempdir(),
                              base::basename(node_url))

      utils::download.file(node_url,
                           destfile = temp,
                           mode = 'wb')

      # Download sha file and parse
      online_sha <- glue::glue("https://nodejs.org/dist/{nodejs_version}/SHASUMS256.txt")
      online_sha <- utils::read.delim(online_sha, sep = "", header = FALSE)
      online_sha <- as.character(online_sha[grepl(binary_name, online_sha[,2]), 1])
      # Calculate SHA of downloaded nodejs
      local_sha <- as.character(openssl::sha256(file(temp, raw = TRUE)))
      # as.character() leaves class as  "hash"   "sha256"
      # change to character
      class(local_sha) <- "character"

      if (!identical(online_sha, local_sha)) {
        stop("Downloaded SHA didn't match online sha")
      }
      message("Downloaded SHA matches expected sha")
      message(glue::glue("All node.js files will be installed into: \n {nodejs_path}"))
      message("Decompressing node.js files, might take a few minutes...")

      if (base::grepl("zip$", base::basename(node_url))) {
        base::try(
          utils::unzip(zipfile = temp,
                       exdir = nodejs_path)
        )
      }
      if (base::grepl("gz$", base::basename(node_url))) {
        base::try(
          utils::untar(tarfile = temp,
                       exdir = nodejs_path)
        )
      }


      if (identical(os, "win")) {
        nodejs_path <- file.path(nodejs_path,
                                 tools::file_path_sans_ext(basename(temp),
                                                           compression = TRUE))
      } else if (identical(os, "mac")) {
        nodejs_path <- file.path(nodejs_path,
                                 tools::file_path_sans_ext(basename(temp),
                                                           compression = TRUE),
                                 "bin")
      } else if (identical(os, "unix")) {
        platform <- "linux"
        ext <- "tar.xz"
      }


      node_exists <- .check_node_works(node_top_dir = nodejs_path,
                                       expected_version = nodejs_version)

      npm_exists <- .check_npm_works(node_top_dir = nodejs_path)

      if (base::isFALSE(node_exists) || base::isFALSE(npm_exists)) {

        stop("Was unable to successfully install nodejs/npm executable.")

      }

    }
  }

  nodejs_path <- normalizePath(nodejs_path,
                               winslash = "/",
                               mustWork = TRUE)
  return(nodejs_path)
}

