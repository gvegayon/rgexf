\name{rgexf-package}
\alias{rgexf-package}
\alias{rgexf}
\alias{gexf}
\alias{gephi}
\docType{package}
\title{
  Build, Import and Export GEXF Graph Files
}
\description{
  Create, read and write GEXF (Graph Exchange XML Format) graph files (used in Gephi and others).
  
  Using the XML package, it allows the user to easily build/read graph files including attributes, GEXF viz attributes (such as color, size, and position), network dynamics (for both edges and nodes) and edge weighting. 
  
  Users can build/handle graphs element-by-element or massively through data-frames, visualize the graph on a web browser through "sigmajs" (a javascript library) and interact with the igraph package.
  
  Finally, the functions \code{igraph.to.gexf} and \code{gexf.to.igraph} convert objects from \code{igraph} to \code{gexf} and viceversa keeping attributes and colors.
  
  Please visit the project home for more information:
    \url{https://bitbucket.org/gvegayon/rgexf}.
} 
\details{
  \tabular{ll}{
    Package: \tab rgexf\cr
    Type: \tab Package\cr
    Version: \tab 0.15.3\cr
    Date: \tab 2015-03-24\cr
    License: \tab GPL version 2 or later\cr
  }
}
\author{George Vega Yon \email{gvegayon@caltech.edu} [aut],

Jorge Fabrega Lacoa \email{jorge.fabrega@uai.cl} [cnt),

Joshua B. Kunst \email{jbkunst@gmail.com} [cnt]}
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
    \item Sigmasj project site : \url{http://sigmajs.org/}
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
    demo(gexfigraph) # Two-way gexf-igraph conversion
    demo(gexfrandom) # A nice routine creating a good looking graph
  }
}
\keyword{ package }
