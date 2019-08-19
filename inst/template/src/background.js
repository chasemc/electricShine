// Modules to control application life and create native browser window
const {app, BrowserWindow} = require('electron');
import jetpack from "fs-jetpack";


import path from "path";
const url = require('url');
const child = require('child_process');
const MACOS = "darwin";
const WINDOWS = "win32";

// Logto:
//Linux: ~/.config/<app name>/log.log
//macOS: ~/Library/Logs/<app name>/log.log
//Windows: %USERPROFILE%\AppData\Roaming\<app name>\log.log
const log = require('electron-log');
log.info('Application Started');

var killStr = "";


//Find and bind an open port
//Assigned port can be accesssed with srv.address().port
var net = require('net');
var srv = net.createServer(function(sock) {
  sock.end('Hello world\n');
});
srv.listen(0, function() {
  console.log('Listening on port ' + srv.address().port);
});


// folder above "bin/RScript"
var rresources = "<?<r_path>?>";

//Set environment variables for R
//Necessary for letting R know where it is/not using another R 
process.env['NODE_R_HOME'] = rresources
//Necessary for setting the R package library R uses
process.env['R_LIBS_SITE'] = path.join(rresources, "library")

//Variable of where the R executable is
//Unfortunately on MacOS paths are hardcoded into 
//Rscript but it's in binary so have to use R instead
const NODER = path.join(rresources, "bin","R");



const childProcess = child.spawn(NODER, ['-e', 'demoApp::run_app(port = '+srv.address().port+')']);


childProcess.stdout.on('data', (data) => {
 log.warn(`stdout:${data}`);
});
childProcess.stderr.on('data', (data) => {
 log.error(`stderr:${data}`);
});

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow;

function createWindow () {
  // Create the browser window.
  //  mainWindow = new BrowserWindow({webPreferences:{nodeIntegration:false},width: 800, height: 600})
  //  console.log(process.cwd())
  console.log('create-window');


    let loading = new BrowserWindow({show: false, frame: false});
    //let loading = new BrowserWindow()
    console.log(new Date().toISOString()+'::showing loading');
    // Spin loader  (Chase TODO: This is leftover, go through it with base64enc::base64decode() then rawToChar())
    loading.loadURL("data:text/html;charset=utf-8;base64,PGh0bWw+DQo8c3R5bGU+DQpib2R5ew0KICBwYWRkaW5nOiAxZW07DQogIGNvbG9yOiAjNzc3Ow0KICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogIGZvbnQtZmFtaWx5OiAiR2lsbCBzYW5zIiwgc2Fucy1zZXJpZjsNCiAgd2lkdGg6IDgwJTsNCiAgbWFyZ2luOiAwIGF1dG87DQp9DQpoMXsNCiAgbWFyZ2luOiAxZW0gMDsNCiAgYm9yZGVyLWJvdHRvbTogMXB4IGRhc2hlZDsNCiAgcGFkZGluZy1ib3R0b206IDFlbTsNCiAgZm9udC13ZWlnaHQ6IGxpZ2h0ZXI7DQp9DQpwew0KICBmb250LXN0eWxlOiBpdGFsaWM7DQp9DQoubG9hZGVyew0KICBtYXJnaW46IDAgMCAyZW07DQogIGhlaWdodDogMTAwcHg7DQogIHdpZHRoOiAyMCU7DQogIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgcGFkZGluZzogMWVtOw0KICBtYXJnaW46IDAgYXV0byAxZW07DQogIGRpc3BsYXk6IGlubGluZS1ibG9jazsNCiAgdmVydGljYWwtYWxpZ246IHRvcDsNCn0NCg0KLyoNCiAgU2V0IHRoZSBjb2xvciBvZiB0aGUgaWNvbg0KKi8NCnN2ZyBwYXRoLA0Kc3ZnIHJlY3R7DQogIGZpbGw6ICNGRjY3MDA7DQp9DQo8L3N0eWxlPg0KPGJvZHk+PCEtLSAzICAtLT4NCjxkaXYgY2xhc3M9ImxvYWRlciBsb2FkZXItLXN0eWxlMyIgdGl0bGU9IjIiPg0KICA8c3ZnIHZlcnNpb249IjEuMSIgaWQ9ImxvYWRlci0xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB4PSIwcHgiIHk9IjBweCINCiAgICAgd2lkdGg9IjgwcHgiIGhlaWdodD0iODBweCIgdmlld0JveD0iMCAwIDUwIDUwIiBzdHlsZT0iZW5hYmxlLWJhY2tncm91bmQ6bmV3IDAgMCA1MCA1MDsiIHhtbDpzcGFjZT0icHJlc2VydmUiPg0KICA8cGF0aCBmaWxsPSIjMDAwIiBkPSJNNDMuOTM1LDI1LjE0NWMwLTEwLjMxOC04LjM2NC0xOC42ODMtMTguNjgzLTE4LjY4M2MtMTAuMzE4LDAtMTguNjgzLDguMzY1LTE4LjY4MywxOC42ODNoNC4wNjhjMC04LjA3MSw2LjU0My0xNC42MTUsMTQuNjE1LTE0LjYxNWM4LjA3MiwwLDE0LjYxNSw2LjU0MywxNC42MTUsMTQuNjE1SDQzLjkzNXoiPg0KICAgIDxhbmltYXRlVHJhbnNmb3JtIGF0dHJpYnV0ZVR5cGU9InhtbCINCiAgICAgIGF0dHJpYnV0ZU5hbWU9InRyYW5zZm9ybSINCiAgICAgIHR5cGU9InJvdGF0ZSINCiAgICAgIGZyb209IjAgMjUgMjUiDQogICAgICB0bz0iMzYwIDI1IDI1Ig0KICAgICAgZHVyPSIwLjZzIg0KICAgICAgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiLz4NCiAgICA8L3BhdGg+DQogIDwvc3ZnPg0KPC9kaXY+DQo8L2JvZHk+DQo8L2h0bWw+");

    loading.once('show', () => {
      console.log(new Date().toISOString()+'::show loading');
      mainWindow = new BrowserWindow({webPreferences:{nodeIntegration:false}, show:false, width: 800, height: 600, title:""});

      mainWindow.webContents.once('dom-ready', () => {
        console.log(new Date().toISOString()+'::mainWindow loaded');
        setTimeout( () => {
          mainWindow.show();
          if(process.platform == WINDOWS){
            mainWindow.reload();
          }
          loading.hide();
          loading.close();

        }, 9000);

      });
	  
	  
      console.log(srv.address().port);
      // long loading html
      mainWindow.loadURL('http://127.0.0.1:'+srv.address().port);
      
      mainWindow.webContents.on('did-finish-load', function() {
        console.log(new Date().toISOString()+'::did-finish-load');
      });

      mainWindow.webContents.on('did-start-load', function() {
        console.log(new Date().toISOString()+'::did-start-load');
      });

      mainWindow.webContents.on('did-stop-load', function() {
        console.log(new Date().toISOString()+'::did-stop-load');
      });
      mainWindow.webContents.on('dom-ready', function() {
        console.log(new Date().toISOString()+'::dom-ready');
      });

      // Emitted when the window is closed.
      mainWindow.on('closed', function () {
        console.log(new Date().toISOString()+'::mainWindow.closed()');
        cleanUpApplication();
      });
    });

    loading.show();

}


function cleanUpApplication(){

  app.quit();
  
  if(childProcess){
    childProcess.kill();
  }
}
// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', createWindow);

// Quit when all windows are closed.
app.on('window-all-closed', function () {
  console.log('EVENT::window-all-closed');
  // On OS X it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  cleanUpApplication();

});

app.on('activate', function () {
  // On OS X it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (mainWindow === null) {
    createWindow();
  }
});

// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and require them here.
