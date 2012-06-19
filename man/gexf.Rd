\name{gexf}
\alias{gexf}
\title{Generates GEXF graph file}
\description{Based on nodes and edges data frames builds XML format GEXF file}
\usage{
gexf(nodes, edges, edgesAtt = NULL, nodesAtt = NULL, nodeDynamic = NULL, 
  edgeDynamic = NULL, output = NA, tFormat = "double", defaultedgetype = "undirected")
}
\arguments{
  \item{nodes}{Two columns matrix or data frame including 'label' and 'id'}
  \item{edges}{Two columns matrix or data frame including 'source' and 'target' based on nodes ids}
  \item{edgesAtt}{One or more columns data frame with number of rows equal to the number of edges}
  \item{nodesAtt}{One or more columns data frame with number of rows equal to the number of nodes}
  \item{nodeDynamic}{Two columns matrix or data frame including 'start' and 'end' with number of rows equal to the number of nodes according to the format specified at tFormat}
  \item{edgeDynamic}{Two columns matrix or data frame including 'start' and 'end' with number of rows equal to the number of edges according to the format specified at tFormat}
  \item{output}{Complet path (including file name) where to print the GEXF file}
  \item{tFormat}{Time format for dynamic graphs}
  \item{defaultedgetype}{'directed' or 'undirected'}
}
\details{
  When defining any kind of att values, gexf reads the data and, using the same
  column names, defines and prints each att value.
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
