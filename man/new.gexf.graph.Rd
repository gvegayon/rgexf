\name{new.gexf.graph}
\alias{new.gexf.graph}
\title{Build an empty \code{gexf} graph}
\description{
Builds an empty \code{gexf} object containing all the class's attributes.
}
\usage{
new.gexf.graph(defaultedgetype = "undirected", 
   meta = list(
      creator="NodosChile",
      description="A graph file writing in R using \'rgexf\'",
      keywords="gexf graph, NodosChile, R, rgexf"
      )
    )
}
\arguments{
  \item{defaultedgetype}{\dQuote{directed}, \dQuote{undirected}, \dQuote{mutual}}
  \item{meta}{A List. Meta data describing the graph}
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
  demo(gexfbuildfromscratch)
  }
}
\keyword{ manip }