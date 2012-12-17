\name{gexf}
\alias{gexf}
\title{Creates graph in GEXF format}
\description{\code{gexf} takes a \code{node} matrix (or dataframe) and an \code{edge} matrix (or dataframe) and creates a graph in GEXF format and save it into a new file}
\usage{
gexf(
  nodes, edges, 
  edgesAtt = NULL, edgesWeight = NULL, 
  edgesVizAtt = list(
    color=NULL, 
    thickness=NULL, 
    shape=NULL
  ),
  nodesAtt = NULL,
  nodesVizAtt = list(
    color=NULL, 
    position=NULL, 
    size=NULL, 
    shape=NULL, 
    image=NULL
  ),
  nodeDynamic = NULL, 
  edgeDynamic = NULL, 
  output = NA, tFormat = "double", 
  defaultedgetype = "undirected",
  meta = list(
    creator="NodosChile", 
    description="A graph file writing in R using \'rgexf\'",
    keywords="gexf graph, NodosChile, R, rgexf")
  )
}
\arguments{
  \item{nodes}{It contains two columns. First column contains nodes's id and the second one its 'label' (class: matrix or data frame).}
  \item{edges}{It contains two columns. The first one has the 'source' and the second one has the 'target' (class: (matrix or data frame both based on nodes ids))}
  \item{edgesAtt}{A dataframe with one or more columns representing edges attributes}
  \item{edgesWeight}{A numeric vector containing edges weights}
  \item{edgesVizAtt}{List of three or less viz attributes such as color, thickness and shape of the edges (see details)}
  \item{nodesAtt}{A dataframe with one or more columns representing nodes attributes}
  \item{nodesVizAtt}{List of four or less viz attributes such as color, position, size and shape of the nodes (see details)}
  \item{nodeDynamic}{A two columns matrix or dataframe. The first column indicates the time at which a given node starts; the second one shows when it ends. The matrix or dataframe must have the same number of rows than the number of nodes}
  \item{edgeDynamic}{A two columns matrix or dataframe. The fist column indicates the time at which a given edge stars; the second one shows when it ends. The matrix or dataframe must have the same number of rows than the number of edges}
  \item{output}{character, complete path (including file name) where to print the GEXF file}
  \item{tFormat}{character, time format for dynamic graphs}
  \item{defaultedgetype}{'directed' or 'undirected'}
  \item{meta}{Meta data describing the graph}
}
\details{  
  \code{nodesAtt} and \code{edgesAtt} can be also include. They must have the same number of rows as nodes and edges, respectively. In order to fully take advantage of \code{gexf}, using data frames is needed as these preserve vectors datatypes, which are identified by the function.
  
  \code{nodesVizAtt} and \code{edgesVizAtt} allow to establish visual attributes such as color, position (nodes only), size (nodes only), thickness (edges only) shape and image (nodes only). 
  \itemize{
  \item Color is defined by the RGBA color model, thus for every node/edge the color should be with \emph{r}, \emph{g}, \emph{b} with integers between 0 and 256 and \emph{alpha} as a float between 0.0 and 1.0.
  \item Position, for every node, is a three components vector including \emph{x}, \emph{y} and \emph{z} coordinates. The three components must be float.
  \item Size should be denoted as a float.
  \item Thickness works as size.
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
\author{George Vega Yon \email{george.vega@nodoschile.org},

Jorge Fabrega Lacoa \email{jorge.fabrega@nodoschile.org}}

\references{
  The GEXF project website:
  \url{http://gexf.net} 
}
\examples{
  \dontrun{
  demo(gexf)
  demo(gexfattributes)
  demo(gexfbasic)
  demo(gexfdynamic)
  demo(processEdgeList)
  demo(gexffull)
  demo(gexftwitter)
  demo(gexfdynamicandatt)
  }
}
\keyword{ IO }
