context("test-create_folder")

#name1 <- basename(tempfile())
path1 <- dirname(tempfile())

electricShine::create_folder(path1, "t")

test_that(" Folder exisitng chek ", {
  expect_true(file.exists(file.path(path1, "t")) )
  expect_error(electricShine::create_folder(path1, "t"))
})
