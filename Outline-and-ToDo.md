Outline/Todo
================
Chase Clark
March 6, 2019

### Install Dependencies

Wrapper function that calls separate functions to install the following
dependencies that must be installed once, or use FUN(force = TRUE) to
re-install/update

1.  node.js (platform-dependent installation)
      - see: getOS.R
      - see: getNodejs.R
2.  npm install electron
3.  npm install electron-packager
      - see getElectronPackager.R

### Download R

Download os-dependant R from MRAN… FUN(date = yyy-mm-dd)

  - Date format conforms to MRAN
        url:
      - <https://cran.microsoft.com/snapshot/2018-08-01/bin/windows/base/R-3.5.1-win.exe>
  - see: installR.R Strip unnecessary things from R: (e.g. html, pdf)
  - see: trim\_r.R

### Setup electron app

  - User specifies where to create the app.
      - FUN(dir = …) Create top-level directory for the app
          - see: directoryTemplate.R
          - I don’t think this part was working but I don’t remember.
              - The written files need to be like those in inst/template

Important file: \***package.json**

  - For info on this see:
    <https://nodesource.com/blog/the-basics-of-package-json-in-node-js-and-npm/>

Important parts of package.json

  - “name”:
      - This is the app’s name
  - “version”:
      - semantic version \# of app
  - “description”:
      - app description
  - “main”: “main.js”,
      - specifies the js file to be used
  - “scripts”:
      - contains the electron build functions: package-mac, package-win,
        package-linux
      - These specify the OS-specific build configurations for electron
        packager
      - They also take the icon argument `--icon=`
        (e.g. glue::glue(…{iconPath}…))
      - And the out-directory where the electron app will be built to
  - “repository”:
      - Repository of the app: should be optional
  - “keywords”:
      - should be optional
  - “author”:
      - app authors
  - “license”
      - app license
  - “devDependencies”:
      - “electron”: - version of “electron”: “^4.0.3”
          - current version is 4.0.7

Important file: \***main.js**

  - js that runs when the electron app is started.
  - Calls Rscript and starts the app.
      - R part:
          - `childProcess = child.spawn(execPath, ["-e",
            "shiny::runApp(file.path('"+appPath+"'), port="+port+")"])`
          - Currently the port is static, it would be nice for it to be
            dynamic

### Main Wrapper

User calls one function and all the things happen

see: metaFunction.R

Need to add runBuild.R to the wrapper, also make runBuild (and
everything) cross-platform goodness
