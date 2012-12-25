\name{add.gexf.node}
\alias{add.gexf.node}
\alias{add.gexf.edge}
\alias{rm.gexf.node}
\alias{rm.gexf.edge}
\title{Creates graph in GEXF format}
\description{\code{write.gexf} takes a \code{node} matrix (or dataframe) and an \code{edge} matrix (or dataframe) and creates a graph in GEXF format and save it into a new file}
\usage{
add.gexf.node(graph, id=NA, label=NA, start=NULL, end=NULL,
   vizAtt=list(color=NULL, position=NULL, size=NULL, shape=NULL, image=NULL))

add.gexf.edge(graph, source, target, id=NULL, type=NULL, label=NULL, start=NULL,
   end=NULL, weight=1, vizAtt = list(color=NULL, thickness=NULL, shape=NULL))

rm.gexf.node(graph, id=NULL, number=NULL, rm.edges = TRUE)

rm.gexf.edge(graph, number=NULL)
}
\arguments{
  \item{graph}{A gexf class object to which the new node is to be added.}
  \item{id}{A node id.}
  \item{label}{A node/edge label.}
  \item{type}{Type of conection.}
  \item{number}{Indexing number of node(s)/edge(s).}
  \item{weight}{Edge weight.}
  \item{vizAtt}{A list of node/edge viz attributes.}
  \item{source}{String. Source node's id.}
  \item{target}{String. Target node's id.}
  \item{start}{Start}
  \item{end}{End}
  \item{rm.edges}{Whether to remove or not existing edges.}
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
