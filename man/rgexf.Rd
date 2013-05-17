\name{rgexf-package}
\alias{rgexf-package}
\alias{rgexf}
\alias{gexf}
\alias{gephi}
\docType{package}
\title{
  An R package to build GEXF graph files
}
\description{
  rgexf package provides of a collection of functions to generate and read GEXF graph files supported on Gephi (and others).
  
  It supports building dynamic graphs (including spells) and adding attributes to edges and nodes, including visual attributes such as color, shape and size.
  
  Users can chose to build graph from \code{data.frame}s (using \code{write.gexf}) or element-by-element (using several other functions to handle \code{gexf} objects.)
  
  Please visit the project home for more information:
    \url{https://bitbucket.org/gvegayon/rgexf}.
} 
\details{
  \tabular{ll}{
    Package: \tab rgexf\cr
    Type: \tab Package\cr
    Version: \tab 0.13.05\cr
    Date: \tab 2013-05-09\cr
    License: \tab GPL version 2 or later\cr
  }
}
\author{George Vega Yon \email{george.vega@nodoschile.org},

Jorge Fabrega Lacoa \email{jorge.fabrega@nodoschile.org}}
\note{
  See the GEXF primer for details on the GEXF graph format:
  \url{http://gexf.net/1.2draft/gexf-12draft-primer.pdf}
}
\references{
  \itemize{
    \item rgexf project site: \url{https://bitbucket.org/gvegayon/rgexf}
    \item Gephi project site: \url{https://gephi.org/}
    \item GEXF project site: \url{http://gexf.net/}
    \item Nodos Chile project site (real life examples): \url{http://nodoschile.org/}
  }
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
\keyword{ package }
