context("test-copy_template")

a <- tempdir()
a <- file.path(a, "imatestdir")

suppressWarnings(file.remove(a))

dir.create(a)

electricShine::copy_template(a)

a <- sort(list.files(a, recursive = T))

expected <- sort(c(
              "build/start.js",
              "build/webpack.app.config.js",
              "build/webpack.base.config.js",
              "build/webpack.e2e.config.js",
              "build/webpack.unit.config.js",
              "config/env_development.json",
              "config/env_production.json",
              "config/env_test.json",
              "e2e/hello_world.e2e.js",
              "e2e/utils.js",
              "helpers/context_menu.js",
              "helpers/external_links.js",
              "menu/dev_menu_template.js",
              "menu/edit_menu_template.js",
              "src/background.js",
              "src/helpers/context_menu.js",
              "src/helpers/external_links.js",
              "src/menu/dev_menu_template.js",
              "src/menu/edit_menu_template.js",
              "temp/e2e.js",
              "temp/e2e.js.map",
              "temp/e2e_entry.js",
              "temp/specs.js",
              "temp/specs.js.map",
              "temp/specs_entry.js"))

test_that("copying boilerplate works", {
    expect_equal(a, expected)
})
