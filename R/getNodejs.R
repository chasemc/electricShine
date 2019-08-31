#' Install Node.js
#'
#' @param node_url path to node.js.org
#' @param nodejs_path where node.js will be installed to
#' @param node_url should node.js be installed if it's already present?
#' @param node_version version of node.js (eg "v10.15.1")
#'
#' @return list of 2: "nodePath": path to node.exe; "npmPath": path to npm-cli.js
#' @export
#'
get_nodejs <- function(node_url = "https://nodejs.org/dist",
                       nodejs_path = file.path(system.file(package = "electricShine"), "nodejs"),
                       force_install = FALSE,
                       node_version = "v10.16.0"){
  
  
  if (!file.exists(nodejs_path)) {
    dir.create(nodejs_path)
  }
  # Check if node and npm are already installed
  
  
  os <- electricShine::get_os()
  
  temp <- electricShine::find_nodejs()
  node_path <- temp$node_path
  npm_path <- temp$npm_path
  
  
  
  
  if (length(node_path) == 0 || length(npm_path) == 0 || node_url == TRUE) {
    
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
    node_url <- file.path(node_url,
                         node_version,
                         binary_name)
    
    # Download to temporary directory
    temp <- base::file.path(tempdir(), 
                            base::basename(node_url))
    
    utils::download.file(node_url,
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
    message(glue::glue("All node.js files will be installed into: \n {nodejs_path}"))
    
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
    
    
    temp <- electricShine::find_nodejs()
    
    
  }
  
  return(list(nodePath = temp$node_path,
              npmPath = temp$npm_path))
}

