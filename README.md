[![Build Status](https://travis-ci.org/chasemc/electricShine.svg?branch=master)](https://travis-ci.org/chasemc/electricShine)

### Introduction
The purpose of this package is to make local shiny apps. It uses electron for creating the application and for repeatability it installs both R and R packages from a single MRAN date.

It currently only builds windows apps, but support is being aded for Mac and Linux as well.

Your shiny app should be built as an R package and should list all dependencies as an R package would. It should be put on GitHub and have its own repository.

A template for desgining a shiny app as a package may be found here: https://github.com/ThinkR-open/shinytemplate


### Example
```
path <- "C:/Users/CMC/Desktop/temp")

date <- "2019-01-01"

github_package_repo <- "chasemc/IDBacApp"


# electricShine::electricShine() wraps the other functions and has three arguments:
# A path to a directory that does not contain a folder named "electricShine"
# The date from which to download R and R packages from MRAN
# Your github username and repository name in the format  "usernam/repo"  eg "tidyverse/ggplot2"


electricShine::electricShine(path = path,
                       date = date,
                       package = github_package_repo)

```

To install electricShine:

```
devtools::install_github("electricShine")

```

