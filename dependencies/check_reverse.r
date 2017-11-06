# This script checks whether DiagrammeR works as expected with 
# the development version of rgexf.

rm(list = ls())

# Reverse dependencies
imports <- c("DiagrammeR")

hline <- function(fn) cat("\n", paste0(rep("-", 80), collapse= ""), "\n\n", file = fn, append = TRUE)

# Download and check
install_and_check <- function(pkgs, loc) {
  
  # Cleaning the mess (just in case)
  on.exit(sapply(paste(loc, pkgs, sep="/"), function(x) tryCatch(unlink(x, recursive = TRUE, force=TRUE))))
  
  # Installing and checking
  for (pkg in pkgs) {
    
    # Downloading git
    message("Cloning into cran/", pkg)
    
    system(sprintf("rm -r -f %s/%s", loc, pkg))
    system(sprintf("git clone https://github.com/cran/%s.git %s/%s", pkg, loc, pkg))
    
    # Checking dependencies
    depends <- yaml::yaml.load_file(sprintf("%s/%s/DESCRIPTION", loc, pkg))
    
    # Creating output file
    outfile <- sprintf("dependencies/%s_%s.log", pkg, depends$Version)
    unlink(outfile)
    hline(outfile)
    write(
      c(
        sprintf("Checking the R package %s version %s", pkg, depends$Version),
        sprintf("rgexf version %s", yaml::yaml.load_file("DESCRIPTION")$Version),
        as.character(Sys.time())
      ), file = outfile, append = TRUE, sep="\n")
    hline(outfile)
    
    depends <- unlist(depends[c("Imports", "LinksTo", "Depends", "Suggests")], recursive = TRUE)
    depends <- stringr::str_split(depends, ",\\s*", simplify = TRUE)
    depends <- depends[!grepl("^(R|rgexf)\\s+.+", depends) & depends != ""]
    depends <- stringr::str_extract(depends, "[a-zA-Z0-9_]+")
    
    message("This package depends on:\n", paste(depends, collapse = ", "))
    message("Initializing installation...")
    
    # Installing (and removing) dependencies
    INSTALLED <- installed.packages()
    depends <- depends[!(depends %in% INSTALLED)]
    if (length(depends)) {
      on.exit(remove.packages(depends))
      install.packages(depends, Ncpus = 4, quiet = TRUE)
    }
    
    # Building and checking
    message("Building and checking...")
    cmd <- sprintf("cd %s && R CMD build %s && \\
                   R CMD check --no-manual --no-build-vignettes --no-stop-on-test-error %s*.tar.gz", loc, pkg, pkg)
    
    write(system(cmd, intern = TRUE), file = outfile, append = TRUE, sep = "\n")
    
    
  }
}

CHECKDIR <- tempdir()
install_and_check(imports, CHECKDIR)
