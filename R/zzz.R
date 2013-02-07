.onLoad <- function(libname, pkgname, ...) {
  packageStartupMessage("Welcome to rgexf v", packageDescription("rgexf")$Version)
  packageStartupMessage("\nFor more information on the prohect please visit")
  packageStartupMessage("\thttp://www.bitbucket.org/gvegayon/rgexf")
  packageStartupMessage("\thttp://www.nodoschile.org")
  packageStartupMessage("\nFor questions or bugs reports: <george.vega@nodoschile.org>")
}

.onLoad()