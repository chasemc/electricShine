

#' Change fixed paths to make R portable on Mac
#'
#' @param r_executable_path path to ~bin/R
#'
#' @return NA, modifies file
modify_mac_r <- function(r_executable_path){

con <- file(r_executable_path, "rt")
b <- readLines(con, n=-1, warn = F)
close(con)

grepped <- grepl("usage=", b)
grepped <- which(grepped)

z <- 
'
#!/bin/sh
# Shell wrapper for R executable.

#R_HOME_DIR=/Library/Frameworks/R.framework/Resources
path=$(pwd)
last_dir="${path##*/}"  # sets last_dir to to (equivalent of basename)
echo ${path}


if [ "${last_dir}" = "bin" ]; then 
  R_HOME_DIR=$(dirname $(pwd))
else
  R_HOME_DIR=${path}
fi

if [ "${NODE_R_HOME}" != "" ]; then
  R_HOME_DIR=${NODE_R_HOME}
fi

echo "*** R_HOME_DIR ***"
echo ${R_HOME_DIR}

if test "${R_HOME_DIR}" = "/Library/Frameworks/lib/R"; then
   case "darwin15.6.0" in
   linux*)
     run_arch=`uname -m`
     case "$run_arch" in
        x86_64|mips64|ppc64|powerpc64|sparc64|s390x)
          libnn=lib64
          libnn_fallback=lib
        ;;
        *)
          libnn=lib
          libnn_fallback=lib64
        ;;
     esac
     if [ -x "/Library/Frameworks/${libnn}/R/bin/exec/R" ]; then
        R_HOME_DIR="/Library/Frameworks/${libnn}/R"
     elif [ -x "/Library/Frameworks/${libnn_fallback}/R/bin/exec/R" ]; then
        R_HOME_DIR="/Library/Frameworks/${libnn_fallback}/R"
     ## else -- leave alone (might be a sub-arch)
     fi
     ;;
  esac
fi

if test -n "${R_HOME}" && \
   test "${R_HOME}" != "${R_HOME_DIR}"; then
  echo "WARNING: ignoring environment value of R_HOME"
fi
R_HOME="${R_HOME_DIR}"
export R_HOME
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
: ${R_ARCH=}
'

combined <- c(z, b[grepped:length(b)] )

writeLines(combined, r_executable_path)
}
