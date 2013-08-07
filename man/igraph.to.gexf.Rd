\name{igraph.to.gexf}
\alias{igraph.to.gexf}
\alias{gexf.to.igraph}
\title{Converting between \code{gexf} and \code{igraph} classes}
\description{Converts objects between \code{gexf} and \code{igraph} objects keeping attributes, edge weights and colors.}
\usage{
igraph.to.gexf(igraph.obj, position=NULL)

gexf.to.igraph(gexf.obj)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{igraph.obj}{An object of class \code{igraph}.}
  \item{gexf.obj}{An object of class \code{gexf}.}
  \item{position}{A three-column data-frame with XYZ coords.}
}
\details{
  If the position argument is not \code{NULL}, the new \code{gexf} object will include the \code{position} viz-attribute.
}
\value{
\itemize{
\item For \code{igraph.to.gexf} : \code{gexf} class object
\item For \code{gexf.to.igraph} : \code{igraph} class object
}
}
\author{
George Vega Yon \email{george.vega@nodoschile.org}
}
\seealso{
  \code{\link{layout}}
}
\examples{
 \dontrun{
 
  # Running demo
  demo(gexfigraph)
 
  # A simple graph without
  gexf1 <- read.gexf("http://gephi.org/datasets/LesMiserables.gexf")
  igraph1 <- gexf.to.igraph(gexf1)
  gexf2 <- igraph.to.gexf(igraph1)
  
  # A graph with attributes  
  gexf3 <- read.gexf("http://gexf.net/data/data.gexf")
  igraph2 <- gexf.to.igraph(gexf3)
  gexf4 <- igraph.to.gexf(igraph2)
 }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ manip }
