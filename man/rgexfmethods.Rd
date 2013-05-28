\name{rgexf Methods}
\alias{print.gexf}
\alias{plot.gexf}
\alias{summary.gexf}
\title{
  Print and write \code{gexf} objects
}
\description{
  Methods to print and summarize \code{gexf} class objects
}
\usage{  
  \method{print}{gexf}(x, file=NA, replace=F, ...)
  \method{summary}{gexf}(object, ...)
  \method{plot}{gexf}(x, EdgeType = c("curve", "line"), ...)
}
\arguments{
  \item{x}{An object of class \code{gexf} to be printed.}
  %\item{y}{Ignored.}
  \item{object}{An object of class \code{gexf} to be printed.}
  \item{file}{String. Output path where to save the GEXF file.}  
  \item{replace}{Logical. If \code{path} exists, \code{TRUE} would replace the file.}
  \item{EdgeType}{For the visualization}
  \item{\dots}{Ignored}
}
                           
\value{
\item{\code{print.gexf}}{ None (invisible \code{NULL}).}
\item{\code{summary.gexf}}{ List containing some \code{gexf} object statistics.}
}
\author{George Vega Yon \email{george.vega@nodoschile.org}}

\seealso{
  See also \code{\link{write.gexf}}
}
\examples{
  \dontrun{
    # Data frame of nodes
    people <- data.frame(id=1:4, label=c("juan", "pedro", "matthew", "carlos"),
                     stringsAsFactors=F)
    
    # Data frame of edges
    relations <- data.frame(source=c(1,1,1,2,3,4,2,4,4), 
                        target=c(4,2,3,3,4,2,4,1,1))
    
    # Building gexf graph
    mygraph <- write.gexf(nodes=people, edges=relations)
    
    # Summary and pring
    summary(mygraph)
    
    print(mygraph, file="mygraph.gexf", replace=T)
    
  }
}
\keyword{ methods }

