\name{checkTimes}
\alias{checkTimes}
\title{Checks for correct time format}
\description{Checks time}
\usage{
checkTimes(x, format = "date")
}
\arguments{
  \item{x}{A string or vector char}
  \item{format}{String, can be ``date'', ``dateTime'', ``float''}
}
\author{George Vega Yon \email{george.vega@nodoschile.org},

Jorge Fabrega Lacoa \email{jorge.fabrega@nodoschile.org}}
\examples{
  test <- c('2012-01-17T03:46:41', '2012-01-17T03:46:410')
  checkTimes(test, format='dateTime')
  checkTimes('2012-02-01T00:00:00', 'dateTime')
}
\keyword{ misc }
