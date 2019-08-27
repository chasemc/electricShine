



test_that(".check_repo_set works", {
  expect_error(.check_repo_set(arguments = list(cran_like_url = NULL, 
                                                mran_date = NULL)),
               "'cran_like_url' or 'mran_date' must be set. 'mran_date' is suggested and should be a date in the format 'yyyy-mm-dd'")
  
  expect_error(.check_repo_set(arguments = list(cran_like_url = 'NULL', 
                                                mran_date = 'NULL')),
               "Values provided for both 'cran_like_url' and 'mran_date'.")
  
  
})
