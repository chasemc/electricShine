#' Install Node.js
#'
#' @param nodeUrl path to node.js.org
#' @param installTo where node.js will be installed to
#' @param force should node.js be installed if it's already present?
#' @param nodeVersion version of node.js (eg "v10.15.1")
#'
#' @return list of 2: "nodePath": path to node.exe; "npmPath": path to npm-cli.js
#' @export
#'
getNodejs <- function(nodeUrl = "https://nodejs.org/dist",
                      installTo = file.path(system.file(package = "electricShine"), "nodejs"),
                      force = FALSE,
                      nodeVersion = "v10.15.1"){


  if (!file.exists(installTo)) {
    dir.create(installTo)
  }
  # Check if node and npm are already installed
  findNode <- list.files(installTo,
                         recursive = TRUE,
                         full.names = TRUE,
                         pattern = "node.exe")

  findNPM <- list.files(installTo,
                        recursive = TRUE,
                        full.names = TRUE,
                        pattern = "npm-cli.js")


  if (length(findNode) == 0 || length(findNPM) == 0 || force == TRUE) {

    # Get operating system:
    os <- get_os()

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
    } else (stop("Unfortunately this build machine is unsupported"))

    # Put together binary name and url
    binary_name <- glue::glue("node-{nodeVersion}-{platform}-{arch}.{ext}")
    nodeUrl <- file.path(nodeUrl, nodeVersion, binary_name)

    # Download to temporary directory
    temp <- base::file.path(tempdir(), base::basename(nodeUrl))
    utils::download.file(nodeUrl,
                         destfile = temp,
                         mode = 'wb')

    # Download sha file and parse
    online_sha <- glue::glue("https://nodejs.org/dist/{nodeVersion}/SHASUMS256.txt")
    online_sha <- utils::read.delim(online_sha, sep = "")

    online_sha <- as.character(online_sha[grepl(binary_name, online_sha[,2]), 1])

    local_sha <- as.character(openssl::sha256(file(temp)))
    class(local_sha) <- "character"

    if (!identical(online_sha, local_sha)) {
      stop("Downloaded sha didn't match online sha")
    }
    message("Downloaded sha matches expected sha")
    message("Decompressing node.js files, might take a few minutes...")
    message(glue::glue("All node.js files will be installed into: \n {installTo}"))

    if (base::grepl("zip$", base::basename(nodeUrl))) {
      utils::unzip(zipfile = temp,
                   exdir = installTo)
    }
    if (base::grepl("gz$", base::basename(nodeUrl))) {
      utils::untar(tarfile = temp,
                   exdir = installTo)
    }


    findNode <- list.files(installTo,
                           recursive = TRUE,
                           full.names = TRUE,
                           pattern = "node.exe")

    findNPM <- list.files(installTo,
                          recursive = TRUE,
                          full.names = TRUE,
                          pattern = "npm-cli.js")

  }

  return(list(nodePath = findNode,
              npmPath = findNPM))
}


#' Download Electron
#'
#' @param nodePath path to node.exe
#' @param npmPath path to npm-cli.js
#' @param installTo path of nodejs folder
#'
#' @return nothing
#' @export
#'
getElectron <- function(nodePath = NULL,
                        npmPath = NULL,
                        installTo = file.path(system.file(package = "electricShine"), "nodejs")){

  if (is.null(nodePath) || is.null(npmPath)) {

    findNode <- list.files(installTo,
                           recursive = TRUE,
                           full.names = TRUE,
                           pattern = "node.exe")

    findNPM <- list.files(installTo,
                          recursive = TRUE,
                          full.names = TRUE,
                          pattern = "npm-cli.js")
    if (is.null(nodePath) || is.null(npmPath)) {

      stop("Try running electricShine::getNodejs(ffocre = TRUE)")

    }

  }


  nodePath <- shQuote(nodePath)
  npmPath <- shQuote(npmPath)
  message("Downloading Electron packager...")
  # Use npm to get electron packager
  message(system(glue::glue("{nodePath} {npmPath} install electron-packager -g"),
                 intern = FALSE,
                 invisible = FALSE))

}
