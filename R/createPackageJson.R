
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
#'
#' @return
#' @export
#'
#' @examples
create_package_json <- function(name,
                                description,
                                productName,
                                version = NULL,
                                appPath,
                                iconPath,
                                repository = "",
                                author = "",
                                license = "",
                                electronVersion = "^4.0.7",
                                electronPackagerVersion = "^13.1.1"){

  if (is.null(version)) {
    stop("The package_json() function requires a \"version\" input")
  }



  file <- glue::glue('{{
"name": "{name}",
"version": "{version}",
"description": "{description}",
"main": "main.js",
"scripts": {{
"start": "electron .",
"package-mac": "electron-packager . --overwrite --platform=darwin --arch=x64 --icon={iconPath} --out=ElectronShinyAppMac",
"package-win": "electron-packager . --overwrite --platform=win32 --arch=ia32 --icon={iconPath} --out=ElectronShinyAppWindows --version-string.FileDescription=CE --version-string.ProductName={productName}",
"package-linux": "electron-packager . --overwrite --platform=linux --arch=x64 --icon={iconPath} --prune=true --out=release-builds"
}},
"repository": "{repository}",
"author": "{author}",
"license": "{license}",
"devDependencies": {{
"electron": "{electronVersion}",
"electron-packager": "{electronPackagerVersion}"
}}
}}
                     ')

  electricShine::write_text(text = file,
                            filename = "package.json",
                            path = appPath)

}
