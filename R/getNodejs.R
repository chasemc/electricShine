#' Install Node.js
#'
#' @param nodeUrl path to node.js.org
#' @param electricShine_nodejs where node.js will be installed to
#' @param force should node.js be installed if it's already present?
#' @param node_version version of node.js (eg "v10.15.1")
#'
#' @return list of 2: "nodePath": path to node.exe; "npmPath": path to npm-cli.js
#' @export
#'
get_nodejs <- function(nodeUrl = "https://nodejs.org/dist",
                       electricShine_nodejs = file.path(system.file(package = "electricShine"), "nodejs"),
                       force = FALSE,
                       node_version = "v10.16.0"){
  
  
  if (!file.exists(electricShine_nodejs)) {
    dir.create(electricShine_nodejs)
  }
  # Check if node and npm are already installed
  
  
  os <- electricShine::get_os()
  
  temp <- electricShine::find_nodejs()
  node_path <- temp$node_path
  npm_path <- temp$npm_path
  
  
  
  
  if (length(node_path) == 0 || length(npm_path) == 0 || force == TRUE) {
    
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
    } else {
      stop("Unfortunately this build machine is unsupported")
    }
    # Put together binary name and url
    binary_name <- glue::glue("node-{node_version}-{platform}-{arch}.{ext}")
    nodeUrl <- file.path(nodeUrl,
                         node_version,
                         binary_name)
    
    # Download to temporary directory
    temp <- base::file.path(tempdir(), 
                            base::basename(nodeUrl))
    
    utils::download.file(nodeUrl,
                         destfile = temp,
                         mode = 'wb')
    
    # Download sha file and parse
    online_sha <- glue::glue("https://nodejs.org/dist/{node_version}/SHASUMS256.txt")
    
    
    
    online_sha <- utils::read.delim(online_sha, sep = "", header = FALSE)
    
    online_sha <- as.character(online_sha[grepl(binary_name, online_sha[,2]), 1])
    
    local_sha <- as.character(openssl::sha256(file(temp, raw = TRUE)))
    class(local_sha) <- "character"
    
    if (!identical(online_sha, local_sha)) {
      stop("Downloaded sha didn't match online sha")
    }
    message("Downloaded sha matches expected sha")
    message("Decompressing node.js files, might take a few minutes...")
    message(glue::glue("All node.js files will be installed into: \n {electricShine_nodejs}"))
    
    if (base::grepl("zip$", base::basename(nodeUrl))) {
      base::try(
        utils::unzip(zipfile = temp,
                     exdir = electricShine_nodejs)
      )
    }
    if (base::grepl("gz$", base::basename(nodeUrl))) {
      base::try(
        utils::untar(tarfile = temp,
                     exdir = electricShine_nodejs)
      )
    }
    
    
    temp <- electricShine::find_nodejs()
    
    
  }
  
  return(list(nodePath = temp$node_path,
              npmPath = temp$npm_path))
}

