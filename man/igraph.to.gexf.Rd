\name{igraph.to.gexf}
\alias{igraph.to.gexf}
\alias{gexf.to.igraph}
\title{Converting between \code{gexf} and \code{igraph} classes}
\description{Direct way to do so}
\usage{
igraph.to.gexf(igraph.obj)

gexf.to.igraph(gexf.obj)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{igraph.obj}{An object of class \code{igraph}}
  \item{gexf.obj}{An object of class \code{gexf}}
}
\value{
For \code{igraph.to.gexf} : \code{gexf} object
For \code{gexf.to.igraph} : \code{igraph} object
}
\author{
George Vega Yon \email{george.vega@nodoschile.org}
}
\note{
These functions will receive some minor changes
}
\examples{
 \dontrun{
  gexf1 <- read.gexf("http://gephi.org/datasets/LesMiserables.gexf")
  igraph1 <- gexf.to.igraph(gexf1)
  gexf2 <- igraph.to.gexf(igraph1)
  
 }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
