# Changes in rgexf version 0.16.0 (2017-11-06)

## New features and changes

* Modernization of the project (roxygen, new CRAN standards, etc.)

* Updated emails.

* Remove broken links.

* Function `write.gexf` has a new argument for specifying the GEXF version
  for now it only changes the header.
  
* `plot.gexf` method now uses `gexf-js` instead of `sigma.js`.

## New functions

* The function `gexf` has been introduced as an eventual replacement of
  `write.gexf` since it makes more sense. `write.gexf` should only be for
  writing the gexf file on the disk. This will be effective starting vers 0.17.0


# Changes in rgexf version 0.15.3 (2015-03-24)

-   Updating emails.


# Changes in rgexf version 0.14.3 (2014-03-09)

## New features and changes

-   New option -digits- in several functions allow to control for
    printing precision (reported in issue 16, thanks Nico!).

-   Function -igraph.to.gexf- now imports attributes.

## Bug fixes

-   Option -defaultedgetype- in the -write.gexf- function now works for
    static graphs (reported in issue 17, thanks Avitus!).

-   -datetime- time format in -write.gexf- now works for other formats
    different from numeric datetime types (reported as issue 15, thanks
    Thomas Ullmann!).

-   Correcting errors in -plot.gexf- method, now visual attributes are
    imported correctly.

## Development

-   Option -keepFactors- default is now in -FALSE- (used to be
    in -TRUE-). When set to -TRUE- and there are factors, a warning
    message will appear (reported in issue 18, thanks Tim Smith!).

# Changes in rgexf version 0.13.11 (2013-11-27)

## Bug fixes

-   Included class checks in -gexf- class functions (thanks to
    Samuel Finegold).

-   `write.gexf` does not fails when dynamics different from `double`
    are passed (thank you Samuel Finegold!).

-   Passing weights from igraph to gexf as now been fix (thank you
    Roberto Brunelli!).

-   Fixing encoding issues thanks to Yong Cha's suggestion (thank you!).

# Changes in rgexf version 0.13.8 (2013-08-06)

## New features and changes

-   New S3 method `plot.gexf`, implemented by Joshua B Kunst, shows the
    graph in the web browser by means of Sigma.js (!).

-   New functions `igraph.to.gexf` and `gexf.to.igraph` converts objects
    between `igraph` and `gexf` clases. Colors and attributes
    are preserved.

## Development

-   Improving general documentation.

-   Just starting to add new options to `add.gexf.node/edge`, more
    precisely, passing attributes.

# Changes in rgexf version 0.13.05 (2013-05-09)

## Bug fixes

-   `sprintf` error when using other formats rather than double
    (issue 10).

-   in `.addNodesEdges`, add support to case “!attributes &&
    vizattributes” (issue 9).

# Changes in rgexf version 0.13.03 (2013-03-14)

## New features and changes

-   New functions `add.node.spell` and `add.edge.spell` now allow to
    work with nodes and edges time spells.

-   New function `check.dpl.edges`, written in C, analyzes links and
    reports duplicates (marking them) and number of times the same link
    is repeated considering if the graph is directed or not.

-   New function `switch.edges`, also written in C, allows to order
    links representations (source and target) in order to set the
    smallest id as source and the highest as target.

-   Function `write.gexf` now has an improved error handler. Now parses
    objects before even opening the XML graph.

-   Edges support id assignment and labeling.

## Bug fixes

-   Small bug detected in viz attributes fixed.

-   Edges thickness viz att XML representation (`viz:thickness`) was
    replaced by `viz:size` (as it should be).

-   “Library” replaced by “Package” everywhere (`ups!`)

## Development

-   `.addNodesEdges` rewritten now works faster in most of CPUs (some of
    them with very high speedups) (Thanks to Duncan Temple Lang,
    RXML author)

-   Several code routines have been extracted from “bigger functions”
    and written as functions themselves.

# Changes in rgexf version 0.13.01 (2013-01-04)

## New features and changes

-   New functions `new.gexf.graph`, `add.gexf.node`, `add.gexf.edge`,
    `rm.gexf.node` and `rm.gexf.edge` allow to build and manipulate
    `gexf` objects from scratch.

-   New function `read.gexf` allows to import gexf files as `gexf`
    class objects.

-   `gexf` function now it is called `write.gexf`.

-   Edges now allow weighting.

-   Viz Attributes (color, shape, size, etc.) can be included in both,
    nodes and edges.

-   Real-life datasets have been includded.

-   New function `edge.list` builds a dataframe of nodes from an
    edge list.

-   New methods for `gexf` objects: `print.gexf` and `summary.gexf`.

## Development

-   `gexf` class objects are now a standard.

-   Function `gexf` is now named `write.gexf`.

-   Faster net build.

-   More demos + improve ones.

-   Cleaner code.

# Changes in rgexf version 0.12.03.29 (2012-03-29)

## Bug fixes

-   Fixing big misscoding at attvalues XML tag: it was replaced from
    "att" to "attvalue".

-   Fixing problem with XML value printing: Leading speces where removed
    from XML values at ids, source, target, etc.

# Changes in rgexf version 0.12.03 (2012-03-05)

## New features and changes

-   Including a manual of the functions

## Development

-   Development repository more ordered acording to R package building.


