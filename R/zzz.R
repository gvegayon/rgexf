.onLoad <- function(libname, pkgname, ...) {
  packageStartupMessage("Welcome to rgexf V", packageDescription("rgexf")$Version,"!")
  packageStartupMessage("\nFor more information on the project please visit:")
  packageStartupMessage(" http://www.bitbucket.org/gvegayon/rgexf/")
  packageStartupMessage(" http://gexf.net/")
  packageStartupMessage(" http://www.nodoschile.org/")
  packageStartupMessage("\nFor questions or bugs reports:\n <george.vega@nodoschile.org>")
}

