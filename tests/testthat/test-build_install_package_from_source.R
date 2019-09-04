
tmp <- file.path(tempdir(), "build_local_install")
dir.create(tmp)
tmp <- normalizePath(tmp, "/")

repo <- system.file("demoApp", package = "electricShine")
repos <- "https://cran.r-project.org/bin/windows/base"



electricShine::install_user_app(library_path = tmp,
                                repo_location = "local",
                                repo = repo,
                                repos = repos,
                                package_install_opts = NULL)
  


expected <- c("BH",
              "crayon",
              "demoApp",
              "digest",
              "htmltools",
              "httpuv",
              "jsonlite",
              "later",
              "magrittr",
              "mime",
              "promises",
              "R6",
              "Rcpp",
              "rlang",
              "shiny",
              "sourcetools",
              "xtable")
returned <- list.files(tmp, recursive = F, full.names = F)

test_that("multiplication works", {
  expect_equal(expected, returned)
})



tmp <- file.path(tempdir(), "build_git_install")
dir.create(tmp)
tmp <- normalizePath(tmp, "/")

repo <- system.file("demoApp", package = "electricShine")
repos <- "https://cran.r-project.org/"



electricShine::install_user_app(library_path = tmp,
                                repo_location = "github",
                                repo = "chasemc/electricShine@223c993",
                                repos = repos,
                                package_install_opts = list( subdir = "inst/demoApp"))



expected <- c("BH",
              "crayon",
              "demoApp",
              "digest",
              "htmltools",
              "httpuv",
              "jsonlite",
              "later",
              "magrittr",
              "mime",
              "promises",
              "R6",
              "Rcpp",
              "rlang",
              "shiny",
              "sourcetools",
              "xtable")
returned <- list.files(tmp, recursive = F, full.names = F)

test_that("multiplication works", {
  expect_equal(expected, returned)
})
