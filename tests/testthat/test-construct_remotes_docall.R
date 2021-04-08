test_that("construct_remotes_docall works", {
  expect_identical(.construct_remotes_docall("test_string"),
                   "do.call(readRDS('test_string')\\$remotes_code, readRDS('test_string')\\$passthr)")
})
