#' Meta-function
#'
#' @param build_path Path where the build files will be created, preferably points to an empty directory.
#'     Must not contain a folder with the name as what you put for electrify(app_name).
#' @param app_name This will be the name of the executable. It's a uniform type identifier (UTI)
#'    that contains only alphanumeric (A-Z,a-z,0-9), hyphen (-), and period (.) characters.
#'    see https://www.electron.build/configuration/configuration
#'    and https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-102070
#' @param product_name String - allows you to specify a product name for your executable which
#'    contains spaces and other special characters not allowed in the name property.
#'    https://www.electron.build/configuration/configuration
#' @param semantic_version semantic version of your app, as character (not numeric!);
#'     See https://semver.org/ for more info on semantic versioning.
#' @param mran_date MRAN snapshot date, formatted as 'YYYY-MM-DD'
#' @param package_location one of c("local", "github", "gitlab", "bitbucket")
#' @param package_path path to local shiny-app package. If 'git_host' isn't used, use host/repo (e.g. chasemc/electricShine)
#' @param package_install_opts optional arguments passed to remotes::install_github, install_gitlab, install_bitbucket, or install_local
#' @param function_name the function name in your package that starts the shiny app
#' @param run_build logical, whether to start the build process, helpful if you want to modify anthying before building
#' @param short_description short app description
#' @param cran_like_url url to cran-like repository
#' @param nodejs_path path to nodejs
#' @param nodejs_version nodejs version to install
#' @param permission automatically grant permission to install nodejs and R
#' @param mac_url url to mac OS tar.gz
#'
#' @inheritParams download_miniconda3
#' @inheritParams install_miniconda3
#'
#' @export
#'
electrify <- function(app_name = "example_app",
                      product_name = "product_name",
                      short_description = NULL,
                      semantic_version = NULL,
                      build_path = "/Users/chase/Documents/eshine_temp",
                      mran_date = NULL,
                      cran_like_url="https://cran.r-project.org",
                      function_name = NULL,
                      shiny_package_location = "github",
                      shiny_package_path = "chasemc/demoapp",
                      shiny_package_install_opts = NULL,
                      run_build = TRUE,
                      nodejs_path = file.path(system.file(package = "electricShine"), "nodejs"),
                      nodejs_version = "v12.16.2",
                      permission = FALSE,
                      mac_url = "https://mac.r-project.org/el-capitan/R-3.6-branch/R-3.6-branch-el-capitan-sa-x86_64.tar.gz",
                      conda_env = "eshine",
                      r_version = NULL,
                      ...){

  if (is.null(r_version)) {
    r_ver <- paste0(R.Version()$major, ".", R.Version()$minor)
    message(paste0("Using ",
                   R.version.string,
                   "\n",
                   " This may cause issues if dependencies were set to\ download from a static cran-like repository like MRAN.\nConsider setting an R version with the 'r_version' argument"
    ))
  }
  # Check and fail early ---------------------------------------------------

  .check_arch()
  # .check_repo_set(cran_like_url = cran_like_url,
  #                 mran_date = mran_date)
  #
  # .check_build_path_exists(build_path = build_path)
  #
  #
  # .check_package_provided(git_host = git_host,
  #                         git_repo = git_repo,
  #                         local_package_path = local_package_path)
  #
  # if (is.null(app_name)) {
  #   stop("electricShine::electrify() requires you to provide an 'app_name' argument specifying
  #        the shiny app/package name.")
  # }
  #
  # if (is.null(semantic_version)) {
  #   stop("electricShine::electrify() requires you to specify a 'semantic_version' argument.
  #          (e.g. electricShine::electricShine(semantic_version = '1.0.0') )")
  # }
  #
  # if (is.null(function_name)) {
  #   stop("electricShine::electrify() requires you to specify a 'function_name' argument.
  #        function_name should be the name of the function that starts your package's shiny app.
  #        e.g. is you have the function myPackage::start_shiny(), provide 'start_shiny'")
  # }
  #
  # if (is.null(nodejs_path)) {
  #   file.path(system.file(package = "electricShine"), "nodejs")
  # }
  #
  # if (!is.null(package_install_opts)) {
  #   if (!is.list(package_install_opts)) {
  #     stop("package_install_opts in electrify() must be a list of arguments.")
  #   }
  # }

  app_root_path <- file.path(build_path,
                             app_name)

  # TODO: replace with permission to download/install/use miniconda
  #if (!isTRUE(permission)) {
  #  permission_to_install_r <- .prompt_install_r(app_root_path)
  #  permission_to_install_nodejs <- .prompt_install_nodejs(nodejs_path)

  #} else {
  #  permission_to_install_r <- TRUE
  #  permission_to_install_nodejs <- TRUE
  #}

  # Set cran_like_url -------------------------------------------------------

  # If MRAN date provided, construct MRAN url. Else, pass through cran_like_url.

  cran_like_url <- construct_mran_url(mran_date = mran_date,
                                      cran_like_url = cran_like_url)

  # Create top-level build folder for app  ----------------------------------

  electricShine::create_folder(app_root_path)

  # Copy Electron template into app_root_path -------------------------------------

  electricShine::copy_template(app_root_path)

  # Download miniconda ------------------------------------------------------

  os <- electricShine::get_os()
  # default installation is in tempdir()
  miniconda_install_script_path <- download_miniconda3(os = os,
                                                       ...)

  # Install miniconda -------------------------------------------------------

  # default installation is in tempdir()

  conda_top_dir <- install_miniconda3(miniconda_install_script_path = miniconda_install_script_path,
                                      ...)
  # In some cases conda complains about not being up to date
  # seems related to https://github.com/conda/conda/issues/7165 which is supposedly resolved
  # but seems not be
  conda_update(conda_top_dir = conda_top_dir)


  # Create a new conda environment ------------------------------------------

  # This environment is what will be packaged for distribution
  conda_create_env(conda_top_dir = conda_top_dir,
                   conda_env = conda_env)


  # Download and Install R --------------------------------------------------

  conda_install_r(conda_top_dir = conda_top_dir,
                  conda_env = conda_env,
                  conda_repo = "conda-forge",
                  ...)

# Download and install conda pack -----------------------------------------

  conda_pack_env <- "conda-pack"
  conda_create_env(conda_top_dir = conda_top_dir,
                   conda_env = conda_pack_env)

  conda_install_pack(conda_top_dir = conda_top_dir,
                     conda_env = conda_pack_env,
                     conda_repo = "conda-forge")

  # Install {remotes} R package ---------------------------------------------

  install_r_remotes(conda_top_dir = conda_top_dir,
                    r_package_repo = cran_like_url,
                    conda_env = conda_env)


  # Install the shiny app R package -----------------------------------------

  install_remote_package(conda_top_dir = conda_top_dir,
                         conda_env = conda_env,
                         repo_location = shiny_package_location,
                         repo = shiny_package_path,
                         dependencies_repo = cran_like_url,
                         package_install_opts = shiny_package_install_opts)


  install_remote_package(conda_top_dir = conda_top_dir,
                         conda_env = conda_env,
                         repo_location = shiny_package_location,
                         repo = shiny_package_path,
                         dependencies_repo = cran_like_url,
                         package_install_opts = shiny_package_install_opts)




    conda_pack_dir <- normalizePath(tempdir())

  conda_pack(conda_top_dir = conda_top_dir,
             conda_env = conda_env,
             conda_pack_env="conda-pack",
             outdir = conda_pack_dir)

  conda_pack_gz <- file.path(conda_pack_dir, paste0(conda_env, ".tar.gz"))
  conda_pack_gz <- normalizePath(conda_pack_gz, mustWork = F)

  conda_build_pack <- file.path(build_path,app_name,"build", "pub_conda")
  dir.create(conda_build_pack, recursive = T)

  untar(tarfile = conda_pack_gz, exdir = conda_build_pack)


}
#WIP



