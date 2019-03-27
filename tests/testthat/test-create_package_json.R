context("test-create_package_json")


temp <- file.path(tempdir(), "deletemetesting")

if(!dir.exists(temp)) {
  dir.create(temp)
}

if(file.exists(file.path(temp, "package.json"))) {
  file.remove(file.path(temp, "package.json"))
}


test_that("run_shiny returns message", {
  expect_message(electricShine::create_package_json(appName = "MyApp",
                                          description = "description",
                                          productName = "productName",
                                          semanticVersion = "0.0.0",
                                          appPath = temp,
                                          iconPath = temp,
                                          repository = "",
                                          author = "",
                                          copyrightYear = "",
                                          copyrightName = "",
                                          website = "",
                                          license = "",
                                          companyName = "",
                                          keywords = "",
                                          electronVersion = "^4.0.7",
                                          electronPackagerVersion = "^13.1.1"))

})



test_that("package.json was written as expected",{

  expect_known_hash(readLines(file.path(temp, "package.json")), "737c67cd8d")


})
