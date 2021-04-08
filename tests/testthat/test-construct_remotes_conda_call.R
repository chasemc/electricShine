
test_that("construct_remotes_conda_call works", {
  expect_identical(.construct_remotes_conda_call(.construct_remotes_rscript(.construct_remotes_docall("test_string")), conda_top_dir = "topdir", conda_env = "eshine"),
                   "source 'topdir/bin/activate' 'topdir/envs/eshine' && Rscript -e \"do.call(readRDS('test_string')\\$remotes_code, readRDS('test_string')\\$passthr)\" && 'topdir/bin/deactivate'")
})
