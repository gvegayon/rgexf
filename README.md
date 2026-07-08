

[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/rgexf)](https://cran.r-project.org/package=rgexf)
[![Downloads](https://cranlogs.r-pkg.org/badges/rgexf)](https://cran.r-project.org/package=rgexf)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/rgexf)](https://cran.r-project.org/package=rgexf)
[![R CI](https://github.com/gvegayon/rgexf/actions/workflows/ci.yml/badge.svg)](https://github.com/gvegayon/rgexf/actions/workflows/ci.yml)
[![rgexf website](https://github.com/gvegayon/rgexf/actions/workflows/website.yml/badge.svg)](https://github.com/gvegayon/rgexf/actions/workflows/website.yml)
[![Coverage Status](https://img.shields.io/codecov/c/github/gvegayon/rgexf/master.svg)](https://app.codecov.io/github/gvegayon/rgexf?branch=master)
[![DOI](https://joss.theoj.org/papers/10.21105/joss.03456/status.svg)](https://doi.org/10.21105/joss.03456)
[![Sponsor](https://img.shields.io/badge/-Sponsor-fafbfc?logo=GitHub%20Sponsors)](https://github.com/sponsors/gvegayon)

# rgexf: Build, Import and Export GEXF Graph Files <img src="man/figures/logo.svg" align="right" height="200"/>

The first R package to work with GEXF graph files (used in Gephi and
others). `rgexf` allows reading and writing graph files, including:

1.  Nodes/edges attributes,

2.  GEXF viz attributes (such as color, size, and position),

3.  Network dynamics (for both edges and nodes, including spells) and

4.  Edges weighting.

Users can build/handle graphs element-by-element or through data-frames,
visualize the graph on a web browser through ~~sigmajs javascript~~
[gexf-js](https://github.com/raphv/gexf-js) library and interact with
the igraph package.

# Changes in rgexf version 0.16.4

## New features and changes

- `plot.gexf()` now renders graphs as an interactive htmlwidget powered
  by [sigma.js](https://www.sigmajs.org/) v3 and
  [graphology](https://graphology.github.io/). Node positions, colours,
  and sizes are read from the `viz:*` attributes in the GEXF document.

- New `sigmajs()` function creates a sigma.js htmlwidget from a `gexf`
  object or a path to a `.gexf` file. Shiny helpers `sigmajsOutput()`
  and `renderSigmajs()` are also available.

- The legacy gexf-js file-server renderer is preserved as
  `plot_gexfjs()`. The `gexfjs()` htmlwidget (inline iframe approach) is
  likewise kept for backward compatibility.

- `gexfjs()` now accepts a `gexf` object in addition to a file path,
  matching `sigmajs()`.

- `gexfjs()` has an explicit sizing policy: the widget now defaults to
  the full available width and a height of 600px (50% taller than
  before) in knitr documents, the browser, and Shiny alike. Both
  `gexfjs()` and `sigmajs()` honor user-supplied `width`/`height`, and
  their documented defaults were clarified.

## Bug fixes

- The `gexfjs()` widget rendered an empty main canvas: the bundled
  `config.js` (which sets `zoomLevel`, `showEdges`, and other gexf-js
  defaults) was never loaded into the iframe, making every screen
  coordinate `NaN`.

- Icons and images in the `gexfjs()` widget (zoom, lens, edge buttons,
  search icon, Gephi logo) did not display: relative `url(...)`
  references in the CSS cannot resolve inside a `srcdoc` iframe, so
  images are now inlined as base64 data URIs.

- The `gexfjs()` widget’s node-attribute panel was blank and search did
  not work: the generated DOM was missing the `#leftcontent` element,
  the search form id had a typo (`reacherche`), and the autocomplete
  list was clipped by the title bar.

More in the [NEWS.md](NEWS.md) file.

# Installation

To install the latest version of `rgexf`, you can use `devtools`

``` r
library(devtools)
install_github("gvegayon/rgexf")
```

The more stable (but old) version of `rgexf` can be found on CRAN too:

    install.packages("rgexf")

# Citation

``` r
citation(package="rgexf")
```

    To cite rgexf in publications use the following paper:

      Vega Yon G (2021). "Building, Importing, and Exporting GEXF Graph
      Files with rgexf." _Journal of Open Source Software_, *6*, 3456.
      doi:10.21105/joss.03456 <https://doi.org/10.21105/joss.03456>,
      <https://doi.org/10.21105/joss.03456>.

    And the actual R package:

      Vega Yon G, Fábrega Lacoa J, Kunst J (????). _netdiffuseR: Build,
      Import and Export GEXF Graph Files_. doi:10.5281/zenodo.5182708
      <https://doi.org/10.5281/zenodo.5182708>, R package version 0.16.4,
      <https://github.com/gvegayon/rgexf>.

    To see these entries in BibTeX format, use 'print(<citation>,
    bibtex=TRUE)', 'toBibtex(.)', or set
    'options(citation.bibtex.max=999)'.

# Examples

## Example 1: Importing GEXF files

We can use the `read.gexf` function to read GEXF files into R:

``` r
# Loading the package
library(rgexf)

g <- system.file("gexf-graphs/lesmiserables.gexf", package="rgexf")
g <- read.gexf(g)
head(g) # Taking a look at the first handful
```

    <?xml version="1.0" encoding="UTF-8"?>
    <gexf xmlns="http://www.gexf.net/1.3" xmlns:viz="http://www.gexf.net/1.3/viz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.3" xsi:schemaLocation="http://www.gexf.net/1.3 http://www.gexf.net/1.3/gexf.xsd">
      <meta lastmodifieddate="2016-11-09">
        <creator>Gephi 0.9</creator>
        <description/>
      </meta>
      <graph defaultedgetype="undirected" mode="static">
        <attributes class="node" mode="static">
          <attribute id="modularity_class" title="Modularity Class" type="integer"/>
        </attributes>
        <nodes>
          <node id="11" label="Valjean">
            <attvalues>
              <attvalue for="modularity_class" value="1"/>
            </attvalues>
            <viz:size value="100.0"/>
            <viz:position x="-87.93029" y="6.8120565"/>
            <viz:color r="245" g="91" b="91"/>
          </node>
          <node id="48" label="Gavroche">
            <attvalues>
              <attvalue for="modularity_class" value="8"/>
            </attvalues>
            <viz:size value="61.600006"/>
            <viz:position x="387.89572" y="-110.462326"/>
            <viz:color r="91" g="245" b="91"/>
          </node>
          <node id="55" label="Marius">
            <attvalues>
              <attvalue for="modularity_class" value="6"/>
            </attvalues>
            <viz:size value="53.37143"/>
            <viz:position x="206.44687" y="13.805411"/>
            <viz:color r="194" g="91" b="245"/>
          </node>
          <node id="27" label="Javert">
            <attvalues>
              <attvalue for="modularity_class" value="7"/>
            </attvalues>
            <viz:size value="47.88571"/>
            <viz:position x="-81.46074" y="204.20204"/>
            <viz:color r="91" g="245" b="194"/>
          </node>
          <node id="25" label="Thenardier">
            <attvalues>
              <attvalue for="modularity_class" value="7"/>
            </attvalues>
            <viz:size value="45.142853"/>
            <viz:position x="82.80825" y="203.1144"/>
            <viz:color r="91" g="245" b="194"/>
          </node>
          <node id="23" label="Fantine">
            <attvalues>
              <attvalue for="modularity_class" value="2"/>
            </attvalues>
            <viz:size value="42.4"/>
            <viz:position x="-313.42786" y="289.44803"/>
            <viz:color r="91" g="194" b="245"/>
          </node>
                ...
         </nodes>
        <edges>
          <edge id="0" source="1" target="0"/>
          <edge id="1" source="2" target="0" weight="8.0"/>
          <edge id="2" source="3" target="0" weight="10.0"/>
          <edge id="3" source="3" target="2" weight="6.0"/>
          <edge id="4" source="4" target="0"/>
          <edge id="5" source="5" target="0"/>
                ...
         </edges>
      </graph>
    </gexf>

Moreover, we can use the `gexf.to.igraph()` function to convert the
`gexf` object into an `igraph` object:

``` r
library(igraph)
```


    Attaching package: 'igraph'

    The following objects are masked from 'package:stats':

        decompose, spectrum

    The following object is masked from 'package:base':

        union

``` r
ig <- gexf.to.igraph(g)

op <- par(mai = rep(0, 4)) # Making room
plot(ig)
```

![](man/figures/igraph-1.png)

``` r
par(op)
```

Using the `plot.gexf` method–which uses the `gexf-js` JavaScript
library–results in a Web visualization of the graph, like this:

``` r
plot(g)
```

![](inst/gexf-graphs/lesmiserables.png)

A live version of the figure is available
[here](https://gvegayon.github.io/rgexf/lesmiserables/).

## Example 2: Static net

``` r
# Creating a group of individuals and their relations
people <- data.frame(matrix(c(1:4, 'juan', 'pedro', 'matthew', 'carlos'),ncol=2))
people
```

      X1      X2
    1  1    juan
    2  2   pedro
    3  3 matthew
    4  4  carlos

``` r
# Defining the relations structure
relations <- data.frame(matrix(c(1,4,1,2,1,3,2,3,3,4,4,2), ncol=2, byrow=T))
relations
```

      X1 X2
    1  1  4
    2  1  2
    3  1  3
    4  2  3
    5  3  4
    6  4  2

``` r
# Getting things done
write.gexf(people, relations)
```

    <?xml version="1.0" encoding="UTF-8"?>
    <gexf xmlns="http://www.gexf.net/1.3" xmlns:viz="http://www.gexf.net/1.3/viz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.gexf.net/1.3 http://www.gexf.net/1.3/gexf.xsd" version="1.3">
      <meta lastmodifieddate="2026-07-08">
        <creator>NodosChile</creator>
        <description>A GEXF file written in R with "rgexf"</description>
        <keywords>GEXF, NodosChile, R, rgexf, Gephi</keywords>
      </meta>
      <graph mode="static" defaultedgetype="undirected">
        <nodes>
          <node id="1" label="juan">
            <viz:color r="255" g="99" b="71" a="1"/>
            <viz:position x="163.952692888871" y="100.415277363797" z="0"/>
            <viz:size value="125"/>
          </node>
          <node id="2" label="pedro">
            <viz:color r="255" g="99" b="71" a="1"/>
            <viz:position x="250" y="235.61426657648" z="0"/>
            <viz:size value="125"/>
          </node>
          <node id="3" label="matthew">
            <viz:color r="255" g="99" b="71" a="1"/>
            <viz:position x="189.744021945668" y="250" z="0"/>
            <viz:size value="125"/>
          </node>
          <node id="4" label="carlos">
            <viz:color r="255" g="99" b="71" a="1"/>
            <viz:position x="-250" y="-250" z="0"/>
            <viz:size value="125"/>
          </node>
        </nodes>
        <edges>
          <edge id="0" source="1" target="4" weight="1"/>
          <edge id="1" source="1" target="2" weight="1"/>
          <edge id="2" source="1" target="3" weight="1"/>
          <edge id="3" source="2" target="3" weight="1"/>
          <edge id="4" source="3" target="4" weight="1"/>
          <edge id="5" source="4" target="2" weight="1"/>
        </edges>
      </graph>
    </gexf>

## Example 3: Dynamic net

``` r
# Defining the dynamic structure, note that there are some nodes that have NA at the end.
time<-matrix(c(10.0,13.0,2.0,2.0,12.0,rep(NA,3)), nrow=4, ncol=2)
time
```

         [,1] [,2]
    [1,]   10   12
    [2,]   13   NA
    [3,]    2   NA
    [4,]    2   NA

``` r
# Getting things done
write.gexf(people, relations, nodeDynamic=time)
```

    <?xml version="1.0" encoding="UTF-8"?>
    <gexf xmlns="http://www.gexf.net/1.3" xmlns:viz="http://www.gexf.net/1.3/viz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.gexf.net/1.3 http://www.gexf.net/1.3/gexf.xsd" version="1.3">
      <meta lastmodifieddate="2026-07-08">
        <creator>NodosChile</creator>
        <description>A GEXF file written in R with "rgexf"</description>
        <keywords>GEXF, NodosChile, R, rgexf, Gephi</keywords>
      </meta>
      <graph mode="dynamic" start="2" end="13" timeformat="double" defaultedgetype="undirected">
        <nodes>
          <node id="1" label="juan" start="10" end="12">
            <viz:color r="255" g="99" b="71" a="1"/>
            <viz:position x="250" y="250" z="0"/>
            <viz:size value="125"/>
          </node>
          <node id="2" label="pedro" start="13" end="13">
            <viz:color r="255" g="99" b="71" a="1"/>
            <viz:position x="-116.286814488559" y="-48.8491528929603" z="0"/>
            <viz:size value="125"/>
          </node>
          <node id="3" label="matthew" start="2" end="13">
            <viz:color r="255" g="99" b="71" a="1"/>
            <viz:position x="193.001175103911" y="-250" z="0"/>
            <viz:size value="125"/>
          </node>
          <node id="4" label="carlos" start="2" end="13">
            <viz:color r="255" g="99" b="71" a="1"/>
            <viz:position x="-250" y="-174.022122416047" z="0"/>
            <viz:size value="125"/>
          </node>
        </nodes>
        <edges>
          <edge id="0" source="1" target="4" weight="1"/>
          <edge id="1" source="1" target="2" weight="1"/>
          <edge id="2" source="1" target="3" weight="1"/>
          <edge id="3" source="2" target="3" weight="1"/>
          <edge id="4" source="3" target="4" weight="1"/>
          <edge id="5" source="4" target="2" weight="1"/>
        </edges>
      </graph>
    </gexf>

## Example 4: More complex… Dynamic graph with attributes both for nodes and edges

First, we define dynamics

``` r
time.nodes<-matrix(c(10.0,13.0,2.0,2.0,12.0,rep(NA,3)), nrow=4, ncol=2)
time.nodes
```

         [,1] [,2]
    [1,]   10   12
    [2,]   13   NA
    [3,]    2   NA
    [4,]    2   NA

``` r
time.edges<-matrix(c(10.0,13.0,2.0,2.0,12.0,1,5,rep(NA,5)), nrow=6, ncol=2)
time.edges
```

         [,1] [,2]
    [1,]   10    5
    [2,]   13   NA
    [3,]    2   NA
    [4,]    2   NA
    [5,]   12   NA
    [6,]    1   NA

Now we define the attribute values

``` r
# Defining a data frame of attributes for nodes and edges
node.att <- data.frame(letrafavorita=letters[1:4], numbers=1:4, stringsAsFactors=F)
node.att
```

      letrafavorita numbers
    1             a       1
    2             b       2
    3             c       3
    4             d       4

``` r
edge.att <- data.frame(letrafavorita=letters[1:6], numbers=1:6, stringsAsFactors=F)
edge.att
```

      letrafavorita numbers
    1             a       1
    2             b       2
    3             c       3
    4             d       4
    5             e       5
    6             f       6

``` r
# Getting the things done
write.gexf(nodes=people, edges=relations, edgeDynamic=time.edges,
           edgesAtt=edge.att, nodeDynamic=time.nodes, nodesAtt=node.att)
```

    <?xml version="1.0" encoding="UTF-8"?>
    <gexf xmlns="http://www.gexf.net/1.3" xmlns:viz="http://www.gexf.net/1.3/viz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.gexf.net/1.3 http://www.gexf.net/1.3/gexf.xsd" version="1.3">
      <meta lastmodifieddate="2026-07-08">
        <creator>NodosChile</creator>
        <description>A GEXF file written in R with "rgexf"</description>
        <keywords>GEXF, NodosChile, R, rgexf, Gephi</keywords>
      </meta>
      <graph mode="dynamic" start="1" end="13" timeformat="double" defaultedgetype="undirected">
        <attributes class="node" mode="static">
          <attribute id="att1" title="letrafavorita" type="string"/>
          <attribute id="att2" title="numbers" type="integer"/>
        </attributes>
        <attributes class="edge" mode="static">
          <attribute id="att1" title="letrafavorita" type="string"/>
          <attribute id="att2" title="numbers" type="integer"/>
        </attributes>
        <nodes>
          <node id="1" label="juan" start="10" end="12">
            <attvalues>
              <attvalue for="att1" value="a"/>
              <attvalue for="att2" value="1"/>
            </attvalues>
            <viz:color r="255" g="99" b="71" a="1"/>
            <viz:position x="250" y="241.156927125917" z="0"/>
            <viz:size value="125"/>
          </node>
          <node id="2" label="pedro" start="13" end="13">
            <attvalues>
              <attvalue for="att1" value="b"/>
              <attvalue for="att2" value="2"/>
            </attvalues>
            <viz:color r="255" g="99" b="71" a="1"/>
            <viz:position x="102.288482685844" y="-250" z="0"/>
            <viz:size value="125"/>
          </node>
          <node id="3" label="matthew" start="2" end="13">
            <attvalues>
              <attvalue for="att1" value="c"/>
              <attvalue for="att2" value="3"/>
            </attvalues>
            <viz:color r="255" g="99" b="71" a="1"/>
            <viz:position x="-250" y="250" z="0"/>
            <viz:size value="125"/>
          </node>
          <node id="4" label="carlos" start="2" end="13">
            <attvalues>
              <attvalue for="att1" value="d"/>
              <attvalue for="att2" value="4"/>
            </attvalues>
            <viz:color r="255" g="99" b="71" a="1"/>
            <viz:position x="42.176120373259" y="-45.0467720735" z="0"/>
            <viz:size value="125"/>
          </node>
        </nodes>
        <edges>
          <edge id="0" source="1" target="4" start="10" end="5" weight="1">
            <attvalues>
              <attvalue for="att1" value="a"/>
              <attvalue for="att2" value="1"/>
            </attvalues>
          </edge>
          <edge id="1" source="1" target="2" start="13" end="13" weight="1">
            <attvalues>
              <attvalue for="att1" value="b"/>
              <attvalue for="att2" value="2"/>
            </attvalues>
          </edge>
          <edge id="2" source="1" target="3" start="2" end="13" weight="1">
            <attvalues>
              <attvalue for="att1" value="c"/>
              <attvalue for="att2" value="3"/>
            </attvalues>
          </edge>
          <edge id="3" source="2" target="3" start="2" end="13" weight="1">
            <attvalues>
              <attvalue for="att1" value="d"/>
              <attvalue for="att2" value="4"/>
            </attvalues>
          </edge>
          <edge id="4" source="3" target="4" start="12" end="13" weight="1">
            <attvalues>
              <attvalue for="att1" value="e"/>
              <attvalue for="att2" value="5"/>
            </attvalues>
          </edge>
          <edge id="5" source="4" target="2" start="1" end="13" weight="1">
            <attvalues>
              <attvalue for="att1" value="f"/>
              <attvalue for="att2" value="6"/>
            </attvalues>
          </edge>
        </edges>
      </graph>
    </gexf>

# Code of Conduct

We welcome contributions to `rgexf`. Whether reporting a bug, starting a
discussion by asking a question, or proposing/requesting a new feature,
please go by creating a new issue
[here](https://github.com/gvegayon/rgexf/issues) so that we can talk
about it.

Please note that the rgexf project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms

# Session info

``` r
devtools::session_info()
```

    ─ Session info ───────────────────────────────────────────────────────────────
     setting  value
     version  R version 4.5.1 (2025-06-13)
     os       macOS Sequoia 15.0.1
     system   aarch64, darwin20
     ui       X11
     language (EN)
     collate  en_US
     ctype    en_US
     tz       America/Denver
     date     2026-07-08
     pandoc   3.8.2.1 @ /usr/local/bin/ (via rmarkdown)
     quarto   1.6.40 @ /usr/local/bin/quarto

    ─ Packages ───────────────────────────────────────────────────────────────────
     package     * version   date (UTC) lib source
     cachem        1.1.0     2024-05-16 [1] RSPM (R 4.5.0)
     cli           3.6.6     2026-04-09 [1] RSPM (R 4.5.0)
     devtools      2.4.5     2022-10-11 [1] RSPM (R 4.5.0)
     digest        0.6.39    2025-11-19 [1] RSPM (R 4.5.0)
     ellipsis      0.3.2     2021-04-29 [1] RSPM (R 4.5.0)
     evaluate      1.0.5     2025-08-27 [1] CRAN (R 4.5.0)
     fastmap       1.2.0     2024-05-15 [1] RSPM (R 4.5.0)
     fs            1.6.6     2025-04-12 [1] RSPM (R 4.5.0)
     glue          1.8.1     2026-04-17 [1] RSPM (R 4.5.0)
     htmltools     0.5.9     2025-12-04 [1] RSPM (R 4.5.0)
     htmlwidgets   1.6.4     2023-12-06 [1] RSPM (R 4.5.0)
     httpuv        1.6.16    2025-04-16 [1] RSPM (R 4.5.0)
     igraph      * 2.3.3     2026-06-26 [1] RSPM (R 4.5.0)
     jsonlite      2.0.0     2025-03-27 [1] RSPM (R 4.5.0)
     knitr         1.51      2025-12-20 [1] CRAN (R 4.5.2)
     later         1.4.7     2026-02-24 [1] RSPM (R 4.5.0)
     lifecycle     1.0.5     2026-01-08 [1] RSPM (R 4.5.0)
     magrittr      2.0.5     2026-04-04 [1] RSPM (R 4.5.0)
     memoise       2.0.1     2021-11-26 [1] RSPM (R 4.5.0)
     mime          0.13      2025-03-17 [1] RSPM (R 4.5.0)
     miniUI        0.1.2     2025-04-17 [1] RSPM (R 4.5.0)
     otel          0.2.0     2025-08-29 [1] CRAN (R 4.5.0)
     pkgbuild      1.4.8     2025-05-26 [1] RSPM (R 4.5.0)
     pkgconfig     2.0.3     2019-09-22 [1] RSPM (R 4.5.0)
     pkgload       1.5.2     2026-04-22 [1] CRAN (R 4.5.2)
     profvis       0.4.0     2024-09-20 [1] RSPM (R 4.5.0)
     promises      1.5.0     2025-11-01 [1] CRAN (R 4.5.0)
     purrr         1.2.1     2026-01-09 [1] RSPM (R 4.5.0)
     R6            2.6.1     2025-02-15 [1] RSPM (R 4.5.0)
     Rcpp          1.1.2     2026-07-05 [1] CRAN (R 4.5.2)
     remotes       2.5.0     2024-03-17 [1] RSPM (R 4.5.0)
     rgexf       * 0.16.4    2026-07-08 [1] local
     rlang         1.2.0     2026-04-06 [1] RSPM (R 4.5.0)
     rmarkdown     2.31      2026-03-26 [1] CRAN (R 4.5.2)
     servr         0.33      2026-06-16 [1] RSPM (R 4.5.0)
     sessioninfo   1.2.3     2025-02-05 [1] RSPM (R 4.5.0)
     shiny         1.13.0    2026-02-20 [1] RSPM (R 4.5.0)
     urlchecker    1.0.1     2021-11-30 [1] RSPM (R 4.5.0)
     usethis       3.1.0     2024-11-26 [1] RSPM (R 4.5.0)
     vctrs         0.7.3     2026-04-11 [1] RSPM (R 4.5.0)
     xfun          0.59      2026-06-19 [1] RSPM (R 4.5.0)
     XML           3.99-0.23 2026-03-20 [1] RSPM (R 4.5.1)
     xtable        1.8-8     2026-02-22 [1] RSPM (R 4.5.0)
     yaml          2.3.12    2025-12-10 [1] RSPM (R 4.5.0)

     [1] /Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/library
     * ── Packages attached to the search path.

    ──────────────────────────────────────────────────────────────────────────────
