# buildPath <- tempdir()
# MRANdate <- as.character(Sys.Date() - 3)
# 
# 
# 
# 
# fail1 <- function(){
#   
#   electricShine::buildElectricApp(app_name = "Test_App",
#                                   product_name = "test prod name",
#                                   short_description = "test desc",
#                                   semantic_version = "1.0.0",
#                                   build_path = buildPath,
#                                   mran_date = NULL,
#                                   cran_like_url = "https://cran.r-project.org",
#                                   function_name = "run_app",
#                                   git_host = NULL,
#                                   git_repo = NULL,
#                                   local_package_path = system.file("demoApp", package = "electricShine"),
#                                   package_install_opts = NULL,
#                                   run_build = TRUE,
#                                   nodejs_path = getnode,
#                                   nodejs_version = nodejs_version)
#   
# }
# 
# 
# 
# test_that("metafunction error tests", {
#   expect_error(fail1(),
#                "Values provided for both 'cran_like_url' and 'mran_date'.",
#                fixed = TRUE)
#   expect_error(fail2(),
#                "'cran_like_url' or 'mran_date' must be set. 'mran_date' is suggested and should be a date in the format 'yyyy-mm-dd' ",
#                fixed = TRUE)
#   expect_error(fail3(),
#                "electricShine::buildElectricApp() requires you to provide an 'app_name' argument specifying\n         the shiny app/package name.",
#                fixed = TRUE)
#   expect_error(fail4(),
#                "electricShine::buildElectricApp() requires you to specify a 'semantic_version' argument.\n           (e.g. electricShine::electricShine(semantic_version = '1.0.0') )",
#                fixed = TRUE)
#   expect_error(fail5(),
#                "electricShine::buildElectricApp() requires you to specify a 'function_name' argument.\n         function_name should be the name of the function that starts your package's shiny app.\n         e.g. is you have the function myPackage::start_shiny(), provide 'start_shiny'",
#                fixed = TRUE)
#   expect_error(fail6(),
#                "electricShine::buildElectricApp() requires you to specify a 'package_name' argument.\n           (e.g. electricShine::electricShine(package_name = 'myPackage') )",
#                fixed = TRUE)
# })
# 
# 
# 
# 
