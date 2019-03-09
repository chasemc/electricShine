context("test-create_folder")

#name1 <- basename(tempfile())
path1 <- dirname(tempfile())

Create_Folder(path1, "t")

test_that(" Folder exisitng chek ", {
  testthat::expect_true(file.exists(file.path(path1, "t")) )
  testthat::expect_error(Create_Folder(path1, "t"))
})
