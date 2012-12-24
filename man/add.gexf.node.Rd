\name{add.gexf.node}
\alias{add.gexf.node}
\title{Creates graph in GEXF format}
\description{\code{write.gexf} takes a \code{node} matrix (or dataframe) and an \code{edge} matrix (or dataframe) and creates a graph in GEXF format and save it into a new file}
\usage{
add.gexf.node(id=NA, label=NA, start=NA, end=NA, graph)
}
\arguments{
  \item{id}{It contains two columns. First column contains nodes's id and the second one its 'label' (class: matrix or data frame).}
  \item{label}{It contains two columns. The first one has the 'source' and the second one has the 'target' (class: (matrix or data frame both based on nodes ids))}
  \item{start}{A dataframe with one or more columns representing edges attributes}
  \item{end}{A numeric vector containing edges weights}
  \item{graph}{List of three or less viz attributes such as color, thickness and shape of the edges (see details)}
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
