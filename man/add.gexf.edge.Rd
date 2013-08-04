\name{add.gexf.node}
\alias{add.gexf.node}
\alias{add.gexf.edge}
\alias{rm.gexf.node}
\alias{rm.gexf.edge}
\alias{add.node.spell}
\alias{add.edge.spell}
\title{Adding and removing nodes/edges from \code{gexf} objects}
\description{Manipulates \code{gexf} objects adding and removing nodes and edges from both, its dataframe representation and its XML representation.}
\usage{
add.gexf.node(graph, id=NA, label=NA, start=NULL, end=NULL,
   vizAtt=list(color=NULL, position=NULL, size=NULL, shape=NULL, image=NULL),
   atts=NULL)

add.gexf.edge(graph, source, target, id=NULL, type=NULL, label=NULL, start=NULL,
   end=NULL, weight=1, vizAtt = list(color=NULL, thickness=NULL, shape=NULL),
   atts=NULL)

rm.gexf.node(graph, id=NULL, number=NULL, rm.edges = TRUE)

rm.gexf.edge(graph, id=NULL, number=NULL)

add.node.spell(graph, id=NULL, number=NULL, start=NULL, end=NULL)

add.edge.spell(graph, id=NULL, number=NULL, start=NULL, end=NULL)
}
\arguments{
  \item{graph}{A gexf-class object.}
  \item{id}{A node/edge id (normaly numeric value).}
  \item{label}{A node/edge label.}
  \item{type}{Type of conection (edge).}
  \item{number}{Index number(s) of a single or a group of nodes or edges.}
  \item{weight}{Edge weight.}
  \item{vizAtt}{A list of node/edge viz attributes (see \code{\link{write.gexf}}).}
  \item{atts}{List of attributes.}
  \item{source}{Source node's id.}
  \item{target}{Target node's id.}
  \item{start}{Starting time period }
  \item{end}{Ending time period}
  \item{rm.edges}{Whether to remove or not existing edges.}
}
\details{
  \code{new.gexf.graph} Creates a new \code{gexf} empty object (0 nodes 0 edges).
  
  \code{add.gexf.node} and \code{add.gexf.edge} allow adding nodes and edges to a \code{gexf} object (graph) one at a time. \code{rm.gexf.node} and \code{rm.gexf.edges} remove nodes and edges respectively.
  
  In the case of \code{rm.gexf.node}, by default every edge linked to the node that is been removed will also be removed (\code{rm.edges = TRUE}).
  
  \code{add.node.spell} and \code{add.edge.spell} allow to include spells to specific nodes or edges in a \code{gexf} object.
}
\value{
  A \code{gexf} object (see \code{\link{write.gexf}}).
}
\author{George Vega Yon \email{george.vega@nodoschile.org},

Jorge Fabrega Lacoa \email{jorge.fabrega@nodoschile.org}}

\references{
  The GEXF project website:
  \url{http://gexf.net} 
}
\examples{
  \dontrun{
  demo(gexfbuildfromscratch)
  }
}
\keyword{ manip }
