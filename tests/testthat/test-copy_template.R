context("test-copy_template")

a <- tempdir()
a <- file.path(a, "imatestdir")

suppressWarnings(file.remove(a))

dir.create(a)

electricShine::copy_template(a)

a <- list.files(a, recursive = T)


test_that("copying boilerplate works", {
  skip_on_os(c("mac","linux"))
    expect_known_hash(a, "9732cb1fc0")
})
