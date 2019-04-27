
  - [![Lifecycle:
    experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

Windows CI:

  - [![Build
    status](https://ci.appveyor.com/api/projects/status/1l973ho8q4y03fnd/branch/master?svg=true)](https://ci.appveyor.com/project/chasemc/electricshine/branch/master)

Mac and Linux CI

  - [![Build
    Status](https://travis-ci.org/chasemc/electricShine.svg?branch=master)](https://travis-ci.org/chasemc/electricShine)

### Introduction

The purpose of this package is to make local shiny apps. It uses
electron for creating the application and for repeatability it installs
both R and R packages from a single MRAN date.

It currently only builds windows apps, but support is being added for
Mac and Linux as well.

Your shiny app should be built as an R package and should list all
dependencies, as an R package would.

A template for desgining a shiny app as a package may be found here:
<https://github.com/ThinkR-open/shinytemplate>

### Example

``` r
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
