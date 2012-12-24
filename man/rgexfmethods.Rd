\name{rgexf Methods}
\alias{print.gexf}
\title{
  Print and write gexf objects
}
\description{
  Methods to print and summarize \code{gexf} class objects
}
\usage{  
  \method{print}{gexf}(x, file=NA, replace=F, ...)
}
\arguments{
  \item{x}{An object of class \code{gexf} to be printed.}
  \item{file}{String. Output path where to save the GEXF file.}  
  \item{replace}{Logical. If \code{path} exists, \code{TRUE} would replace the file.}
  \item{\dots}{arguments passed on to \code{\link{cat}} (\code{print.rgexf})}
}
                           
\value{
\item{\code{print.gexf}}{ None (invisible \code{NULL}).}
}
\author{George Vega Yon \email{george.vega@nodoschile.org}}

\seealso{
  See also \code{\link{write.gexf}}
}
\examples{
  \dontrun{
    # Parsing some xlsx files at "my stats folder"
    mydspl <- dspl(path="my stats folder/", ext="xls")
    
    # Checking the summary of the data bundle
    summary(mydspl)
    
    # Writing the DSPL XML definition into a file
    print(mydspl, path="my stats folder/mydspl.xml")
    
  }
}
\keyword{ methods }

