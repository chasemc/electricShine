if (electricShine::get_os() != "unix") {
  
  context("test-long_running_tests")
  
  
  
  # Install R package and deps from local path with space in path ----------
  
  
  
  tmp <- file.path(tempdir(), "space path")
  dir.create(tmp)
  tmp <- file.path(tempdir(), "space path", "build_git_install")
  dir.create(tmp)
  
  tmp <- normalizePath(tmp, "/")
  
  repo <- system.file("demoApp", package = "electricShine")
  repos <- "https://cran.r-project.org/"
  
  
  
  
  installed_r <-  electricShine::install_r(cran_like_url = "https://cran.r-project.org",
                                           app_root_path = tmp,
                                           mac_url = "https://mac.r-project.org/el-capitan/R-3.6-branch/R-3.6-branch-el-capitan-sa-x86_64.tar.gz",
                                           permission_to_install = TRUE)
  
  
  test_that("install_r works", {+
      testthat::skip_on_os("linux")
    expect_identical(basename(installed_r),
                     "bin")
    expect_true(any(file.exists(installed_r, pattern = "Rscript")))
    
  })
  
  
  # 
  # 
  # 
  # 
  # 
  # 
  # installed_app <- electricShine::install_user_app(library_path = file.path(dirname(installed_r), "library"),
  #                                   repo_location = "github",
  #                                   repo = "chasemc/electricShine",
  #                                   repos = repos,
  #                                   package_install_opts = list(type = "binary",
  #                                                               subdir = "inst/demoApp",
  #                                                               args = "--no-test-load"))
  #   
  #   
  #   
  # expected_pkgs <- sort(c("base",
  #                         "BH",
  #                         "boot",
  #                         "class",
  #                         "cluster",
  #                         "codetools",
  #                         "compiler",
  #                         "crayon",
  #                         "datasets",
  #                         "demoApp",
  #                         "digest",
  #                         "fastmap",
  #                         "foreign",
  #                         "graphics",
  #                         "grDevices",
  #                         "grid",
  #                         "htmltools",
  #                         "httpuv",
  #                         "jsonlite",
  #                         "KernSmooth",
  #                         "later",
  #                         "lattice",
  #                         "magrittr",
  #                         "MASS",
  #                         "Matrix",
  #                         "methods",
  #                         "mgcv",
  #                         "mime",
  #                         "nlme",
  #                         "nnet",
  #                         "parallel",
  #                         "promises",
  #                         "R6",
  #                         "Rcpp",
  #                         "rlang",
  #                         "rpart",
  #                         "shiny",
  #                         "sourcetools",
  #                         "spatial",
  #                         "splines",
  #                         "stats",
  #                         "stats4",
  #                         "survival",
  #                         "tcltk",
  #                         "tools",
  #                         "utils",
  #                         "xtable"))
  # 
  # returned_pkgs <- list.files(file.path(dirname(installed_r), "library"))
  # 
  # 
  # 
  # test_that("installed_app works", {
  #   testthat::skip_on_os("linux")
  #   expect_identical(installed_app,
  #                    "demoApp")
  #   expect_equal(sort(expected_pkgs),
  #                sort(returned_pkgs))
  # })
  # 
  
  
  #---- nodejs tests
  
  temp <- file.path(tempdir(),
                    "space path",
                    "deletemetesting")
  dir.create(temp)
  temp <- normalizePath(temp, "/")
  nodejs_version <- "10.16.0"
  
  
  getnode <- electricShine::install_nodejs(node_url = "https://nodejs.org/dist/",
                                           nodejs_path = temp,
                                           force_install = FALSE,
                                           nodejs_version = nodejs_version,
                                           permission_to_install  = TRUE)
  
  
  # Check "check_node/npm_works" --------------------------------------------
  
  test_that(".check_node_works provides message", {
    testthat::skip_on_os("linux")
    expect_message(electricShine:::.check_node_works(node_top_dir = getnode,
                                                     expected_version = nodejs_version))
    
  })
  
  test_that(".check_npm_works provides message", {
    testthat::skip_on_os("linux")
    expect_message(electricShine:::.check_npm_works(node_top_dir = getnode))
    
  })
  
  
  node_exists <- electricShine:::.check_node_works(node_top_dir = tempdir(),
                                                   expected_version = nodejs_version)
  
  npm_exists <- electricShine:::.check_npm_works(node_top_dir = tempdir())
  
  
  test_that(".check_node_works  gives false ", {
    testthat::skip_on_os("linux")
    expect_false(node_exists)
  })
  
  
  test_that(".check_npm_works gives false", {
    testthat::skip_on_os("linux")
    expect_false(npm_exists)
    
  })
  
  
  node_exists <- electricShine:::.check_node_works(node_top_dir = getnode,
                                                   expected_version = nodejs_version)
  
  npm_exists <- electricShine:::.check_npm_works(node_top_dir = getnode)
  
  
  
  test_that(".check_node_works ", {
    testthat::skip_on_os("linux")
    expect_true(file.exists(node_exists))
    expect_equal(tools::file_path_sans_ext(basename(node_exists)),
                 "node")
  })
  
  
  test_that(".check_npm_works ", {
    testthat::skip_on_os("linux")
    expect_true(file.exists(npm_exists))
    expect_equal(tools::file_path_sans_ext(basename(npm_exists)),
                 "npm")
  })
  
  
  
  
  # 
  # 
  # # Metafunction tests ------------------------------------------------------
  # temp <- file.path(tempdir(),
  #                   "space path",
  #                   "Test_Apps")
  # buildPath <- temp
  # dir.create(temp)
  # MRANdate <- as.character(Sys.Date() - 3)
  # 
  # suppressWarnings(
  #   electricShine::electrify(app_name = "Test_App",
  #                            product_name = "test prod name",
  #                            short_description = "test desc",
  #                            semantic_version = "1.0.0",
  #                            build_path = buildPath,
  #                            mran_date = NULL,
  #                            cran_like_url = "https://cran.r-project.org",
  #                            function_name = "run_app",
  #                            git_host = NULL,
  #                            git_repo = NULL,
  #                            local_package_path = system.file("demoApp",
  #                                                             package = "electricShine"),
  #                            package_install_opts = list(type = "binary"),
  #                            run_build = TRUE,
  #                            nodejs_path = getnode,
  #                            nodejs_version = nodejs_version,
  #                            permission = TRUE)
  # 
  # )
  # 
  # 
  # a <- list.dirs(buildPath, recursive = F, full.names = F)
  # 
  # test_that("metaFunction builds app dir", {
  #   testthat::skip_on_os("linux")
  #   testthat::expect_length(grep("Test_App", a),
  #                           1)
  # })
  # 
  # #----
  # 
  # b <- file.path(buildPath, "Test_App")
  # a <- list.dirs(b,
  #                recursive = F,
  #                full.names = F)
  # expected <- c("app",
  #               "build",
  #               "config",
  #               "dist",
  #               "e2e",
  #               "helpers",
  #               "menu",
  #               "node_modules",
  #               "resources",
  #               "src",
  #               "temp")
  # 
  # test_that("metaFunction scaffolds app build", {
  #   testthat::skip_on_os("linux")
  #   testthat::expect_equal(a, expected)
  # })
  # 
  # #----
  # 
  # b <- file.path(buildPath, "Test_App", "app")
  # a <- list.files(b,
  #                 recursive = F,
  #                 full.names = F)
  # expected <- c("background.js",
  #               "background.js.map",
  #               "loading.html",
  #               "r_lang")
  # 
  # test_that("metaFunction scaffolds app dir", {
  #   testthat::skip_on_os("linux")
  #   testthat::expect_equal(sort(a),
  #                          sort(expected))
  # })
  # 
  # 
  # #----
  # 
  # 
  # b <- file.path(buildPath, "Test_App", "app", "r_lang", "bin", "Rscript.exe")
  # b <- normalizePath(b, "/")
  # b <- shQuote(b)
  # w <- system(paste0(b, " -e 2+2"),
  #             intern = T)
  # 
  # test_that("metaFunction has working rcript.exe for windows", {
  #   skip_on_os(c("mac","linux"))
  #   testthat::expect_equal(w,
  #                          "[1] 4")
  # })
  # 
}
