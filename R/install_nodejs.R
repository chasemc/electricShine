#' Install Node.js
#'
#' @param node_url path to node.js.org
#' @param nodejs_path parent folder of node.exe (~nodejs_path/node.exe)
#' @param nodejs_version version of node.js (eg "v10.16.0")
#'
#' @return installed or checked nodejs_path
#' @export
#'
get_nodejs <- function(node_url = "https://nodejs.org/dist",
                       nodejs_path = file.path(system.file(package = "electricShine"), "nodejs"),
                       force_install = FALSE,
                       nodejs_version = "v10.16.0"){
  
  if (!grepl("v", nodejs_version)) {
    # Node version format is "v10.16.0", not "10.16.0"
    # add "v" if needed
    nodejs_version <- paste0("v",
                             nodejs_version)
  }
  
  
  if (!file.exists(nodejs_path)) {
    dir.create(nodejs_path)
  }
  
  
  node_exists <- .check_node_works(node_top_dir = nodejs_path,
                                   expected_version = nodejs_version)
  
  npm_exists <- .check_npm_works(node_top_dir = nodejs_path)
  
  # Check if node and npm are already installed
  
  if(!node_exists || !npm_exists){
    
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
      stop("Unfortunately this build machine is unsupported")
    }
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
    
    
    nodejs_path <- file.path(nodejs_path,
                             tools::file_path_sans_ext(basename(temp)))
    
    node_exists <- .check_node_works(node_top_dir = nodejs_path,
                                     expected_version = nodejs_version)
    
    npm_exists <- .check_npm_works(node_top_dir = nodejs_path)
    
    if (!node_exists || !npm_exists) {
      
      stop("Was unable to successfully install nodejs/npm executable.")
      
    }
    
    
  }
  
  return(nodejs_path)
}

