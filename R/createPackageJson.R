
#' Create the package.json file for npm
#'
#' @param appName name of your app. This is what end-users will see/call an app
#' @param description short description of app
#' @param productName product name
#' @param appPath path to created app
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
                                productName = "productName",
                                semanticVersion = "0.0.0",
                                appPath = NULL,
                                iconPath = NULL,
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
  "@babel/core": "^7.4.0",
  "@babel/preset-env": "^7.4.2",
  "babel-loader": "^8.0.5",
  "babel-plugin-transform-object-rest-spread": "^6.26.0",
  "chai": "^4.2.0",
  "css-loader": "^2.1.1",
  "electron": "^4.1.1",
  "electron-builder": "^20.39.0",
  "electron-mocha": "^6.0.4",
  "friendly-errors-webpack-plugin": "^1.7.0",
  "mocha": "^6.0.2",
  "source-map-support": "^0.5.11",
  "spectron": "^5.0.0",
  "style-loader": "^0.23.1",
  "webpack": "^4.29.6",
  "webpack-cli": "^3.3.0",
  "webpack-merge": "^4.2.1",
  "webpack-node-externals": "^1.7.2"
  }
}
',  .open = "<<", .close = ">>")

  electricShine::write_text(text = file,
                            filename = "package.json",
                            path = appPath)

}
