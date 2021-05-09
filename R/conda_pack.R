#' Install conda-pack
#'
#' @inheritParams conda_params
#'
#' @return
#' @export
#'
conda_install_pack <- function(conda_top_dir,
                               conda_env = NULL,
                               conda_repo = "conda-forge"){

  conda_install(conda_top_dir,
                conda_env = conda_env,
                conda_repo = conda_repo,
                conda_package = "conda-pack")
}


#' Package a conda environment with conda-pack
#'
#' @inheritParams conda_params
#'
#' @param outdir directory path where conda-pack 'tar.gz' should be written to
#'
#' @return
#' @export
#'
conda_pack <- function(conda_top_dir,
                       conda_env="eshine",
                       conda_pack_env="conda-pack",
                       outdir){


  env_path <- file.path(conda_top_dir,
                        "envs",
                        conda_env)

  outpath <- file.path(outdir,
                       paste0(conda_env, ".tar.gz"))


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
                               conda_pack_env)
                   ),
                   " && ",
                   paste0("conda-pack",
                     paste0(" -p ", env_path),
                     paste0(" -o ", outpath),
                     paste0(" --dest-prefix ", "pub_conda")

                   )
  )

    system(
            script)
}
