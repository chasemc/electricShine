

#' Change fixed paths to make R portable on Mac
#'
#' @param r_executable_path path to ~bin/R
#'
#' @return NA, modifies file
#' @export
modify_mac_r <- function(r_executable_path){

con <- file(r_executable_path,
            "rt")
executable_contents <- readLines(con, 
                                 n=-1, 
                                 warn = F)
close(con)

grepped <- grepl("usage=", executable_contents)
grepped <- which(grepped)

modifications <- 
'
#!/bin/sh
# Shell wrapper for R executable.

#R_HOME_DIR=/Library/Frameworks/R.framework/Resources

export R_HOME_DIR="${NODE_R_HOME}"
export R_HOME="${R_HOME_DIR}"

echo "*** R_HOME_DIR ***"
echo ${NODE_R_HOME}
echo ${R_HOME_DIR}

#R_SHARE_DIR=/Library/Frameworks/R.framework/Resources/share
export R_SHARE_DIR
#R_INCLUDE_DIR=/Library/Frameworks/R.framework/Resources/include

export R_INCLUDE_DIR
#R_DOC_DIR=/Library/Frameworks/R.framework/Resources/doc
R_DOC_DIR=${R_HOME_DIR}/doc
export R_DOC_DIR

# Since this script can be called recursively, we allow R_ARCH to
# be overridden from the environment.
# This script is shared by parallel installs, so nothing in it should
# depend on the sub-architecture except the default here.
: ${R_ARCH=""}
'

combined <- c(modifications,
              executable_contents[grepped:length(executable_contents)])

writeLines(combined,
           r_executable_path)
}
