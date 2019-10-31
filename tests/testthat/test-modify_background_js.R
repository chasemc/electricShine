

app_root_path <- file.path(tempdir(),
                  "test_mod_background")

dir.create(app_root_path)


copy_template(app_root_path)

background_js_path <- file.path(app_root_path,
                  "src", 
                  "background.js")



cp <- file.path(dirname(background_js_path), 
                "cp.js")
file.copy(background_js_path,
          cp)

background_js_path <- normalizePath(background_js_path, winslash = "/")

modify_background_js(background_js_path = background_js_path,
                     my_package_name = "testcheck",
                     function_name = "apprunner", 
                     r_path = "a")

a <- readLines(background_js_path)[[156]]
a2 <- "    ['-e', 'testcheck::apprunner(options = list(port = ' + srv.address().port + '))'], {"

test_that("multiplication works", {
  expect_identical(a, a2)

})

