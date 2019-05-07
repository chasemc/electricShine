
#' Create the package.json file for npm
#'
#' @param appName name of your app. This is what end-users will see/call an app
#' @param description short description of app
#' @param path path to where package.json will be written
#' @param iconPath path to icon within created app
#' @param repository purely for info- does the shiny app live in a repository (e.g. GitHub)
#' @param author author of the app
#' @param license license of the App. Not the full license, only the title (e.g. MIT, or GPLv3)
#' @param electronVersion version of electron that should be downloaded from npm and used to create app
#' @param electronPackagerVersion version of electronPackager that should be downloaded from npm and used to create app
#' @param semanticVersion semantic version of app see https://semver.org/ for more information on versioning
#' @param copyrightYear year of copyright
#' @param copyrightName copyright-holder's name
#' @param website website of app or company
#'
#' @return outputs package.json file with user-input modifications
#' @export
#'
create_package_json <- function(appName = "MyApp",
                                description = "description",
                                semanticVersion = "0.0.0",
                                path = NULL,
                                iconPath = NULL,
                                repository = "",
                                author = "",
                                copyrightYear = "",
                                copyrightName = "",
                                website = "",
                                license = ""){

  if (is.null(version)) {
    stop("The package_json() function requires a \"version\" input")
  }

  # get package.json dependencies
  deps <- readLines(system.file("template/package.json", package = "electricShine"))
  deps <- paste0(deps, collapse = "\n")


file <- glue::glue(
'
{
  "name": "<<appName>>",
  "productName": "<<appName>>",
  "description": "<<description>>",
  "version": "<<semanticVersion>>",
  "private": true,
  "author": "<<author>>",
  "copyright": "<<copyrightYear>> <<copyrightName>>",
  "license": "<<license>>",
  "homepage": "<<website>>",
  "main": "app/background.js",
  "build": {
  "appId": "com.<<appName>>",
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
}
',  .open = "<<", .close = ">>")

  electricShine::write_text(text = file,
                            filename = "package.json",
                            path = path)

}
