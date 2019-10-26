

test_that(".check_package_provided works", {
  
  expect_silent(.check_package_provided(git_host = "any_string",
                                        git_repo = "any_string",
                                        local_package_path = NULL))
  
  expect_silent(.check_package_provided(git_host = NULL,
                                        git_repo = NULL,
                                        local_package_path = "any_string"))
  
  expect_error(.check_package_provided(git_host = NULL,
                                       git_repo = "chasemc",
                                       local_package_path = NULL),
               "Must provide both 'git_host' and 'git_repo', or just 'local_package_path'.",
               fixed = TRUE)
  expect_error(
    .check_package_provided(git_host = "any_string",
                            git_repo = "any_string",
                            local_package_path = "any_string"),
    "Values provided for both 'git_repo' and 'local_package_path'; electricShine requires that only one of these is not NULL.",
    fixed = TRUE)
})

