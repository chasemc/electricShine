// Modules to control application life and create native browser window
const {
  app,
  BrowserWindow
} = require('electron');
import jetpack from "fs-jetpack";


import path from "path";
const url = require('url');
const child = require('child_process');
const MACOS = "darwin";
const WINDOWS = "win32";
const fs = require('fs');

// Logto:
//Linux: ~/.config/<app name>/log.log
//macOS: ~/Library/Logs/<app name>/log.log
//Windows: %USERPROFILE%\AppData\Roaming\<app name>\log.log
const log = require('electron-log');
log.info('Application Started');



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
if (process.platform == WINDOWS) {
  var rresources = path.join(app.getAppPath() + 'app' + 'r_lang');
}


if (process.platform == MACOS) {
  var rver = fs.readdirSync(path.join(app.getAppPath(), 'app', 'r_lang', "Library", "Frameworks", "R.framework", "Versions")).filter(fn => fn.match(/\d+\.(?:\d+|x)(?:\.\d+|x){0,1}/g));
  var rresources = path.join(app.getAppPath(), 'app', 'r_lang', "Library", "Frameworks", "R.framework", "Versions", rver.toString(), 'Resources');

}


//Set environment variables for R
//Necessary for letting R know where it is and ensure we're not using another R 
process.env.NODE_R_HOME = rresources;
//Necessary for setting the R package library R uses
process.env.R_LIBS_SITE = path.join(rresources, "library");

//Variable of where the R executable is
//Unfortunately on MacOS paths are hardcoded into 
//Rscript but it's in binary so have to use R instead
const NODER = path.join(rresources, "bin", "R");

const childProcess = child.spawn(NODER, ['-e', '<?<R_SHINY_FUNCTION>?>(port = ' + srv.address().port + ')']);

// Log outputs from the R process
childProcess.stdout.on('data', (data) => {
  log.warn(`stdout:${data}`);
});
childProcess.stderr.on('data', (data) => {
  log.error(`stderr:${data}`);
});
childProcess.on('exit', (code) => {
  console.log(`Child exited with code ${code}`);
});

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow;

function createWindow() {
  // Create the browser window.
  //  mainWindow = new BrowserWindow({webPreferences:{nodeIntegration:false},width: 800, height: 600})
  //  console.log(process.cwd())
  console.log('create-window');


  let mainWindow = new BrowserWindow({
    webPreferences: {
      nodeIntegration: false
    },
    show: false,
    width: 800,
    height: 600,
    title: ""
  });

// reload every 3s until app is actually connected
  var reloadTime = 3000
  var iterations = 10

  var i = 1; 
  function myLoop() { //  create a loop function
    setTimeout(function() { //  call a 3s setTimeout when the loop is called
      mainWindow.webContents.executeJavaScript('window.Shiny.shinyapp.isConnected()', true)
        .catch(function(result) {
          console.log(result) // Will be the JSON object from the fetch call

          mainWindow.loadURL('http://127.0.0.1:' + srv.address().port);

        })
      i++;
      //  increment the counter
      if (i < iterations) { //  if the counter < 10, call the loop function
        myLoop(); //  ..  again which will trigger another 
      } //  ..  setTimeout()
    }, reloadTime)
  }

  myLoop()

  mainWindow.loadURL('http://127.0.0.1:' + srv.address().port);


  mainWindow.webContents.on('did-finish-load', function() {
    console.log(new Date().toISOString() + '::did-finish-load');
  });

  mainWindow.webContents.on('did-start-load', function() {
    console.log(new Date().toISOString() + '::did-start-load');
  });

  mainWindow.webContents.on('did-stop-load', function() {
    console.log(new Date().toISOString() + '::did-stop-load');
  });
  mainWindow.webContents.on('dom-ready', function() {
    console.log(new Date().toISOString() + '::dom-ready');
  });

  // Emitted when the window is closed.
  mainWindow.on('closed', function() {
    console.log(new Date().toISOString() + '::mainWindow.closed()');
    cleanUpApplication();
  });

  mainWindow.show();
}


function cleanUpApplication() {

  app.quit();

  if (childProcess) {
    childProcess.kill();
  }
}
// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', createWindow);

// Quit when all windows are closed.
app.on('window-all-closed', function() {
  console.log('EVENT::window-all-closed');
  // On OS X it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  cleanUpApplication();

});

app.on('activate', function() {
  // On OS X it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (mainWindow === null) {
    createWindow();
  }
});


// The things below haven't yet been implemented



//MIT License
//
//Copyright (c) 2016 Joseph T. Lapp
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and //associated documentation files (the "Software"), to deal in the Software without restriction, including //without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell //copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the //following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial //portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT //LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO //EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER //IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR //THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//This module has its origin in code by  @CanyonCasa at  http://stackoverflow.com/a/21947851/650894, but the //module was significantly rewritten to resolve issues raised by @Banjocat at http://stackoverflow.com///questions/14031763/doing-a-cleanup-action-just-before-node-js-exits#comment68567869_21947851. It has //also been extended for greater configurability.


//// CONSTANTS ////////////////////////////////////////////////////////////////

var DEFAULT_MESSAGES = {
  ctrl_C: '[ctrl-C]',
  uncaughtException: 'Uncaught exception...'
};

//// CONFIGURATION ////////////////////////////////////////////////////////////

var cleanupHandlers = null; // array of cleanup handlers to call
var messages = null; // messages to write to stderr

var sigintHandler; // POSIX signal handlers
var sighupHandler;
var sigquitHandler;
var sigtermHandler;

//// HANDLERS /////////////////////////////////////////////////////////////////

function signalHandler(signal) {
  var exit = true;
  cleanupHandlers.forEach(function(cleanup) {
    if (cleanup(null, signal) === false)
      exit = false;
  });
  if (exit) {
    if (signal === 'SIGINT' && messages && messages.ctrl_C !== '')
      process.stderr.write(messages.ctrl_C + "\n");
    uninstall(); // don't cleanup again
    // necessary to communicate the signal to the parent process
    process.kill(process.pid, signal);
  }
}

function exceptionHandler(e) {
  if (messages && messages.uncaughtException !== '')
    process.stderr.write(messages.uncaughtException + "\n");
  process.stderr.write(e.stack + "\n");
  process.exit(1); // will call exitHandler() for cleanup
}

function exitHandler(exitCode, signal) {
  cleanupHandlers.forEach(function(cleanup) {
    cleanup(exitCode, signal);
  });
}

//// MAIN /////////////////////////////////////////////////////////////////////

function install(cleanupHandler, stderrMessages) {
  if (cleanupHandler) {
    if (typeof cleanupHandler === 'object') {
      stderrMessages = cleanupHandler;
      cleanupHandler = null;
    }
  } else if (!stderrMessages)
    stderrMessages = DEFAULT_MESSAGES;

  if (stderrMessages) {
    if (messages === null)
      messages = {
        ctrl_C: '',
        uncaughtException: ''
      };
    if (typeof stderrMessages.ctrl_C === 'string')
      messages.ctrl_C = stderrMessages.ctrl_C;
    if (typeof stderrMessages.uncaughtException === 'string')
      messages.uncaughtException = stderrMessages.uncaughtException;
  }

  if (cleanupHandlers === null) {
    cleanupHandlers = []; // establish before installing handlers

    sigintHandler = signalHandler.bind(this, 'SIGINT');
    sighupHandler = signalHandler.bind(this, 'SIGHUP');
    sigquitHandler = signalHandler.bind(this, 'SIGQUIT');
    sigtermHandler = signalHandler.bind(this, 'SIGTERM');

    process.on('SIGINT', sigintHandler);
    process.on('SIGHUP', sighupHandler);
    process.on('SIGQUIT', sigquitHandler);
    process.on('SIGTERM', sigtermHandler);
    process.on('uncaughtException', exceptionHandler);
    process.on('exit', exitHandler);

    cleanupHandlers.push(cleanupHandler || noCleanup);
  } else if (cleanupHandler)
    cleanupHandlers.push(cleanupHandler);
}

function uninstall() {
  if (cleanupHandlers !== null) {
    process.removeListener('SIGINT', sigintHandler);
    process.removeListener('SIGHUP', sighupHandler);
    process.removeListener('SIGQUIT', sigquitHandler);
    process.removeListener('SIGTERM', sigtermHandler);
    process.removeListener('uncaughtException', exceptionHandler);
    process.removeListener('exit', exitHandler);
    cleanupHandlers = null; // null only after uninstalling
  }
}

function noCleanup() {
  return true; // signals will always terminate process
}
