context("test-get_nodejs")


temp <- file.path(tempdir(), "deletemetesting")

if(dir.exists(temp)) {

  a <- list.files(temp, full.names = T)
  file.remove(a)
} else {

  dir.create(temp)
}





test_that("get_nodejs provides message", {
  skip_on_os(c("mac","linux"))
  expect_message(get_nodejs(nodeUrl = "https://nodejs.org/dist",
                            installTo = temp,
                            force = FALSE,
                            nodeVersion = "v10.15.1"))
})





test_that("get_nodejs provides paths for node and npm", {
  skip_on_os(c("mac","linux"))

  a <- get_nodejs(nodeUrl = "https://nodejs.org/dist",
                  installTo = temp,
                  force = FALSE,
                  nodeVersion = "v10.15.1")
  expect_equal(length(a), 2L)
  expect_equal(names(a), c("nodePath", "npmPath"))
  expect_equal(class(unlist(a)), "character")
})


