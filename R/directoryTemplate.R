#' Create a directory for creating the new app and copy template of files
#'
#' @param path path to create the new app
#' @param name  name of app
#' @param description short description of app
#' @param productName product name
#' @param version version number: see https://semver.org/ for details on how to use version numbers
#'
#' @return  nothing, creates a directory
#' @export
#'
setup_directory <- function(name = "electron-quick-start",
                            description  = "A minimal Electron application",
                            productName = "hello",
                            version = NULL,
                            appPath){

  electricShine::create_package_json(name = name,
                                     description = description,
                                     productName = productName,
                                     version = version,
                                     path = appPath)

  electricShine::create_app_R(packageName = name,
                              path = appPath)

  electricShine::create_main_js(path = appPath)

  electricShine::create_renderer_js(path = appPath)

  electricShine::create_package_lock_json(path = appPath)

}



#' Create the package.json file for npm
#'
#' @param path path to create the new app
#' @param name  name of app
#' @param description short description of app
#' @param productName product name
#' @param version version number: see https://semver.org/ for details on how to use version numbers
#'
#' @return
#' @export
#'
#' @examples
create_package_json <- function(name,
                                description,
                                productName,
                                version = NULL,
                                path){

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
"package-mac": "electron-packager . --overwrite --platform=darwin --arch=x64 --out=ElectronShinyAppMac",
"package-win": "electron-packager . --overwrite --platform=win32 --arch=ia32 --icon=cc.ico --out=ElectronShinyAppWindows --version-string.FileDescription=CE --version-string.ProductName="{productName}",
"package-linux": "electron-packager . --overwrite --platform=linux --arch=x64 --icon=assets/icons/png/1024x1024.png --prune=true --out=release-builds"
}},
"repository": "https://github.com/electron/electron-quick-start",
"keywords": [
"Electron",
"quick",
"start",
"tutorial",
"demo"
],
"author": "GitHub",
"license": "CC0-1.0",
"devDependencies": {{
"electron": "^4.0.3"
}}
}}
')

  electricShine::write_text(text = file,
                            name = "package.json",
                            path = path)

}



#' Create app.R file
#'
#' @param path path of where to write app.R
#' @param packageName name of package
#'
#' @return nothing, writes app.R to path provided and provides feedback if succcessful or not
#' @export
#'
create_app_R <- function(packageName,
                         path){

  packageName <- base::basename(packageName)

  file <- glue::glue("library(shiny)

shinyApp(ui = {packageName}::app_ui(),
server = {packageName}::app_server
)
"
  )

electricShine::write_text(text = file,
                          name = "app.R",
                          path = path)


}







#' Create main.js file
#'
#' @param path path of where to write main.js
#'
#' @return nothing, writes main.js to path provided and provides feedback if succcessful or not
#' @export
#'
create_main_js <- function(path){


  file <-
    '
// Modules to control application life and create native browser window
const {app, BrowserWindow} = require("electron")


const path = require("path")
const url = require("url")
const port = "9191"
const child = require("child_process");
const MACOS = "darwin"
const WINDOWS = "win32"

var killStr = ""
var appPath = path.join(app.getAppPath(), "app.R" )
var execPath = "RScript"


if(process.platform == WINDOWS){
appPath = appPath.replace(/\\/g, "\\\\");
execPath = path.join(app.getAppPath(), "r_win", "bin", "RScript.exe" )
} else if(process.platform == MACOS){
var macAbsolutePath = path.join(app.getAppPath(), "R_mac")
var env_path = macAbsolutePath+((process.env.PATH)?":"+process.env.PATH:"");
var env_libs_site = macAbsolutePath+"/library"+((process.env.R_LIBS_SITE)?":"+process.env.R_LIBS_SITE:"");
process.env.PATH = env_path
process.env.R_LIBS_SITE = env_libs_site
process.env.NODE_R_HOME = macAbsolutePath

execPath = path.join(app.getAppPath(), "R_mac", "bin", "R" )
} else {
console.log("not on windows or macos?")
throw new Error("not on windows or macos?")
}

console.log(process.env)

const childProcess = child.spawn(execPath, ["-e", "shiny::runApp(file.path(""+appPath+""), port="+port+")"])
childProcess.stdout.on("data", (data) => {
console.log(`stdout:${data}`)
})
childProcess.stderr.on("data", (data) => {
console.log(`stderr:${data}`)
})

// Keep a global reference of the window object, if you don"t, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow

function createWindow () {
// Create the browser window.
//  mainWindow = new BrowserWindow({webPreferences:{nodeIntegration:false},width: 800, height: 600})
//  console.log(process.cwd())
console.log("create-window")


let loading = new BrowserWindow({show: false, frame: false})
//let loading = new BrowserWindow()
console.log(new Date().toISOString()+"::showing loading");
// Spin loader  (Chase TODO: This is leftover, go through it with base64enc::base64decode() then rawToChar())
loading.loadURL("data:text/html;charset=utf-8;base64,PGh0bWw+DQo8c3R5bGU+DQpib2R5ew0KICBwYWRkaW5nOiAxZW07DQogIGNvbG9yOiAjNzc3Ow0KICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogIGZvbnQtZmFtaWx5OiAiR2lsbCBzYW5zIiwgc2Fucy1zZXJpZjsNCiAgd2lkdGg6IDgwJTsNCiAgbWFyZ2luOiAwIGF1dG87DQp9DQpoMXsNCiAgbWFyZ2luOiAxZW0gMDsNCiAgYm9yZGVyLWJvdHRvbTogMXB4IGRhc2hlZDsNCiAgcGFkZGluZy1ib3R0b206IDFlbTsNCiAgZm9udC13ZWlnaHQ6IGxpZ2h0ZXI7DQp9DQpwew0KICBmb250LXN0eWxlOiBpdGFsaWM7DQp9DQoubG9hZGVyew0KICBtYXJnaW46IDAgMCAyZW07DQogIGhlaWdodDogMTAwcHg7DQogIHdpZHRoOiAyMCU7DQogIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgcGFkZGluZzogMWVtOw0KICBtYXJnaW46IDAgYXV0byAxZW07DQogIGRpc3BsYXk6IGlubGluZS1ibG9jazsNCiAgdmVydGljYWwtYWxpZ246IHRvcDsNCn0NCg0KLyoNCiAgU2V0IHRoZSBjb2xvciBvZiB0aGUgaWNvbg0KKi8NCnN2ZyBwYXRoLA0Kc3ZnIHJlY3R7DQogIGZpbGw6ICNGRjY3MDA7DQp9DQo8L3N0eWxlPg0KPGJvZHk+PCEtLSAzICAtLT4NCjxkaXYgY2xhc3M9ImxvYWRlciBsb2FkZXItLXN0eWxlMyIgdGl0bGU9IjIiPg0KICA8c3ZnIHZlcnNpb249IjEuMSIgaWQ9ImxvYWRlci0xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB4PSIwcHgiIHk9IjBweCINCiAgICAgd2lkdGg9IjgwcHgiIGhlaWdodD0iODBweCIgdmlld0JveD0iMCAwIDUwIDUwIiBzdHlsZT0iZW5hYmxlLWJhY2tncm91bmQ6bmV3IDAgMCA1MCA1MDsiIHhtbDpzcGFjZT0icHJlc2VydmUiPg0KICA8cGF0aCBmaWxsPSIjMDAwIiBkPSJNNDMuOTM1LDI1LjE0NWMwLTEwLjMxOC04LjM2NC0xOC42ODMtMTguNjgzLTE4LjY4M2MtMTAuMzE4LDAtMTguNjgzLDguMzY1LTE4LjY4MywxOC42ODNoNC4wNjhjMC04LjA3MSw2LjU0My0xNC42MTUsMTQuNjE1LTE0LjYxNWM4LjA3MiwwLDE0LjYxNSw2LjU0MywxNC42MTUsMTQuNjE1SDQzLjkzNXoiPg0KICAgIDxhbmltYXRlVHJhbnNmb3JtIGF0dHJpYnV0ZVR5cGU9InhtbCINCiAgICAgIGF0dHJpYnV0ZU5hbWU9InRyYW5zZm9ybSINCiAgICAgIHR5cGU9InJvdGF0ZSINCiAgICAgIGZyb209IjAgMjUgMjUiDQogICAgICB0bz0iMzYwIDI1IDI1Ig0KICAgICAgZHVyPSIwLjZzIg0KICAgICAgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiLz4NCiAgICA8L3BhdGg+DQogIDwvc3ZnPg0KPC9kaXY+DQo8L2JvZHk+DQo8L2h0bWw+");

loading.once("show", () => {
console.log(new Date().toISOString()+"::show loading")
mainWindow = new BrowserWindow({webPreferences:{nodeIntegration:false}, show:false, width: 800, height: 600, title:""})

mainWindow.webContents.once("dom-ready", () => {
console.log(new Date().toISOString()+"::mainWindow loaded")
setTimeout( () => {
mainWindow.show()
if(process.platform=MACOS){
mainWindow.reload()
}
loading.hide()
loading.close()

}, 2000)

})
console.log(port)
// long loading html
mainWindow.loadURL("http://127.0.0.1:"+port)

mainWindow.webContents.on("did-finish-load", function() {
console.log(new Date().toISOString()+"::did-finish-load")
});

mainWindow.webContents.on("did-start-load", function() {
console.log(new Date().toISOString()+"::did-start-load")
});

mainWindow.webContents.on("did-stop-load", function() {
console.log(new Date().toISOString()+"::did-stop-load")
});
mainWindow.webContents.on("dom-ready", function() {
console.log(new Date().toISOString()+"::dom-ready")
});

// Emitted when the window is closed.
mainWindow.on("closed", function () {
console.log(new Date().toISOString()+"::mainWindow.closed()")
cleanUpApplication()
})
})

loading.show()

}


function cleanUpApplication(){

app.quit()

if(childProcess){
childProcess.kill();
if(killStr != "")
child.execSync(killStr)
}
}
// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on("ready", createWindow)

// Quit when all windows are closed.
app.on("window-all-closed", function () {
console.log("EVENT::window-all-closed")
// On OS X it is common for applications and their menu bar
// to stay active until the user quits explicitly with Cmd + Q
cleanUpApplication()

})

app.on("activate", function () {
// On OS X it"s common to re-create a window in the app when the
// dock icon is clicked and there are no other windows open.
if (mainWindow === null) {
  createWindow()
}
})

// In this file you can include the rest of your app"s specific main process
// code. You can also put them in separate files and require them here.
)
'
electricShine::write_text(text = file,
                          name = "main.js",
                          path = path)


}




#' Create renderer.js file
#'
#' @param path path of where to write renderer.js
#'
#' @return nothing, writes renderer.js to path provided and provides feedback if succcessful or not
#' @export
#'
create_renderer_js <- function(path){

  file <-
    '// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.
'
  electricShine::write_text(text = file,
                            name = "renderer.js",
                            path = path)

}


#
#
#
# create_random_port <- function(){
# file <-
#  'export const randomPort = () => {
#     // Those forbidden ports are in line with shiny
#     // https://github.com/rstudio/shiny/blob/288039162086e183a89523ac0aacab824ef7f016/R/server.R#L734
#     const forbiddenPorts = [3659, 4045, 6000, 6665, 6666, 6667, 6668, 6669, 6697];
#     while (true) {
#       let port = randomInt(3000, 8000)
#       if (forbiddenPorts.includes(port))
#         continue
#       return port
#     }'
#
#
#   }



