

test_that(".check_arch works", {
  expect_silent(.check_arch("x86_64"))
  expect_silent(.check_arch("aarch64"))
  expect_error(.check_arch("anything_else"),
               "Unfortunately 32 bit operating system builds are unsupported, if you would like to contribute to support this, that would be cool")
  
})
