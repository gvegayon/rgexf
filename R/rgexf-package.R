gexf_version <- function(vers="1.3") {
  # List of versions
  VERS <- list(
    `1.3` = list(
      number               = "1.3",
      xmlns                = "http://www.gexf.net/1.3",
      `xsi:schemaLocation` = "http://www.gexf.net/1.3 http://www.gexf.net/1.3/gexf.xsd",
      `xmlns:vis`          = "http://www.gexf.net/1.3/viz"
    ),
    `1.2` = list(
      number               = "1.2",
      xmlns                = "http://www.gexf.net/1.2draft",
      `xsi:schemaLocation` = "http://www.gexf.net/1.2draft http://www.gexf.net/1.2draft/gexf.xsd",
      `xmlns:vis`          = "http://www.gexf.net/1.2draft/viz"
    ),
    `1.1` = list(
      number               = "1.1",
      xmlns                = "http://www.gexf.net/1.1draft",
      `xsi:schemaLocation` = "http://www.gexf.net/1.1draft http://www.gexf.net/1.1draft/gexf.xsd",
      `xmlns:vis`          = "http://www.gexf.net/1.1draft/viz"
    )
  )
  
  # Checking length
  
  
  if (vers %in% names(VERS)) {
    VERS[[vers]] 
  } else {
    stop("version GEXF ",vers," not supported. Currently supported are: ",
         paste(names(VERS), collapse=", "))
  }
}

#' @importFrom XML xmlTreeParse xmlNode addChildren asXMLNode saveXML newXMLDoc
#'  newXMLNode newXMLNamespace xmlAttrs parseXMLAndAdd
#' @importFrom igraph get.data.frame list.vertex.attributes list.edge.attributes
#'   E is.directed V set.vertex.attribute set.edge.attribute
#' @importFrom grDevices rgb col2rgb colors
#' @importFrom utils head
#' @importFrom servr httd
#' @importFrom stats complete.cases
NULL

#' Edge list with attributes
#' 
#' Sample of accounts by december 2011.
#' 
#' 
#' @name followers
#' @docType data
#' @format A data frame containing 6065 observations.
#' @source Fabrega and Paredes (2012): \dQuote{La politica en 140 caracteres}
#' en Intermedios: medios de comunicacion y democracia en Chile. Ediciones UDP
#' @keywords datasets
NULL





#' S3 methods for \code{gexf} objects
#' 
#' Methods to print and summarize \code{gexf} class objects
#' 
#' \code{print.gexf} displays the graph (XML) in the console. If \code{file} is
#' not \code{NA}, a GEXF file will be exported to the indicated filepath.
#' 
#' \code{summay.gexf} prints summary statistics and information about the
#' graph.
#' 
#' 
#' @aliases print.gexf export-gexf summary.gexf
#' @param x An \code{gexf} class object.
#' @param object An \code{gexf} class object.
#' @param file String. Output path where to save the GEXF file.
#' @param replace Logical. If \code{file} exists, \code{TRUE} would replace the
#' file.
#' @param \dots Ignored
#' @return \item{list("print.gexf")}{ None (invisible \code{NULL}).}
#' \item{list("summary.gexf")}{ List containing some \code{gexf} object
#' statistics.} 
#' 
#' @author George G. Vega Yon 
#' 
#' Joshua B. Kunst 
#' @seealso See also \code{\link{write.gexf}}, \code{\link{plot.gexf}}
#' @keywords methods
#' @examples
#' 
#'   if (interactive()) {
#'     # Data frame of nodes
#'     people <- data.frame(id=1:4, label=c("juan", "pedro", "matthew", "carlos"),
#'                      stringsAsFactors=F)
#'     
#'     # Data frame of edges
#'     relations <- data.frame(source=c(1,1,1,2,3,4,2,4,4), 
#'                         target=c(4,2,3,3,4,2,4,1,1))
#'     
#'     # Building gexf graph
#'     mygraph <- gexf(nodes=people, edges=relations)
#'     
#'     # Summary and pring
#'     summary(mygraph)
#'     
#'     write.gexf(mygraph, output="mygraph.gexf", replace=TRUE)
#'     
#'     # Plotting
#'     plot(mygraph)
#'     
#'   }
#' @name gexf-methods
NULL





#' Build, Import and Export GEXF Graph Files
#' 
#' Create, read and write GEXF (Graph Exchange XML Format) graph files (used in
#' Gephi and others).
#' 
#' Using the XML package, it allows the user to easily build/read graph files
#' including attributes, GEXF viz attributes (such as color, size, and
#' position), network dynamics (for both edges and nodes) and edge weighting.
#' 
#' Users can build/handle graphs element-by-element or massively through
#' data-frames, visualize the graph on a web browser through "gexf-js" (a
#' javascript library) and interact with the igraph package.
#' 
#' Finally, the functions \code{igraph.to.gexf} and \code{gexf.to.igraph}
#' convert objects from \code{igraph} to \code{gexf} and viceversa keeping
#' attributes and colors.
#' 
#' Please visit the project home for more information:
#' \url{https://github.com/gvegayon/rgexf}.
#' 
#' 
#' @name rgexf-package
#' @aliases rgexf-package rgexf gephi
#' @docType package
#' @note See the GEXF primer for details on the GEXF graph format:
#' \url{https://gephi.org/gexf/1.2draft/gexf-12draft-primer.pdf}
#' @references \itemize{ \item rgexf project site:
#' \url{https://github.com/gvegayon/rgexf} \item Gephi project site:
#' \url{https://gephi.org/} \item GEXF project site: \url{http://gexf.net/}
#' \item gexf-js project website: \url{https://github.com/raphv/gexf-js} 
#' \item Sigmasj project site: \url{http://sigmajs.org/}
#' }
#' @keywords package
#' @examples
#' 
#' if (interactive()) {
#'     demo(gexf) # Example of gexf command using fictional data.
#'     demo(gexfattributes) # Working with attributes.
#'     demo(gexfbasic) # Basic net.
#'     demo(gexfdynamic) # Dynamic net.
#'     demo(edge.list) # Working with edges lists.
#'     demo(gexffull) # All the package.
#'     demo(gexftwitter) # Example with real data of chilean twitter accounts.
#'     demo(gexfdynamicandatt) # Dynamic net with static attributes.
#'     demo(gexfbuildfromscratch) # Example building a net from scratch.
#'     demo(gexfigraph) # Two-way gexf-igraph conversion
#'     demo(gexfrandom) # A nice routine creating a good looking graph
#' }
#' 
NULL





#' Twitter accounts of Chilean Politicians and Journalists (sample)
#' 
#' Sample of accounts by december 2011.
#' 
#' 
#' @name twitteraccounts
#' @docType data
#' @format A data frame containing 148 observations.
#' @source Fabrega and Paredes (2012): \dQuote{La politica en 140 caracteres}
#' en Intermedios: medios de comunicacion y democracia en Chile. Ediciones UDP
#' @keywords datasets
NULL



