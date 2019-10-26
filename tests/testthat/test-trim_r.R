

app_root_path <- file.path(file.path(tempdir(), "test_trim"))
dir.create(app_root_path)

dir.create(file.path(app_root_path, "app" ))
dir.create(file.path(app_root_path, "app", "r_lang" ))
dir.create(file.path(app_root_path, "app", "r_lang", "anything" ))

file.create(file.path(app_root_path, "app" , "not_deleted.html"))
file.create(file.path(app_root_path, "app" , "not_deleted.pdf"))


file.create(file.path(app_root_path, "app", "r_lang" , "deleted.html"))
file.create(file.path(app_root_path, "app" , "r_lang", "deleted.pdf"))

file.create(file.path(app_root_path, "app", "r_lang", "anything", "deleted.html"))
file.create(file.path(app_root_path, "app", "r_lang", "anything", "deleted.pdf"))


a <- c("not_deleted.html",
       "not_deleted.pdf",
       "r_lang/anything/deleted.html",
       "r_lang/anything/deleted.pdf",
       "r_lang/deleted.html",
       "r_lang/deleted.pdf")

files_created <- list.files(file.path(app_root_path, "app" ), full.names = F, recursive = T)


test_that("timr_r works", {
  expect_equal(files_created, a)
  testthat::expect_message(trim_r(app_root_path = app_root_path))
})

files_created <- list.files(file.path(app_root_path, "app" ), full.names = F, recursive = T)

test_that("timr_r works 2", {
  expect_equal(files_created, 
               c("not_deleted.html", "not_deleted.pdf"))
  
})

