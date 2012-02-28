\name{gexf}
\alias{gexf}
\title{Exports to GEXF}
\description{Based on nodes and edges data frames builds XML format GEXF file}
\usage{
gexf(nodes, edges, edgesAtt = NA, nodesAtt = NA, nodeDynamic = NA, output = NA, tFormat = "double", defaultedgetype = "undirected")
}
\arguments{
  \item{nodes}{Two columns data frame including 'label' and 'id'}
  \item{edges}{Two columns data frame including 'source' and 'target' based on nodes ids}
  \item{edgesAtt}{na}
  \item{nodesAtt}{na}
  \item{nodeDynamic}{Two columns data frame including 'start' and 'end' according to the format specified at tFormat}
  \item{output}{Complet path (including file name) where to print the GEXF file}
  \item{tFormat}{Time format for dynamic graphs}
  \item{defaultedgetype}{'directed' or 'undirected'}
}
\author{George Vega Yon <george.vega@nodoschile.org>}
