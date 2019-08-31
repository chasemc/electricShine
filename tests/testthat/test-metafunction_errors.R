






fail1 <- quote({
  electricShine::buildElectricApp(
    app_name = "My_App",
    description = "My demo application",
    package_name = "demoApp",
    semantic_version = "1.0.0",
    build_path = tempdir(),
    mran_date = "2019-01-01",
    function_name = "run_app",
    github_repo = "chasemc/demoApp",
    local_path  = NULL,
    cran_like_url = "NULL"
  )
})



fail2 <- quote({
  electricShine::buildElectricApp(
    app_name = "My_App",
    description = "My demo application",
    package_name = "demoApp",
    semantic_version = "1.0.0",
    build_path = tempdir(),
    mran_date = NULL,
    function_name = "run_app",
    github_repo = "chasemc/demoApp",
    local_path  = NULL,
    cran_like_url = "NULL"
  )
})




test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})








if (is.null(github_repo) && is.null(local_path)) {
  stop("electricShine::buildElectricApp() requires you to specify either a 'github_repo' or 'local_path' argument specifying
         the shiny app/package to be turned into an Electron app")
}
if (is.null(build_path)) {
  stop("electricShine::buildElectricApp() requires you to specify a 'path' argument.
(e.g. electricShine::electricShine(path = 'C:/Users/me/Desktop/my_app') )")
}
if (is.null(version)) {
  stop("electricShine::buildElectricApp() requires you to specify a 'version' argument.
           (e.g. electricShine::electricShine(version = '1.0.0') )")
}
if (is.null(function_name)) {
  stop("electricShine::buildElectricApp() requires you to specify a 'function_name' argument.
         function_name should be the name of the function that starts your package's shiny app.
         e.g. is you have the function myPackage::start_shiny(), provide 'start_shiny'")
}
if (is.null(package_name)) {
  stop("electricShine::buildElectricApp() requires you to specify a 'package_name' argument.
           (e.g. electricShine::electricShine(package_name = 'myPackage') )")
}