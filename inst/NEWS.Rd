\name{NEWS}
\title{rgexf NEWS}
\encoding{UTF-8}

\section{CHANGES IN rgexf version 0.13.01 [2013-01-04]}{
  \subsection{NEW FEATURES}{
    \itemize{
      \item New functions \code{new.gexf.graph}, \code{add.gexf.node}, \code{add.gexf.edge}, \code{rm.gexf.node} and \code{rm.gexf.edge} allow to build and manipulate \code{gexf} objects from scratch.
      \item New function \code{read.gexf} allows to import gexf files as \code{gexf} class objects.
      \item \code{gexf} function now it is called \code{write.gexf}.
      \item Edges now allow weighting.
      \item Viz Attributes (color, shape, size, etc.) can be included in both, nodes and edges.
      \item Real-life datasets have been includded.
      \item New function \code{edge.list} builds a dataframe of nodes from an edge list.
      \item New methods for \code{gexf} objects: \code{print.gexf} and \code{summary.gexf}.
    }
  }
  \subsection{DEVELOPMENT}{
    \itemize{
      \item \code{gexf} class objects are now a standard.
      \item Function \code{gexf} is now named \code{write.gexf}.
      \item Faster net build.
      \item More demos + improve ones.
      \item Cleaner code.
    }
  }
}

\section{CHANGES IN rgexf version 0.12.03.29 [2012-03-29]}{
  \subsection{FIXES}{
    \itemize{
      \item Fixing big misscoding at attvalues XML tag: it was replaced from "att" to "attvalue".
      \item Fixing problem with XML value printing: Leading speces where removed from XML values at ids, source, target, etc.
    }
  }
}

\section{CHANGES IN rgexf version 0.12.03 [2012-03-05]}{
  \subsection{NEW FEATURES}{
    \itemize{
      \item Including a manual of the functions
    }
  }
  \subsection{DEVELOPMENT}{
    \itemize{
      \item Development repository more ordered acording to R package building.
    }
  }
}