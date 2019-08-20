# context("test-create_package_json")
# 
# 
# temp <- file.path(tempdir(), "deletemetesting")
# 
# if(!dir.exists(temp)) {
#   dir.create(temp)
# }
# 
# if(file.exists(file.path(temp, "package.json"))) {
#   file.remove(file.path(temp, "package.json"))
# }
# 
# 
# test_that("run_shiny returns message", {
#   expect_message(electricShine::create_package_json(appName = "MyApp",
#                                                     semanticVersion = "0.0.0",
#                                                     path = temp,
#                                                     iconPath = NULL,
#                                                     repository = "",
#                                                     author = "",
#                                                     copyrightYear = "",
#                                                     copyrightName = "",
#                                                     website = "",
#                                                     license = "",
#                                                     deps = NULL))
# 
# })
# 
# #need to revise to allow for changing dependencies
# 
# test_that("package.json was written as expected",{
# 
#  # expect_known_hash(readLines(file.path(temp, "package.json")), "7a1f231e5d")
# 
# 
# })
