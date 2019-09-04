context("test-long_running_tests")

#---- Install R
temp <- file.path(tempdir(), "testapp")
dir.create(temp)
temp <- normalizePath(temp, "/")
copy_template(temp)

install_r(cran_like_url = "https://cran.r-project.org",
          app_root_path = temp,
          mac_url = "https://mac.r-project.org/el-capitan/R-3.6-branch/R-3.6-branch-el-capitan-sa-x86_64.tar.gz")

z <- file.exists(file.path(temp, "app", "r_lang", "bin", "R.exe"))

test_that("install_r installs r.exe", {
  skip_on_os(c("mac","linux"))
  expect_true(z)
  
})


#---- nodejs tests

temp <- file.path(tempdir(), "deletemetesting")
dir.create(temp)
temp <- normalizePath(temp, "/")
nodejs_version <- "10.16.0"


getnode <- electricShine::get_nodejs(node_url = "https://nodejs.org/dist/",
                               nodejs_path = temp,
                               force_install = FALSE,
                               nodejs_version = nodejs_version)

test_that("get_nodejs provides message", {
  expect_equal(basename(getnode$node_path), "node.exe")
  expect_equal(basename(getnode$npm_path), "npm-cli.js")
})

node_top_dir <- dirname(getnode$node_path)


test_that("get_nodejs provides message", {
  expect_silent(.check_node_works(node_top_dir,
                                  nodejs_version))
  
  expect_error(.check_node_works(node_top_dir,
                                 "1"))
})






#---- Check that get and find return same paths
findnode <- electricShine::find_nodejs(temp)

test_that("get_nodejs() provides the same paths for node and npm as find_nodejs()", {
  skip_on_os(c("mac","linux"))
  expect_equal(getnode, findnode)
})


#---- Metafunction tests


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
                                nodejs_path = findnode$node_path,
                                nodejs_version = "v10.16.0")
  












app_name = "Test_App"
product_name = "test prod name"
short_description = "test desc"
semantic_version = "1.0.0"
build_path = buildPath
mran_date = NULL
cran_like_url = "https://cran.r-project.org"
function_name = "run_app"
git_host = NULL
git_repo = NULL
local_package_path = system.file("demoApp", package = "electricShine")
package_install_opts = NULL
run_build = TRUE
nodejs_path = findnode$node_path
nodejs_version = "v10.16.0"












  





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

