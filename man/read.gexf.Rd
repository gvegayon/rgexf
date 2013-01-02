\name{read.gexf}
\alias{read.gexf}
\title{Reads gexf (.gexf) file}
\description{\code{read.gexf} reads gexf graph files and imports its elements as a \code{gexf} class object}
\usage{
read.gexf(x)
}
\arguments{\item{x}{String. Path to the gexf file.}}
\value{
  A \code{gexf} object.
}
\author{George Vega Yon \email{george.vega@nodoschile.org},

Jorge Fabrega Lacoa \email{jorge.fabrega@nodoschile.org}}

\references{
  The GEXF project website:
  \url{http://gexf.net} 
}
\note{
  By the time attributes and viz-attributes aren't supported.
}
\examples{
  \dontrun{
  mygraph <- read.gexf("http://gephi.org/datasets/LesMiserables.gexf")
  }
}
\keyword{ IO }
