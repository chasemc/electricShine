context("test-run_shiny")


temp <- file.path(tempdir(), "deletemetesting")

if(!dir.exists(temp)) {
  dir.create(temp)
}

if(file.exists(file.path(temp, "app.R"))) {
  file.remove(file.path(temp, "app.R"))
}


test_that("run_shiny returns message", {
  expect_message(electricShine::run_shiny(packageName = "test123",
                                          path = temp,
                                          functionName = "runme"))
})



electricShine::run_shiny(packageName = "test123",
                                        path = temp,
                                        functionName = "runme")
fils <- list.files(temp, pattern = "app.R")
filsFull <- list.files(temp, full.names = T, pattern = "app.R")
filsFull <- readLines(filsFull)

test_that("run_shiny created file correctly", {
  expect_equal(length(fils), 1)
  expect_identical(filsFull[[1]], "library(shiny)")
  expect_identical(filsFull[[2]],"test123::runme()")

})

