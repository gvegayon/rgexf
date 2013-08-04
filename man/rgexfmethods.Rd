\name{rgexf Methods}
\alias{print.gexf}
\alias{export-gexf}
\alias{plot.gexf}
\alias{summary.gexf}
\title{
  S3 methods for \code{gexf} objects
}
\description{
  Methods to print and summarize \code{gexf} class objects
}
\usage{  
  \method{print}{gexf}(x, file=NA, replace=F, ...)
  \method{summary}{gexf}(object, ...)
  \method{plot}{gexf}(x, EdgeType = c("curve", "line"), output.dir = NULL, ...)
}
\arguments{
  \item{x}{An \code{gexf} class object.}
  %\item{y}{Ignored.}
  \item{object}{An \code{gexf} class object.}
  \item{file}{String. Output path where to save the GEXF file.}  
  \item{replace}{Logical. If \code{file} exists, \code{TRUE} would replace the file.}
  \item{EdgeType}{For the visualization}
  \item{output.dir}{String. The complete path where to export the sigmajs visualization}
  \item{\dots}{Ignored}
}

\details{
  \code{print.gexf} displays the graph (XML) in the console. If \code{file} is
  not \code{NA}, a GEXF file will be exported to the indicated filepath.
  
  \code{summay.gexf} prints summary statistics and information about the graph.
  
  \code{plot.gexf} plots the graph object in the web browser using sigma-js
  javascript library. Generated files are stored at the OS's \dQuote{temp}
  folder. If \code{output.dir} is not \code{NULL}, then all files required
  to display the graph in the web browser will be saved in the \code{output.dir}.
  
  Users must note that \code{plot.gexf} starts a server using the \code{Rook}
  package, otherwise it will not be possible to see the visualization (sigmajs
  requires this).
  to 
}
                           
\value{
\item{\code{print.gexf}}{ None (invisible \code{NULL}).}
\item{\code{summary.gexf}}{ List containing some \code{gexf} object statistics.}
\item{\code{plot.gexf}}{ None (invisible \code{NULL}).}
}
\author{George Vega Yon \email{george.vega@nodoschile.org},

Joshua B. Kunst \email{jbkunst@nodoschile.org}
}
\references{
  sigmajs project website \url{http://sigmajs.org/}.
}
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
    
    # Plotting
    plot(mygraph)
    
  }
}
\keyword{ methods }

