
  - [![Lifecycle:
    experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

Windows CI:

  - [![Build
    status](https://ci.appveyor.com/api/projects/status/1l973ho8q4y03fnd/branch/master?svg=true)](https://ci.appveyor.com/project/chasemc/electricshine/branch/master)

Mac and Linux CI

  - [![Build
    Status](https://travis-ci.org/chasemc/electricShine.svg?branch=master)](https://travis-ci.org/chasemc/electricShine)


### Introduction

The purpose of this package is to make local shiny apps. It uses electron for creating the application and for repeatability it installs both R and R packages from a single MRAN date.

It currently only builds windows apps, but support is being added for Mac and Linux as well.

Your shiny app should be built as an R package and should list all dependencies, as an R package would. 

A template for designing a shiny app as a package may be found here: https://github.com/ThinkR-open/shinytemplate


### Security

It is your responsibility to make sure you are not causing malicious activity through your shiny app.
Below is an excerpt from https://electronjs.org/docs/tutorial/security and I **highly** recommend you go to the link and read the rest.



>When working with Electron, it is important to understand that Electron is not a web browser. It allows you to build feature-rich desktop applications with familiar web technologies, but your code wields much greater power. JavaScript can access the filesystem, user shell, and more. This allows you to build high quality native applications, but the inherent security risks scale with the additional powers granted to your code.

>With that in mind, be aware that displaying arbitrary content from untrusted sources poses a severe security risk that Electron is not intended to handle. In fact, the most popular Electron apps (Atom, Slack, Visual Studio Code, etc) display primarily local content (or trusted, secure remote content without Node integration) – if your application executes code from an online source, it is your responsibility to ensure that the code is not malicious.



`{electricShine}` uses renovatebot.com to help automatically update npm (the CRAN of javascript) dependency versions in `package.json` but, as I am a poor PhD student with limited time, it is ultimately your responsility that it contains the latest versions.



### Instructions


Please see the "Basic Use" vignette for instructions.

An example app structured for use with `{electricShine}` can be found at https://github.com/chasemc/demoApp; includes continuous deployment using AppVeyor.


### Main Function

```{r}
installTo <- tempdir()
MRANdate <- as.character(Sys.Date() - 3)


electricShine::buildElectricApp(
appName = "My_App",
description = "My demo application",
packageName = "demoApp",
semanticVersion = "1.0.0",
installTo = installTo,
MRANdate = MRANdate,
functionName = "run_app",
githubRepo = "chasemc/demoApp",
localPath  = NULL,
only64 = TRUE
)
```
  
  
  
## Continuous Deployment (CD)

One of the main reasons I wrote this package was to allow easy CD, and `{electricShine}` is currently being used for this. I hope to write more on this later. 
