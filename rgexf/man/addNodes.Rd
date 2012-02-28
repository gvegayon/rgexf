\name{addNodes}
\alias{addNodes}
\title{Function to add nodes to the GEXF object}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
addNodes(x, parent, att = NA, life = NA, ...)
}
\arguments{
  \item{x}{A two (three) column matrix containing id, label}
  \item{parent}{xml Parent}
  \item{att}{A list of attributes of the same length of x}
  \item{life}{A list or a two column matrix with start and end}
  \item{\dots}{Arguments to pass on newXMLnode.}
}
\author{George Vega Yon <george.vega@nodoschile.org>}