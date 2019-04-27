
  [![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)


Windows CI:
- [![Build status](https://ci.appveyor.com/api/projects/status/1l973ho8q4y03fnd/branch/master?svg=true)](https://ci.appveyor.com/project/chasemc/electricshine/branch/master)

Mac and Linux CI
- [![Build Status](https://travis-ci.org/chasemc/electricShine.svg?branch=master)](https://travis-ci.org/chasemc/electricShine)

### Introduction
The purpose of this package is to make local shiny apps. It uses electron for creating the application and for repeatability it installs both R and R packages from a single MRAN date.

It currently only builds windows apps, but support is being aded for Mac and Linux as well.

Your shiny app should be built as an R package and should list all dependencies as an R package would. It should be put on GitHub and have its own repository.

A template for desgining a shiny app as a package may be found here: https://github.com/ThinkR-open/shinytemplate


### Example
```{r}
electricShine::getNodejs()
electricShine::getElectron()

path <- "C:/Users/CMC/Desktop/temp"

date <- "2019-01-01"

github_package_repo <- "chasemc/IDBacApp"


# electricShine::electricShine() wraps the other functions and has three arguments:
# A path to a directory that does not contain a folder named "electricShine"
# The date from which to download R and R packages from MRAN
# Your github username and repository name in the format  "usernam/repo"  eg "tidyverse/ggplot2"

electricShine::buildElectricApp(name = "IDBacApp",
                             description = "My Electron application",
                             productName = "productName",
                             version = "1.0.0",
                             path = path,
                             date = date,
                             package = github_package_repo)



electricShine::runBuild(nodePath = NULL,
                     npmPath = NULL,
                     appPath = "C:/Users/CMC/Desktop/temp/IDBacAp" ,
                     node = NULL)

  

```

To install electricShine:

```
devtools::install_github("electricShine")

```

