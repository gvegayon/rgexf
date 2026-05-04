
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



#' @rdname plot_gexfjs
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

#' Visualizing GEXF graphs using sigma.js (default) or gexf-js
#'
#' `plot.gexf` renders a `gexf` object as an interactive sigma.js htmlwidget.
#' For the legacy gexf-js file-server approach, use [plot_gexfjs].
#'
#' @param x An object of class `gexf`.
#' @param y Ignored.
#' @param width,height Widget dimensions in pixels (or `NULL` for automatic).
#' @param ... Ignored (kept for S3 compatibility).
#'
#' @details
#' `plot.gexf` delegates to [sigmajs], which produces an htmlwidget powered by
#' [sigma.js](https://www.sigmajs.org/).  Node positions, colours, and sizes
#' are read directly from the GEXF `viz:*` attributes, so the graph must
#' contain them.  If they are absent you can round-trip through igraph:
#'
#' ```r
#' x <- igraph.to.gexf(gexf.to.igraph(x))
#' plot(x)
#' ```
#'
#' @export
#' @examples
#' if (interactive()) {
#'   path <- system.file("gexf-graphs/lesmiserables.gexf", package = "rgexf")
#'   graph <- read.gexf(path)
#'   plot(graph)
#' }
#'
#' @seealso [sigmajs()], [plot_gexfjs()]
plot.gexf <- function(x, y = NULL, width = NULL, height = NULL, ...) {
  sigmajs(x, width = width, height = height, ...)
}

#' Visualizing GEXF graph files using gexf-js (legacy)
#'
#' Uses the gexf-js JavaScript viewer by copying static files to a directory
#' and optionally launching a local web server via the `servr` package.  For
#' the modern htmlwidget-based renderer, use [plot.gexf] or [sigmajs].
#'
#' @param x An object of class `gexf`.
#' @param graphFile Name of the GEXF file written to `dir`.
#' @param dir Directory where files are copied (`tempdir()` by default).
#' @param overwrite Logical scalar. Overwrite existing files in `dir`.
#' @param httd.args Further arguments passed to [servr::httd].
#' @param copy.only Logical. When `TRUE`, skip launching the server.
#' @param ... Further arguments passed to [gexf_js_config].
#'
#' @details
#' The server is launched only when `interactive() == TRUE` and
#' `copy.only == FALSE`.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   path <- system.file("gexf-graphs/lesmiserables.gexf", package = "rgexf")
#'   graph <- read.gexf(path)
#'   plot_gexfjs(graph)
#' }
#'
#' @references
#' gexf-js project website <https://github.com/raphv/gexf-js>.
plot_gexfjs <- function(
  x,
  graphFile = "network.gexf",
  dir       = tempdir(),
  overwrite = TRUE,
  httd.args = list(),
  copy.only = FALSE,
  ...
) {

  if (!any(grepl("<viz:position", x$graph)))
    warning("No viz:position attribute found. The graph may not be drawn (see ?plot_gexfjs).")

  write.gexf(x, output = paste(dir, graphFile, sep = "/"))
  gexf_js_install(dir, overwrite = overwrite)
  gexf_js_config(dir, graphFile, ...)

  if (interactive() && !copy.only)
    do.call(servr::httd, c(list(dir = dir), httd.args))
}

#' Interactive graph viewer powered by sigma.js
#'
#' Creates an htmlwidget that renders a GEXF graph using
#' [sigma.js](https://www.sigmajs.org/) v3 and
#' [graphology](https://graphology.github.io/).  Node positions, colours, and
#' sizes are read from the `viz:*` attributes embedded in the GEXF document.
#' Nodes are drawn with a thin border ring whose colour is controlled by
#' `borderColor`.
#'
#' @param gexf Either a `gexf` object, or a path to a `.gexf` file.  Defaults
#'   to the bundled Les Misérables example.
#' @param width,height Widget dimensions in pixels (`NULL` for automatic).
#' @param borderColor A CSS colour string for the node border ring.  Defaults
#'   to `NULL` (no border — sigma.js's default plain filled circle).  Set to
#'   a colour such as `"#ffffff"` to add a ring.
#' @param borderSize Border ring thickness as a fraction of the node radius
#'   (0–1).  Only used when `borderColor` is set.  Defaults to `0.15` (15 %).
#'
#' @return An htmlwidget object.
#' @export
#' @import htmlwidgets
#' @examples
#' if (interactive()) {
#'   path <- system.file("gexf-graphs/lesmiserables.gexf", package = "rgexf")
#'   sigmajs(path)
#'
#'   # White border ring
#'   sigmajs(path, borderColor = "#ffffff", borderSize = 0.15)
#' }
sigmajs <- function(
  gexf        = system.file("gexf-graphs/lesmiserables.gexf", package = "rgexf"),
  width       = NULL,
  height      = NULL,
  borderColor = NULL,
  borderSize  = 0.15
) {

  if (inherits(gexf, "gexf")) {
    gexf_data <- paste(gexf$graph, collapse = "\n")
  } else {
    # Disallow URL schemes to prevent SSRF
    if (grepl("^[a-zA-Z]+://", gexf))
      stop("URLs are not allowed for the 'gexf' argument")
    path      <- normalizePath(gexf, mustWork = TRUE)
    gexf_data <- paste(readLines(path, warn = FALSE), collapse = "\n")
  }

  if (length(borderColor) && is.na(borderColor)) borderColor <- NULL

  htmlwidgets::createWidget(
    "sigmajs",
    list(
      data        = gexf_data,
      borderColor = borderColor,
      borderSize  = borderSize
    ),
    width        = width,
    height       = height,
    package      = "rgexf",
    sizingPolicy = htmlwidgets::sizingPolicy(
      defaultWidth  = "100%",
      defaultHeight = 450,
      viewer.fill   = TRUE,
      browser.fill  = TRUE,
      knitr.figure  = FALSE,
      knitr.defaultWidth  = "100%",
      knitr.defaultHeight = 450
    )
  )
}

#' @rdname sigmajs
#' @param outputId Shiny output ID.
#' @export
sigmajsOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "sigmajs", width, height, package = "rgexf")
}

#' @rdname sigmajs
#' @param expr An expression that returns a `sigmajs` widget.
#' @param env The environment in which to evaluate `expr`.
#' @param quoted Logical scalar. Is `expr` a quoted expression?
#' @export
renderSigmajs <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) }
  htmlwidgets::shinyRenderWidget(expr, sigmajsOutput, env, quoted = TRUE)
}

#' Interactive graph viewer powered by gexf-js
#'
#' Creates an htmlwidget that renders a GEXF file using the bundled gexf-js
#' library.
#'
#' @param gexf Path to a `.gexf` file. Defaults to the bundled Les Miserables
#'   example.
#' @param width,height Widget dimensions in pixels (`NULL` for automatic).
#'
#' @return An htmlwidget object.
#' @import htmlwidgets
#' @export
gexfjs <- function(
  gexf   = system.file("gexf-graphs/lesmiserables.gexf", package="rgexf"),
  width  = NULL,
  height = NULL
  ) {

  # Disallow URL schemes to prevent SSRF
  if (grepl("^[a-zA-Z]+://", gexf))
    stop("URLs are not allowed for 'gexf' argument")

  # Restrict gexf to a known safe directory
  path <- normalizePath(gexf, mustWork = TRUE)

  # Read GEXF content to inline in the widget
  gexf_data <- paste(readLines(path, warn = FALSE), collapse = "\n")

  # Read all GexfJS library files to bundle into the isolated iframe
  lib <- function(...) {
    p <- system.file("htmlwidgets/lib/gexfjs", ..., package = "rgexf")
    paste(readLines(p, warn = FALSE), collapse = "\n")
  }

  x <- list(
    data   = gexf_data,
    jquery = lib("js", "jquery-2.0.2.min.js"),
    jqmw   = lib("js", "jquery.mousewheel.min.js"),
    jqui   = lib("js", "jquery-ui-1.10.3.custom.min.js"),
    gexfjs = lib("js", "gexfjs.js"),
    setup  = lib("setup.js"),
    css1   = lib("styles", "gexfjs.css"),
    css2   = lib("styles", "jquery-ui-1.10.3.custom.min.css")
  )

  # create the widget
  htmlwidgets::createWidget(
    "gexfjs", x, width = width, height = height, package="rgexf")

}

#' @rdname gexfjs
#' @param outputId Shiny output ID.
#' @export
gexfjsOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "gexfjs", width, height, package = "rgexf")
}
#' @rdname gexfjs
#' @param expr An expression that returns a `gexfjs` widget.
#' @param env The environment in which to evaluate `expr`.
#' @param quoted Logical scalar. Is `expr` a quoted expression?
#' @export
renderGexfjs <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, gexfjsOutput, env, quoted = TRUE)
}
