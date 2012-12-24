\name{read.gexf}
\alias{read.gexf}
\title{Reads gexf file}
\description{\code{read.gexf} reads gexf graph files and imports its elements as a gexf class object}
\usage{
read.gexf(x)
}
\arguments{\item{x}{String. Path to the gexf file.}}
\value{
  A gexf object.
}
\author{George Vega Yon \email{george.vega@nodoschile.org},

Jorge Fabrega Lacoa \email{jorge.fabrega@nodoschile.org}}

\references{
  The GEXF project website:
  \url{http://gexf.net} 
}
\examples{
  \dontrun{
  mygraph <- read.gexf("http://gephi.org/datasets/LesMiserables.gexf")
  }
}
\keyword{ IO }
