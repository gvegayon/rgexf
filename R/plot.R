
# List of languajes currently supported by gexf-js
gexf_js_languages <- list(
  German = "de",
  English = "en",
  French = "fr",
  Spanish = "es",
  Italian = "it",
  Finnish = "fi",
  Turkish = "tr",
  Greek = "el",
  Dutch = "nl"
)

gexf_js_install <- function(path, overwrite = FALSE) {
  
  # Getting the folder
  gexf_js_files <- list.files(system.file("gexf-js/", package="rgexf"), full.names = TRUE)
  
  # Copying files
  file.copy(gexf_js_files, to = path, overwrite = overwrite, recursive = TRUE)
  file.remove(paste(path, "config.js.template", sep="/"))
  file.remove(paste(path, "README.md", sep="/"))

}



#' @rdname plot.gexf
#' @export
#' @param showEdges Logical scalar. Default state of the "show edges" button (nullable).
#' @param useLens Logical scalar. Default state of the "use lens" button (nullable).
#' @param zoomLevel Numeric scalar. Default zoom level. At zoom = 0, the graph
#' should fill a 800x700px zone
#' @param curvedEdges Logical scalar. False for curved edges, true for straight
#' edges this setting can't be changed from the User Interface.
#' @param edgeWidthFactor Numeric scalar. Change this parameter for wider or
#' narrower edges this setting can't be changed from the User Interface.
#' @param minEdgeWidth Numeric scalar.
#' @param maxEdgeWidth Numeric scalar.
#' @param textDisplayThreshold Numeric scalar.
#' @param nodeSizeFactor Numeric scalar. Change this parameter for smaller or
#' larger nodes this setting can't be changed from the User Interface.
#' @param replaceUrls Logical scalar. Enable the replacement of Urls by
#' Hyperlinks this setting can't be changed from the User Interface.
#' @param showEdgeWeight Logical scalar. Show the weight of edges in the list
#' this setting can't be changed from the User Interface.
#' @param showEdgeLabel Logical scalar. 
#' @param sortNodeAttributes Logical scalar. Alphabetically sort node attributes.
#' @param showId Logical scalar. Show the id of the node in the list
#' this setting can't be changed from the User Interface.
#' @param showEdgeArrow Logical scalar. Show the edge arrows when the edge is
#' directed this setting can't be changed from the User Interface.
#' @param language Either `FALSE`, or a character scalar with any of the
#' supported languages.
#' 
#' @details 
#' Currently, the only languages supported are: 
#' German (de), English (en), French (fr), Spanish (es), Italian (it),
#' Finnish (fi), Turkish (tr), Greek (el), Dutch (nl)
#'  
gexf_js_config <- function(
  dir,
  graphFile            = "network.gexf",
  showEdges            = TRUE,
  useLens              = FALSE,
  zoomLevel            = 0,
  curvedEdges          = TRUE,
  edgeWidthFactor      = 1,
  minEdgeWidth         = 1,
  maxEdgeWidth         = 50,
  textDisplayThreshold = 9,
  nodeSizeFactor       = 1,
  replaceUrls          = TRUE,
  showEdgeWeight       = TRUE,
  showEdgeLabel        = TRUE,
  sortNodeAttributes   = TRUE,
  showId               = TRUE,
  showEdgeArrow        = TRUE,
  language             = FALSE
  
) {
  
  doc <- readLines(system.file("gexf-js/config.js.template", package="rgexf"))

  # Getting the name of the environment  
  env    <- environment()

  # Validating parameters ------------------------------------------------------
  if (!is.logical(language) && !(language %in% gexf_js_languages))
    stop("The specified language is not available. See ?gexf_js")
  else if (is.logical(language) && !language)
    language <- "false"
  else if (!is.logical(language))
    language <- paste0("\"", language, "\"")
  
  # Logical values
  bool <- c("curvedEdges", "replaceUrls", "showEdgeWeight",
               "showEdgeLabel", "sortNodeAttributes", "showId", "showEdgeArrow")
  
  for (p in bool) {
    if (!is.logical(env[[p]])) stop("The parameter -", p,"- should be logical scalar.")
    env[[p]] <- if (env[[p]]) "true" else "false"
  }
  
  # Nullable
  null <- c("showEdges", "useLens")
  
  for (p in null) {
    if (!length(env[[p]])) {
      env[[p]] <- "null"
    } else if (!is.logical(env[[p]])) stop("The parameter -", p,"- should be logical scalar or NULL.")
    else
      env[[p]] <- if (env[[p]]) "true" else "false"
  }
    
  # Numeric values
  num  <- c("zoomLevel", "edgeWidthFactor", "minEdgeWidth", "maxEdgeWidth",
            "textDisplayThreshold", "nodeSizeFactor")
  
  for (p in num) {
    env[[p]] <- as.character(env[[p]])
    if (is.na(env[[p]])) stop("The parameter -", p,"- should be numeric.")
  }
  
  # Writing parameters in the template -----------------------------------------
  
  # Name of the graph file
  doc <- gsub("$graphFile$", paste0("\"", graphFile, "\""), doc, fixed = TRUE)
  
  # Parameters
  for (p in c(bool, num, null, "language"))
    doc <- gsub(paste0("$",p,"$"), get(p), doc, fixed = TRUE)
  
  # Writing the file -----------------------------------------------------------
  write(doc, file = paste0(dir,"/config.js"))
  
}

#' Visualizing GEXF graph files using gexf-js
#' 
#' Using the gexf-js, a JavaScript GEXF viewer, this function allows you to
#' visualize your GEXF on the browser. The function essentially copies a template
#' website, the GEXF file, and sets up a configuration file. By default, the
#' function then starts a webserver using the `servr` R package.
#' 
#' @param x An object of class `gexf`.
#' @param y Ignored.
#' @param graphFile Name of the gexf file.
#' @param dir Directory where the files will be copied (tempdir() by default).
#' @param ... Further arguments passed to `gexf_js_config`
#' @param httd.args Further arguments to be passed to [servr::httd]
#' from the \CRANpkg{servr} package.
#' @param copy.only Logical scalar. When FALSE, the default, the function
#' will make a call to `servr::httd`.
#' @param overwrite Logical scalar. When `TRUE`, the default, the function
#' will overwrite all files copied from the template on the destination directory
#' as specified by `dir`.
#' 
#' @details 
#' 
#' An important thing for the user to consider is the fact that the function
#' only works if there are `viz` attributes, this is, color, size, and position.
#' If the [gexf] object's XML document does not have viz attributes, users can
#' use the following hack:
#' 
#' ```
#' # Turn the object ot igraph and go back
#' x <- igraph.to.gexf(gexf.to.igraph(x))
#' 
#' # And you are ready to plot!
#' plot(x)
#' ```
#' 
#' More details on this in the [igraph.to.gexf] function.
#' 
#' The files are copied directly from the path indicated by
#' `system.file("gexf-js", package="rgexf")`. And the 
#' parameters are set up by modifying the following template file stored under
#' the `gexf-js/config.js.template` (see the output from 
#' `system.file("gexf-js/config.js.template", package="rgexf")` to see the
#' path to the template file).
#' 
#' The server is lunched if and only if `interactive() == TRUE`.
#' 
#' @export
#' @examples 
#' if (interactive()) {
#' 
#' path <- system.file("gexf-graphs/lesmiserables.gexf", package="rgexf")
#' graph <- read.gexf(path)
#' plot(graph)
#' 
#' }
#' 
#' @references
#' gexf-js project website https://github.com/raphv/gexf-js.
#' 
plot.gexf <- function(
  x, 
  y         = NULL,
  graphFile = "network.gexf",
  dir       = tempdir(),
  overwrite = TRUE,
  httd.args = list(),
  copy.only = FALSE,
  ...
  ) {

  # Step 0: Check for viz attributes
  if (any(grepl("^\\s*<viz:position", x$graph)))
    warning("No position viz attribute found. The graph may not be drawn (see ?plot.gexf.)")

  # Step 1: Copy the files
  write.gexf(x, output = paste(dir, graphFile, sep="/"))
  gexf_js_install(dir, overwrite = overwrite)
  
  # Step 2: Setup file
  gexf_js_config(dir, graphFile, ...)
  
  # Step 3: Lunch the server (if needed)
  if (interactive() && !copy.only)
    do.call(servr::httd, c(list(dir = dir), httd.args))
  
}
