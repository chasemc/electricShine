[![Lifecycle:
    experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Build
    status](https://ci.appveyor.com/api/projects/status/1l973ho8q4y03fnd/branch/master?svg=true)](https://ci.appveyor.com/project/chasemc/electricshine/branch/master)
[![Build
    Status](https://travis-ci.org/chasemc/electricShine.svg?branch=master)](https://travis-ci.org/chasemc/electricShine)

# electricShine  <img src="man/figures/logo.png" align="right" alt="" width="120" />

# Purpose

Sometimes an R Shiny app is too resource-intensive, or otherwise resticted, to be deployed into the cloud. Along with this, it can be non-trivial for someone inexperienced with R, or programming in general, to install R and open your Shiny app. 

For these reasons it is desireable to be able to create a Shiny app that can be opened like a "regular" computer application, preferably from a Desktop shortcut. This is the purpose of  `{electricShine}` and what it will do with your Shiny app.


# High-Level Overview

`{electricShine}` is based on [Electron](https://electronjs.org) which is a well-used and supported framework for creating desktop applications, usually using just javascript, html and css.

Repeatability of creating these desktop apps is a priority of `{electricShine}`, and to help with this it installs both R and R packages from a single MRAN date.

It currently only builds windows apps, but I'm investiging adding support for Mac and Linux as well. That is quite a bit harder because the R installation for Mac and Linux hard-codes paths into the installation and part of the benefit of `{electricShine}` is not relying on the system's version of R https://community.rstudio.com/t/is-r-on-mac-portable/36642/8 


# Security

It is your responsibility to make sure you are not causing malicious activity through your shiny app.
Below is an excerpt from https://electronjs.org/docs/tutorial/security and I **highly** recommend you go to the link and read the rest.



>When working with Electron, it is important to understand that Electron is not a web browser. It allows you to build feature-rich desktop applications with familiar web technologies, but your code wields much greater power. JavaScript can access the filesystem, user shell, and more. This allows you to build high quality native applications, but the inherent security risks scale with the additional powers granted to your code.

>With that in mind, be aware that displaying arbitrary content from untrusted sources poses a severe security risk that Electron is not intended to handle. In fact, the most popular Electron apps (Atom, Slack, Visual Studio Code, etc) display primarily local content (or trusted, secure remote content without Node integration) – if your application executes code from an online source, it is your responsibility to ensure that the code is not malicious.



`{electricShine}` uses renovatebot.com to help automatically update npm (the CRAN of javascript) dependency versions in `package.json` but, as I am a poor PhD student with limited time, it is ultimately your responsility that it contains the latest versions.



# Getting Started

Your shiny app should be built as an R package and should list all dependencies, as an R package would. 

A template for designing a shiny app as a package may be found here: https://github.com/ThinkR-open/shinytemplate


Important: your package must contain a function that electricShine can use to start your app. This function must contain an argument `port` to be passed to `shiny::shinyApp`. The easiest thing to do would be to modify the example below (change `demoApp` to your package name). 
```{r}
# Example for an R package named `demoApp`:

run_app <- function(port = NULL) {
  
  if (is.null(port)) {
    shiny::shinyApp(ui = demoApp::app_ui(),
                    server = demoApp::app_server)
  } else {
    port <- try(as.integer(port))
    if (is.integer(port) && port > 0L) {
      shiny::shinyApp(ui = demoApp::app_ui(),
                      server = demoApp::app_server,
                      options = list(port = port))
    }
  }
  
}

```


An example app structured for use with `{electricShine}` can be found at https://github.com/chasemc/demoApp; includes continuous deployment using AppVeyor.


# Main Function

```{r}
installTo <- tempdir()
MRANdate <- as.character(Sys.Date() - 3)


electricShine::buildElectricApp(
appName = "My_App",                  # This is what the app/desktop shortcuts will be named on installation.
description = "My demo application", # Short description when installer is run, etc.
packageName = "demoApp",             # The name of the R package that contains your shiny app.
semanticVersion = "1.0.0",           # You app's version
installTo = installTo,               # Where the app will build to on your computer.
MRANdate = MRANdate,                 # The MRAN snapshot date R and R packages will be downloaded from.
functionName = "run_app",            # The function name in your app that starts your shiny app.
githubRepo = "chasemc/demoApp",      # GitHub of your R package
localPath  = NULL,                   # Alternate to GitHub you can use an R package at a local path
only64 = TRUE                        # Set to TRUE, this will be deprecated.
)
```
Please see the "Basic Use" vignette for further instructions.

  
# Continuous Deployment (CD)

One of the main reasons I wrote this package was to allow easy CD, and `{electricShine}` is currently compatible with CD. I hope to write more on this later.



# Packages/Shiny Apps Using `{electricShine}`

- https://github.com/chasemc/IDBacApp
- https://github.com/chasemc/demoApp
- https://github.com/chasemc/processView

