

a <- tempdir()

dir.create(file.path(a, "node"))


test_that("multiplication works", {
  skip_on_os(c("mac","linux"))
  expect_equal(find_nodejs(a), 
               list(node_path = NULL,
                    npm_path = NULL))
})

fp <- file.path(a, "node", "node.exe")
file.create(fp)
fp <- normalizePath(fp, winslash = "/")


test_that("find node", {
  skip_on_os(c("mac","linux"))
  expect_equal(find_nodejs(a), 
               list(node_path = fp,
                    npm_path = NULL))
})

fp2 <- file.path(a, "node", "npm-cli.js")
file.create(fp2)
fp2 <- normalizePath(fp2, winslash = "/")

test_that("find npm", {
  skip_on_os(c("mac","linux"))
  expect_equal(find_nodejs(a), 
               list(node_path = fp,
                    npm_path = fp2))
})


