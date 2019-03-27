
#' Create the package.json file for npm
#'
#' @param name  name of app
#' @param description short description of app
#' @param productName product name
#' @param version version number (as string, not numeric): see https://semver.org/ for details on how to use version numbers
#' @param appPath path to created app
#' @param iconPath path to icon within created app
#' @param repository purely for info- does the shiny app live in a repository (e.g. GitHub)
#' @param author author of the app
#' @param license license of the App. Not the full license, only the title (e.g. MIT, or GPLv3)
#' @param electronVersion version of electron that should be downloaded from npm and used to create app
#' @param electronPackagerVersion version of electronPackager that should be downloaded from npm and used to create app
#'
#' @return
#' @export
#'
#' @examples
create_package_json <- function(appName = "MyApp",
                                description = "description",
                                productName = "productName",
                                semanticVersion = "0.0.0",
                                appPath,
                                iconPath,
                                repository = "",
                                author = "",
                                copyrightYear = "",
                                copyrightName = "",
                                website = "",
                                license = "",
                                companyName = "",
                                keywords = "",
                                electronVersion = "^4.0.7",
                                electronPackagerVersion = "^13.1.1"){

  if (is.null(version)) {
    stop("The package_json() function requires a \"version\" input")
  }



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
  "dependencies": {
  "fs-jetpack": "^2.1.0"
  },
  "devDependencies": {
  "@babel/core": "^7.0.0-beta.54",
  "@babel/preset-env": "^7.0.0-beta.54",
  "babel-loader": "^8.0.0-beta.4",
  "babel-plugin-transform-object-rest-spread": "^7.0.0-beta.3",
  "chai": "^4.1.0",
  "css-loader": "^1.0.0",
  "electron": "2.0.2",
  "electron-builder": "^20.15.1",
  "electron-mocha": "^6.0.4",
  "friendly-errors-webpack-plugin": "^1.7.0",
  "mocha": "^5.2.0",
  "source-map-support": "^0.5.6",
  "spectron": "^3.8.0",
  "style-loader": "^0.21.0",
  "webpack": "^4.12.0",
  "webpack-cli": "^3.0.4",
  "webpack-merge": "^4.1.3",
  "webpack-node-externals": "^1.7.2"
  }
}
',  .open = "<<", .close = ">>")

  electricShine::write_text(text = file,
                            filename = "package.json",
                            path = appPath)

}
