\name{write.gexf}
\alias{write.gexf}
\title{Builds a graph of \code{gexf} class}
\description{\code{write.gexf} takes a \code{node} matrix (or dataframe) and an \code{edge} matrix (or dataframe) and creates a \code{gexf} object containing a data-frame representation and a gexf representation of a graph.}
\usage{
write.gexf(
  nodes, edges, edgesLabel = NULL, edgesId = NULL,
  edgesAtt = NULL, edgesWeight = NULL, 
  edgesVizAtt = list(
    color=NULL, 
    size=NULL, 
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
    description="A graph file writing in R using \"rgexf\"",
    keywords="gexf graph, NodosChile, R, rgexf"),
  keepFactors = TRUE
  )
}
\arguments{
  \item{nodes}{It contains two columns. First column contains nodes's id and the second one its \dQuote{label} (class: matrix or data frame).}
  \item{edges}{It contains two columns. The first one has the \dQuote{source} and the second one has the \dQuote{target} (class: (matrix or data frame both based on nodes ids))}
  \item{edgesId}{One column data.frame/matrix or vector.}
  \item{edgesLabel}{One column data.frame/matrix or vector.}
  \item{edgesAtt}{A dataframe with one or more columns representing edges attributes}
  \item{edgesWeight}{A numeric vector containing edges weights}
  \item{edgesVizAtt}{List of three or less viz attributes such as color, size (thickness) and shape of the edges (see details)}
  \item{nodesAtt}{A dataframe with one or more columns representing nodes attributes}
  \item{nodesVizAtt}{List of four or less viz attributes such as color, position, size and shape of the nodes (see details)}
  \item{nodeDynamic}{A two columns matrix or dataframe. The first column indicates the time at which a given node starts; the second one shows when it ends. The matrix or dataframe must have the same number of rows than the number of nodes}
  \item{edgeDynamic}{A two columns matrix or dataframe. The fist column indicates the time at which a given edge stars; the second one shows when it ends. The matrix or dataframe must have the same number of rows than the number of edges}
  \item{output}{character, complete path (including file name) where to print the GEXF file}
  \item{tFormat}{character, time format for dynamic graphs}
  \item{defaultedgetype}{\dQuote{directed}, \dQuote{undirected}, \dQuote{mutual}}
  \item{meta}{A List. Meta data describing the graph}
  \item{keepFactors}{Logical, whether to manage factors as numeric values (\code{TRUE}) or as character (\code{FALSE})}
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
  
  \code{nodeDynamic} and \code{edgeDynamic} allow to draw dynamic graphs. It should contain two columns \emph{start} and \emph{end}, both allowing \code{NA} value. It can be use jointly with \code{tFormat} which by default is setted as \dQuote{double}. Currently accepted time formats are:
  \itemize{
  \item Integer or double.
  \item International standard \emph{date} yyyy-mm-dd.
  \item dateTime W3 XSD (\url{http://www.w3.org/TR/xmlschema-2/#dateTime}).
  }
}
\value{
  A \code{gexf} object.
}
\author{George Vega Yon \email{george.vega@nodoschile.org},

Jorge Fabrega Lacoa \email{jorge.fabrega@nodoschile.org}}

\references{
  The GEXF project website:
  \url{http://gexf.net} 
}
\seealso{
  \code{\link{new.gexf.graph}}
}
\examples{
  \dontrun{
  demo(gexf) # Example of gexf command using fictional data.
  demo(gexfattributes) # Working with attributes.
  demo(gexfbasic) # Basic net.
  demo(gexfdynamic) # Dynamic net.
  demo(edge.list) # Working with edges lists.
  demo(gexffull) # All the package.
  demo(gexftwitter) # Example with real data of chilean twitter accounts.
  demo(gexfdynamicandatt) # Dynamic net with static attributes.
  demo(gexfbuildfromscratch) # Example building a net from scratch.
  }
}
\keyword{ IO }
