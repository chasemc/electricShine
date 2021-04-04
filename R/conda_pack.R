conda_install_pack <- function(conda_top_dir,
                               conda_env = NULL,
                               conda_repo = "conda-forge"){

  conda_install(conda_top_dir,
                conda_env = conda_env,
                conda_repo = conda_repo,
                conda_lib = "conda-pack")
}


conda_pack <- function(conda_top_dir,
                       conda_env="eshine",
                       outdir){

  conda_path <- find_conda_program(conda_top_dir)

  env_path <- file.path(conda_top_dir,
                        "envs",
                        conda_env)

  outpath <- file.path(outdir,
                       paste0(conda_env, ".tar.gz"))

    system2(conda_path,
            c("pack",
              paste0("-p ", env_path),
              paste0("-o ", outpath)
              ),
            stdout = "")
}
