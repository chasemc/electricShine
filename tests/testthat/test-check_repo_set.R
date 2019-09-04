
test_that(".check_repo_set works", {
  expect_error(.check_repo_set(cran_like_url = NULL, 
                               mran_date = NULL),
               "electricShine requires you to specify either a 'cran_like_url' or 'mran_date' argument specifying\n         the shiny app/package to be turned into an Electron app")
  
  expect_error(.check_repo_set(cran_like_url = 'NULL', 
                               mran_date = 'NULL'),
               "Values provided for both 'cran_like_url' and 'mran_date'.")
  
  
})
