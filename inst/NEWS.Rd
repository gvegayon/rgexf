\name{NEWS}
\title{rgexf NEWS}
\encoding{UTF-8}

\section{CHANGES IN rgexf version 0.12.12 [2012-12-17]}{
  \subsection{NEW FEATURES}{
    \itemize{
      \item Edges allow weighting.
      \item Viz Attributes (color, shape, size, etc.) can be included in both, nodes and edges.
      \item Real-life datasets have been includded.
      \item New function \code{processEdgeList} builds a dataframe of nodes from an edge list.
    }
  }
  \subsection{DEVELOPMENT}{
    \itemize{
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