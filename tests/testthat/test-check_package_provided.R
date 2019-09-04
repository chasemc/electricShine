

test_that(".check_package_provided works", {
  
  expect_silent(.check_package_provided(github_repo = NULL,
                                        local_package = "NULL"))
  
  expect_silent(.check_package_provided(github_repo = "NULL",
                                        local_package = NULL))
  
  expect_error(.check_package_provided(github_repo = NULL,
                                       local_package = NULL),
               "electricShine requires you to specify either a 'github_repo' or 'local_package' argument specifying\n         the shiny app/package to be turned into an Electron app",
               fixed = TRUE)
  
  expect_error(.check_package_provided(github_repo = "NULL",
                                       local_package = "NULL"),
               "Values provided for both 'github_repo' and 'local_package'; electricShine requires that only one of these is not NULL.",
               fixed = TRUE)
})

