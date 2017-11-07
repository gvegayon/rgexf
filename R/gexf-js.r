
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
  # file.remove(paste(path, "config.js.template", sep="/"))
  # file.remove(paste(path, "README.md", sep="/"))
  
}

#' @rdname plot.gexf
#' @param config List of parameters to be written in \code{config.js}.
#' @export
gexf_js_make_config <- function(
  dir,
  graphFile = "network.gexf",
  config = list(
    showEdges            = "true",
    useLens              = "false",
    zoomLevel            = "0",
    curvedEdges          = "true",
    edgeWidthFactor      = "1",
    minEdgeWidth         = "1",
    maxEdgeWidth         = "50",
    textDisplayThreshold = "9",
    nodeSizeFactor       = "1",
    replaceUrls          = "true",
    showEdgeWeight       = "true",
    showEdgeLabel        = "true",
    sortNodeAttributes   = "true",
    showId               = "true",
    showEdgeArrow        = "true",
    language             = "false"
  )
) {
  
  doc <- readLines(system.file("gexf-js/config.js.template", package="rgexf"))
  
  # Validating language
  if (config$language != "false" && !(config$language %in% gexf_js_languages))
    stop("The specified language is not available. See ?gexf_js")
  
  # Name of the graph file
  doc <- gsub("$graphFile$", paste0("\"", graphFile, "\""), doc, fixed = TRUE)
  
  # Parameters
  for (p in names(config))
    doc <- gsub(paste0("$",p,"$"), config[[p]], doc, fixed = TRUE)
  
  write(doc, file = paste0(dir,"/config.js"))
  
}

#' Visualizing GEXF graph files using gexf-js
#' 
#' Using the gexf-js, a JavaScript GEXF viewer, this function allows you to
#' visualize your GEXF on the browser. The function essentially copies a template
#' website, the GEXF file, and sets up a configuration file. By default, the
#' function then starts a webserver using the \code{servr} R package.
#' 
#' @param x An object of class \code{gexf}.
#' @param y Ignored.
#' @param graphFile Name of the gexf file.
#' @param dir Directory where the files will be copied (tempdir() by default).
#' @param ... Further arguments passed to \code{gexf_js_make_config}
#' @param httd.args Further arguments to be passed to \code{\link[servr:httd]{httd}}
#' from the \CRANpkg{servr} package.
#' @param copy.only Logical scalar. When FALSE, the default, the function
#' will make a call to \code{servr::httd}.
#' @param overwrite Logical scalar. When \code{TRUE}, the default, the function
#' will overwrite all files copied from the template on the destination directory
#' as specified by \code{dir}.
#' 
#' @details 
#' The files are copied directly from
#' \Sexpr[results=text]{system.file("gexf-js", package="rgexf")}. And the 
#' parameters are set up by modifying the following template file:
#' \Sexpr[results=text]{system.file("gexf-js/config.js.template", package="rgexf")}
#' 
#' @export
#' @examples 
#' \dontrun{
#' 
#' path <- system.file("gexf-graphs/lesmiserables.gexf", package="rgexf")
#' graph <- read.gexf(path)
#' plot(graph)
#' 
#' }
#' 
#' @references gexf-js project website \url{https://github.com/raphv/gexf-js}.
plot.gexf <- function(
  x, 
  y         = NULL,
  graphFile    = "network.gexf",
  dir       = tempdir(),
  overwrite = TRUE,
  httd.args = list(),
  copy.only = FALSE,
  ...
  ) {
  
  # Step 1: Copy the files
  write.gexf(x, output = paste(dir, graphFile, sep="/"))
  gexf_js_install(dir, overwrite = overwrite)
  
  # Step 2: Setup file
  gexf_js_make_config(dir, graphFile, ...)
  
  # Step 4: Lunch the server
  if (!copy.only)
    servr::httd(dir)
  
}
