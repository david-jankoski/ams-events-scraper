# run this after a fresh install (e.g. on a new machine)
# to install all needed packages.

# list of needed pkgs
pkgs <- 
  c("jsonlite",
    "tidyverse",
    "splashr",
    "DBI",
    "MonetDBLite"
  )
# install pkgs 
sapply(pkgs, install.packages, dependencies = TRUE)
