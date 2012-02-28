\name{addEdges}
\alias{addEdges}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Function to add edges to the GEXF object}
\description{Add edges}
\usage{
addEdges(x, parent, att = NA, life = NA, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{A two (three) column matrix containing source, target ids}
  \item{parent}{xml Parent}
  \item{att}{A list of attributes of the same length of x}
  \item{life}{A list or a two column matrix with start and end}
  \item{\dots}{Arguments to pass on newXMLnode.}
}
\author{George Vega Yon <george.vega@nodoschile.org>}
