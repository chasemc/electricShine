
#' Create the package.json file for npm
#'
#' @param app_name name of your app. This is what end-users will see/call an app
#' @param description short description of app
#' @param app_root_path app_root_path to where package.json will be written
#' @param repository purely for info- does the shiny app live in a repository (e.g. GitHub)
#' @param author author of the app
#' @param license license of the App. Not the full license, only the title (e.g. MIT, or GPLv3)
#' @param semantic_version semantic version of app see https://semver.org/ for more information on versioning
#' @param copyright_year year of copyright
#' @param copyright_name copyright-holder's name
#' @param deps is to allow testing with testthat
#' @param website website of app or company
#'
#' @return outputs package.json file with user-input modifications
#' @export
#'
create_package_json <- function(app_name = "MyApp",
                                description = "description",
                                semantic_version = "0.0.0",
                                app_root_path = NULL,
                                repository = "",
                                author = "",
                                copyright_year = "",
                                copyright_name = "",
                                website = "",
                                license = "",
                                deps = NULL){



  # null is to allow for testing
  if (is.null(deps)) {
  # get package.json dependencies
    # [-1] remove open { necessary for automated dependency checker
  deps <- readLines(system.file("template/package.json", package = "electricShine"))[-1]
  deps <- paste0(deps, collapse = "\n")
  }

  file <- glue::glue(
'
{
  "name": "<<app_name>>",
  "productName": "<<app_name>>",
  "description": "<<description>>",
  "version": "<<semantic_version>>",
  "private": true,
  "author": "<<author>>",
  "copyright": "<<copyright_year>> <<copyright_name>>",
  "license": "<<license>>",
  "homepage": "<<website>>",
  "main": "app/background.js",
  "build": {
  "appId": "com.<<app_name>>",
  "files": [
  "app/**/*",
  "node_modules/**/*",
  "package.json"
  ],
  "directories": {
  "buildResources": "resources"
  },
  "publish": null,
  "asar": false
  },
  "scripts": {
  "postinstall": "electron-builder install-app-deps",
  "preunit": "webpack --config=build/webpack.unit.config.js --env=test --display=none",
  "unit": "electron-mocha temp/specs.js --renderer --require source-map-support/register",
  "pree2e": "webpack --config=build/webpack.app.config.js --env=test --display=none && webpack --config=build/webpack.e2e.config.js --env=test --display=none",
  "e2e": "mocha temp/e2e.js --require source-map-support/register",
  "test": "npm run unit && npm run e2e",
  "start": "node build/start.js",
  "release": "npm test && webpack --config=build/webpack.app.config.js --env=production && electron-builder"
  },
 <<deps>>

',  .open = "<<", .close = ">>")

  electricShine::write_text(text = file,
                            filename = "package.json",
                            path = app_root_path)

}
