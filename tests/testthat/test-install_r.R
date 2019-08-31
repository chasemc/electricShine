
a <- tempdir()
b <- dir.create(file.path(a, "app"))

install_r(mran_date = as.character(Sys.Date() - 3),
          a,
          mac_url = "https://mac.r-project.org/el-capitan/R-3.6-branch/R-3.6-branch-el-capitan-sa-x86_64.tar.gz")


z <- file.exists(file.path(a, "app", "r_lang", "bin", "R.exe"))
test_that("get_nodejs provides paths for node and npm", {

  expect_true(z)
    
})
