

test_that(".check_build_path_exists works", {
  
  expect_silent(.check_build_path_exists(arguments = list(build_path = tempdir())))
  
  expect_error(.check_build_path_exists(arguments = list(build_path = "failure")),
               "'build_path' provided, but path wasn't found",
               fixed = TRUE)
  
  expect_error(.check_build_path_exists(arguments = list(build_path = 1L)),
               "'build_path' should be character type.",
               fixed = TRUE)
  
  expect_error(.check_build_path_exists(arguments = list(build_path = "failure")),
               "'build_path' provided, but path wasn't found",
               fixed = TRUE)
  
  expect_error(.check_build_path_exists(arguments = list(build_path = NULL)),
               "'build_path' not provided",
               fixed = TRUE)
  
})


