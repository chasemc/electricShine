context("test-long_running_tests")

# Install R package and deps from local path ------------------------------

# tmp <- file.path(tempdir(), "build_local_install")
# dir.create(tmp)
# tmp <- normalizePath(tmp, "/")
# 
# repo <- system.file("demoApp", package = "electricShine")
# repos <- "https://cran.r-project.org"
# 
# 
# 
# electricShine::install_user_app(library_path = tmp,
#                                 repo_location = "local",
#                                 repo = repo,
#                                 repos = repos,
#                                 package_install_opts = NULL)
# 
# expected <- sort(c("BH",
#               "crayon",
#               "demoApp",
#               "digest",
#               "htmltools",
#               "httpuv",
#               "jsonlite",
#               "later",
#               "magrittr",
#               "mime",
#               "promises",
#               "R6",
#               "Rcpp",
#               "rlang",
#               "shiny",
#               "sourcetools",
#               "xtable"))
# returned <- sort(list.files(tmp, recursive = F, full.names = F))
# 
# 
# 
# 
# test_that("multiplication works", {
#   expect_equal(expected, returned)
# })

# Install R package and deps from subdirectory at github ------------------

tmp <- file.path(tempdir(), "build_git_install")
dir.create(tmp)
tmp <- normalizePath(tmp, "/")

repo <- system.file("demoApp", package = "electricShine")
repos <- "https://cran.r-project.org/"


electricShine::install_user_app(library_path = tmp,
                                repo_location = "github",
                                repo = "chasemc/electricShine",
                                repos = repos,
                                package_install_opts = list( subdir = "inst/demoApp"))

expected <- sort(c("BH",
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
                   "xtable"))
returned <- sort(list.files(tmp, recursive = F, full.names = F))


test_that("multiplication works", {
  expect_equal(expected, returned)
})



#---- nodejs tests

temp <- file.path(tempdir(), "deletemetesting")
dir.create(temp)
temp <- normalizePath(temp, "/")
nodejs_version <- "10.16.0"


getnode <- electricShine::install_nodejs(node_url = "https://nodejs.org/dist/",
                                         nodejs_path = temp,
                                         force_install = FALSE,
                                         nodejs_version = nodejs_version)


# Check "check_node/npm_works" --------------------------------------------

test_that(".check_node_works provides message", {
  
  expect_message(.check_node_works(node_top_dir = getnode,
                                   expected_version = nodejs_version))
  
})

test_that(".check_npm_works provides message", {
  
  expect_message(.check_npm_works(node_top_dir = getnode))
  
})

suppressMessages({
node_exists <- .check_node_works(node_top_dir = tempdir(),
                                 expected_version = nodejs_version)

npm_exists <- .check_npm_works(node_top_dir = tempdir())
})

test_that(".check_node_works  gives false ", {
  expect_false(node_exists)
})


test_that(".check_npm_works gives false", {
  expect_false(npm_exists)
  
})

suppressMessages({
node_exists <- .check_node_works(node_top_dir = getnode,
                                 expected_version = nodejs_version)

npm_exists <- .check_npm_works(node_top_dir = getnode)
})


test_that(".check_node_works ", {
  expect_true(file.exists(node_exists))
  expect_equal(tools::file_path_sans_ext(basename(node_exists)),
              "node")
})


test_that(".check_npm_works ", {
  expect_true(file.exists(npm_exists))
  expect_equal(tools::file_path_sans_ext(basename(npm_exists)),
               "npm")
})






# Metafunction tests ------------------------------------------------------

buildPath <- tempdir()
MRANdate <- as.character(Sys.Date() - 3)


electricShine::buildElectricApp(app_name = "Test_App",
                                product_name = "test prod name",
                                short_description = "test desc",
                                semantic_version = "1.0.0",
                                build_path = buildPath,
                                mran_date = NULL,
                                cran_like_url = "https://cran.r-project.org",
                                function_name = "run_app",
                                git_host = NULL,
                                git_repo = NULL,
                                local_package_path = system.file("demoApp", package = "electricShine"),
                                package_install_opts = NULL,
                                run_build = TRUE,
                                nodejs_path = getnode,
                                nodejs_version = nodejs_version)





a <- list.dirs(buildPath, recursive = F, full.names = F)

test_that("metaFunction builds app dir", {
  testthat::expect_length(grep("Test_App", a), 1)
})

#----

b <- file.path(buildPath, "Test_App")
a <- list.dirs(b, recursive = F, full.names = F)
expected <- c("app",
              "build",
              "config",
              "dist",
              "e2e",
              "helpers",
              "menu",
              "node_modules",
              "resources",
              "src",
              "temp")

test_that("metaFunction scaffolds app build", {
  testthat::expect_equal(a, expected)
})

#----

b <- file.path(buildPath, "Test_App", "app")
a <- list.files(b, recursive = F, full.names = F)
expected <- c("app.R",
              "background.js",
              "background.js.map",
              "r_lang")

test_that("metaFunction scaffolds app dir", {
  testthat::expect_equal(a, expected)
})


#----


b <- file.path(buildPath, "Test_App", "app", "r_lang", "bin", "Rscript.exe")
b <- normalizePath(b, "/")
w <- system(paste0(b, " -e 2+2"), intern = T)

test_that("metaFunction has working rcript.exe for windows", {
  skip_on_os(c("mac","linux"))
  testthat::expect_equal(w, 
                         "[1] 4")
})

