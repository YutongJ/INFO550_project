#! /usr/bin/env Rscript

installed_pkgs <- row.names(installed.packages())
pkgs <- c("table1", "arsenal", "survival", "survMisc", "KMsurv", "MASS", "bookdown")
for(p in pkgs){
  if(!(p %in% installed_pkgs)){
    install.packages(p, repos = "http://cran.us.r-project.org")
  }
}

