
test_that(".construct_remotes_rscript works", {
  expect_identical(.construct_remotes_rscript(.construct_remotes_docall("test_string")),
               "Rscript -e \"do.call(readRDS('test_string')\\$remotes_code, readRDS('test_string')\\$passthr)\"")
})
