\name{gexf}
\alias{gexf}
\title{Creates GEXF graph file}
\description{\code{gexf} takes as basic arguments a \code{node} and \code{edge} matrices or data frames   with which writes a GEXF graph file}
\usage{
gexf(
  nodes, edges, 
  edgesAtt = NULL, edgesWeight = NULL, 
  edgesVizAtt = list(color=NULL, thickness=NULL, shape=NULL),
  nodesAtt = NULL,
  nodesVizAtt = list(color=NULL, position=NULL, size=NULL, shape=NULL, image=NULL),
  nodeDynamic = NULL, 
  edgeDynamic = NULL, 
  output = NA, tFormat = "double", defaultedgetype = "undirected",
  meta = list(
    creator='NodosChile', 
    description='A graph file writing in R using \'rgexf\'',
    keywords='gexf graph, NodosChile, R, rgexf')
  )
}
\arguments{
  \item{nodes}{Two columns, nodes 'id' and 'label', matrix or data frame.}
  \item{edges}{Two columns, namely 'source' and 'target', matrix or data frame based on nodes ids}
  \item{edgesAtt}{One or more columns data frame representing edges attributes}
  \item{edgesWeight}{Numeric vector containing edges weights}
  \item{edgesVizAtt}{List of three or less viz attributues such as color, thickness and shape of the edges (see details)}
  \item{nodesAtt}{One or more columns data frame representing nodes attributes}
  \item{nodesVizAtt}{List of four or less viz attributes such as color, position, size and shape of the nodes (see details)}
  \item{nodeDynamic}{Two columns matrix or data frame including 'start' and 'end' with number of rows equal to the number of nodes}
  \item{edgeDynamic}{Two columns matrix or data frame including 'start' and 'end' with number of rows equal to the number of edges}
  \item{output}{Character, complet path (including file name) where to print the GEXF file}
  \item{tFormat}{Character, time format for dynamic graphs}
  \item{defaultedgetype}{'directed' or 'undirected'}
  \item{meta}{Meta data describing the graph}
}
\details{  
  \code{nodesAtt} and \code{edgesAtt} can be optionally include and must have the same number of rows as nodes and edges are respectively. In order to fully take advantage of \code{gexf}, using data frames is needed as these preserve vectors datatypes, which are identified by the function.
  
  \code{nodesVizAtt} and \code{edgesVizAtt} allow to stablish visual attributes such as color, position (nodes only), size (nodes only), thickness (edges only) shape and image (nodes only). 
  \itemize{
  \item Color is defined by the RGBA color model, thus for every node/edge the color should be with \emph{r}, \emph{g}, \emph{b} with integers between 0 and 256 and \emph{alpha} as a float between 0.0 and 1.0.
  \item Position, for every node, is a three component vector including \emph{x}, \emph{y} and \emph{z} coordinates. The three as float.
  \item Size should be denoted as a float.
  \item Thickness works the same as size.
  \item Node Shape (character), currently unsuported by Gephi, can take the values of \emph{disk}, \emph{square}, \emph{triangle}, \emph{diamond} and \emph{image}.
  \item Edge Shape (character), currently unsuported by Gephi, can take the values of \emph{solid}, \emph{dotted}, \emph{dashed} and \emph{double}.
  \item Image (character), currently unsuported by Gephi, consists on a character vector of URIs.
  }
  
  \code{nodeDynamic} and \code{edgeDynamic} allow to draw dynamic graphs. It should contain two columns \emph{start} and \emph{end}, both allowing \code{NA} value. It can be use jointly with \code{tFormat} which by default is setted as 'double'. Currently accepted time formats are:
  \itemize{
  \item Integer or double.
  \item International standard \emph{date} yyyy-mm-dd.
  \item dateTime W3 XSD (\url{http://www.w3.org/TR/xmlschema-2/#dateTime}).
  }
}
\value{
  A GEXF (xml) graph object.
}
\author{George Vega Yon \email{george.vega@nodoschile.org}}

\references{
  The GEXF project website:
  \url{http://gexf.net} 
}
\examples{
  \dontrun{
  demo(dspl)
  }
}
