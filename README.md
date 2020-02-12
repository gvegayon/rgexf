rgexf: Build, Import and Export GEXF Graph Files
================

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/rgexf)](https://cran.r-project.org/package=rgexf)
[![Downloads](http://cranlogs.r-pkg.org/badges/rgexf?color=brightgreen)](http://cran.rstudio.com/package=rgexf)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/rgexf)](http://cran.rstudio.com/package=rgexf)
[![Travis-CI Build
Status](https://travis-ci.org/gvegayon/rgexf.svg?branch=master)](https://travis-ci.org/gvegayon/rgexf)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/gvegayon/rgexf?branch=master&svg=true)](https://ci.appveyor.com/project/gvegayon/rgexf)
[![Coverage
Status](https://img.shields.io/codecov/c/github/gvegayon/rgexf/master.svg)](https://codecov.io/github/gvegayon/rgexf?branch=master)
[![lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)

The first R package to work with GEXF graph files (used in Gephi and
others). Using XML library, it allows the user to easily build/read
graph files including attributes, GEXF viz attributes (such as color,
size, and position), network dynamics (for both edges and nodes,
including spells) and edges weighting. Users can build/handle graphs
element-by-element or massively through data-frames, visualize the graph
on a web browser through ~~sigmajs javascript~~
[gexf-js](https://github.com/raphv/gexf-js) library and interact with
the igraph package.

## News

  - \[2020-02-11\] Getting ready to put the package on CRAN again (was
    taken out in the last version).
  - \[2016-11-08\] Restarting the project.
  - \[2015-02-03\] Version 0.15.2.3 of rgexf is on CRAN. Just updating
    emails…
  - \[2014-03-10\] Version 0.14.9 of rgexf is on CRAN\! solves issues
    15-18. Thanks =).
  - \[2013-08-07\] Version 0.13.8 of rgexf is on CRAN\! New plot.gexf
    method and igraph integration working =).
  - \[2013-05-09\] Version 0.13.05 of rgexf (transitory) solves issues N
    9 & 10. Looking forward for the next CRAN version.
  - \[2013-03-14\] Version 0.13.03 of rgexf is on its way to CRAN. It
    now supports working with spells\!
  - \[2013-01-04\] Version 0.13.01 of rgexf is on its way to CRAN.
    Significant improvements and new features\!
  - \[2012-06-19\] Version 0.12.06 of rgexf is on CRAN\! Now it can be
    directly download from R.
  - \[2012-03-29\] Version 0.12.03.29 of rgexf has been released
    including many bug fixes. Please download the latest version to
    check it out.

## Installation

To install the latest version of `rgexf` you can use `devtools`

``` r
library(devtools)
install_github("gvegayon/rgexf")
```

The more stable (but old) version of `rgexf` can be found on CRAN too:

    install.packages("rgexf")

## Example 1: Static net

``` r
# Loading the package
library(rgexf)

# Creating a group of individuals and their relations
people <- data.frame(matrix(c(1:4, 'juan', 'pedro', 'matthew', 'carlos'),ncol=2))
people
```

    ##   X1      X2
    ## 1  1    juan
    ## 2  2   pedro
    ## 3  3 matthew
    ## 4  4  carlos

``` r
# Defining the relations structure
relations <- data.frame(matrix(c(1,4,1,2,1,3,2,3,3,4,4,2), ncol=2, byrow=T))
relations
```

    ##   X1 X2
    ## 1  1  4
    ## 2  1  2
    ## 3  1  3
    ## 4  2  3
    ## 5  3  4
    ## 6  4  2

``` r
# Getting things done
write.gexf(people, relations)
```

    ## <?xml version="1.0" encoding="UTF-8"?>
    ## <gexf xmlns="http://www.gexf.net/1.3" xmlns:viz="http://www.gexf.net/1.3/viz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.gexf.net/1.3 http://www.gexf.net/1.3/gexf.xsd" version="1.3">
    ##   <meta lastmodifieddate="2020-02-12">
    ##     <creator>NodosChile</creator>
    ##     <description>A GEXF file written in R with "rgexf"</description>
    ##     <keywords>GEXF, NodosChile, R, rgexf, Gephi</keywords>
    ##   </meta>
    ##   <graph mode="static" defaultedgetype="undirected">
    ##     <nodes>
    ##       <node id="1" label="juan">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="-95.1687037085758" y="43.3767870714206" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="2" label="pedro">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="100" y="100" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="3" label="matthew">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="84.0510016792046" y="97.2288410137525" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="4" label="carlos">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="-100" y="-100" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##     </nodes>
    ##     <edges>
    ##       <edge id="0" source="1" target="4" weight="1"/>
    ##       <edge id="1" source="1" target="2" weight="1"/>
    ##       <edge id="2" source="1" target="3" weight="1"/>
    ##       <edge id="3" source="2" target="3" weight="1"/>
    ##       <edge id="4" source="3" target="4" weight="1"/>
    ##       <edge id="5" source="4" target="2" weight="1"/>
    ##     </edges>
    ##   </graph>
    ## </gexf>

## Example 2: Dynamic net

``` r
# Defining the dynamic structure, note that there are some nodes that have NA at the end.
time<-matrix(c(10.0,13.0,2.0,2.0,12.0,rep(NA,3)), nrow=4, ncol=2)
time
```

    ##      [,1] [,2]
    ## [1,]   10   12
    ## [2,]   13   NA
    ## [3,]    2   NA
    ## [4,]    2   NA

``` r
# Getting things done
write.gexf(people, relations, nodeDynamic=time)
```

    ## <?xml version="1.0" encoding="UTF-8"?>
    ## <gexf xmlns="http://www.gexf.net/1.3" xmlns:viz="http://www.gexf.net/1.3/viz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.gexf.net/1.3 http://www.gexf.net/1.3/gexf.xsd" version="1.3">
    ##   <meta lastmodifieddate="2020-02-12">
    ##     <creator>NodosChile</creator>
    ##     <description>A GEXF file written in R with "rgexf"</description>
    ##     <keywords>GEXF, NodosChile, R, rgexf, Gephi</keywords>
    ##   </meta>
    ##   <graph mode="dynamic" start="10" end="2" timeformat="double" defaultedgetype="undirected">
    ##     <nodes>
    ##       <node id="1" label="juan" start="10" end="12">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="8.69995796890845" y="-100" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="2" label="pedro" start="13" end="2">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="7.57043641001687" y="-6.25453187015135" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="3" label="matthew" start="2" end="2">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="-100" y="100" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="4" label="carlos" start="2" end="2">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="100" y="13.6866893894283" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##     </nodes>
    ##     <edges>
    ##       <edge id="0" source="1" target="4" weight="1"/>
    ##       <edge id="1" source="1" target="2" weight="1"/>
    ##       <edge id="2" source="1" target="3" weight="1"/>
    ##       <edge id="3" source="2" target="3" weight="1"/>
    ##       <edge id="4" source="3" target="4" weight="1"/>
    ##       <edge id="5" source="4" target="2" weight="1"/>
    ##     </edges>
    ##   </graph>
    ## </gexf>

## Example 3: More complex… Dynamic graph with attributes both for nodes and edges

First we define dynamics

``` r
time.nodes<-matrix(c(10.0,13.0,2.0,2.0,12.0,rep(NA,3)), nrow=4, ncol=2)
time.nodes
```

    ##      [,1] [,2]
    ## [1,]   10   12
    ## [2,]   13   NA
    ## [3,]    2   NA
    ## [4,]    2   NA

``` r
time.edges<-matrix(c(10.0,13.0,2.0,2.0,12.0,1,5,rep(NA,5)), nrow=6, ncol=2)
time.edges
```

    ##      [,1] [,2]
    ## [1,]   10    5
    ## [2,]   13   NA
    ## [3,]    2   NA
    ## [4,]    2   NA
    ## [5,]   12   NA
    ## [6,]    1   NA

Now we define the attribute values

``` r
# Defining a data frame of attributes for nodes and edges
node.att <- data.frame(letrafavorita=letters[1:4], numbers=1:4, stringsAsFactors=F)
node.att
```

    ##   letrafavorita numbers
    ## 1             a       1
    ## 2             b       2
    ## 3             c       3
    ## 4             d       4

``` r
edge.att <- data.frame(letrafavorita=letters[1:6], numbers=1:6, stringsAsFactors=F)
edge.att
```

    ##   letrafavorita numbers
    ## 1             a       1
    ## 2             b       2
    ## 3             c       3
    ## 4             d       4
    ## 5             e       5
    ## 6             f       6

``` r
# Getting the things done
write.gexf(nodes=people, edges=relations, edgeDynamic=time.edges,
           edgesAtt=edge.att, nodeDynamic=time.nodes, nodesAtt=node.att)
```

    ## <?xml version="1.0" encoding="UTF-8"?>
    ## <gexf xmlns="http://www.gexf.net/1.3" xmlns:viz="http://www.gexf.net/1.3/viz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.gexf.net/1.3 http://www.gexf.net/1.3/gexf.xsd" version="1.3">
    ##   <meta lastmodifieddate="2020-02-12">
    ##     <creator>NodosChile</creator>
    ##     <description>A GEXF file written in R with "rgexf"</description>
    ##     <keywords>GEXF, NodosChile, R, rgexf, Gephi</keywords>
    ##   </meta>
    ##   <graph mode="dynamic" start="1" end="5" timeformat="double" defaultedgetype="undirected">
    ##     <attributes class="node" mode="static">
    ##       <attribute id="att1" title="letrafavorita" type="string"/>
    ##       <attribute id="att2" title="numbers" type="integer"/>
    ##     </attributes>
    ##     <attributes class="edge" mode="static">
    ##       <attribute id="att1" title="letrafavorita" type="string"/>
    ##       <attribute id="att2" title="numbers" type="integer"/>
    ##     </attributes>
    ##     <nodes>
    ##       <node id="1" label="juan" start="10" end="12">
    ##         <attvalues>
    ##           <attvalue for="att1" value="a"/>
    ##           <attvalue for="att2" value="1"/>
    ##         </attvalues>
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="100" y="20.7314073894003" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="2" label="pedro" start="13" end="5">
    ##         <attvalues>
    ##           <attvalue for="att1" value="b"/>
    ##           <attvalue for="att2" value="2"/>
    ##         </attvalues>
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="74.0563139263937" y="100" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="3" label="matthew" start="2" end="5">
    ##         <attvalues>
    ##           <attvalue for="att1" value="c"/>
    ##           <attvalue for="att2" value="3"/>
    ##         </attvalues>
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="-100" y="59.5548391318837" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="4" label="carlos" start="2" end="5">
    ##         <attvalues>
    ##           <attvalue for="att1" value="d"/>
    ##           <attvalue for="att2" value="4"/>
    ##         </attvalues>
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="-66.2251818605173" y="-100" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##     </nodes>
    ##     <edges>
    ##       <edge id="0" source="1" target="4" start="10" end="5" weight="1">
    ##         <attvalues>
    ##           <attvalue for="att1" value="a"/>
    ##           <attvalue for="att2" value="1"/>
    ##         </attvalues>
    ##       </edge>
    ##       <edge id="1" source="1" target="2" start="13" end="5" weight="1">
    ##         <attvalues>
    ##           <attvalue for="att1" value="b"/>
    ##           <attvalue for="att2" value="2"/>
    ##         </attvalues>
    ##       </edge>
    ##       <edge id="2" source="1" target="3" start="2" end="5" weight="1">
    ##         <attvalues>
    ##           <attvalue for="att1" value="c"/>
    ##           <attvalue for="att2" value="3"/>
    ##         </attvalues>
    ##       </edge>
    ##       <edge id="3" source="2" target="3" start="2" end="5" weight="1">
    ##         <attvalues>
    ##           <attvalue for="att1" value="d"/>
    ##           <attvalue for="att2" value="4"/>
    ##         </attvalues>
    ##       </edge>
    ##       <edge id="4" source="3" target="4" start="12" end="5" weight="1">
    ##         <attvalues>
    ##           <attvalue for="att1" value="e"/>
    ##           <attvalue for="att2" value="5"/>
    ##         </attvalues>
    ##       </edge>
    ##       <edge id="5" source="4" target="2" start="1" end="5" weight="1">
    ##         <attvalues>
    ##           <attvalue for="att1" value="f"/>
    ##           <attvalue for="att2" value="6"/>
    ##         </attvalues>
    ##       </edge>
    ##     </edges>
    ##   </graph>
    ## </gexf>

# Session info

``` r
devtools::session_info()
```

    ## ─ Session info ───────────────────────────────────────────────────────────────
    ##  setting  value                       
    ##  version  R version 3.6.2 (2019-12-12)
    ##  os       Ubuntu 18.04.4 LTS          
    ##  system   x86_64, linux-gnu           
    ##  ui       X11                         
    ##  language (EN)                        
    ##  collate  en_US.UTF-8                 
    ##  ctype    en_US.UTF-8                 
    ##  tz       America/Los_Angeles         
    ##  date     2020-02-12                  
    ## 
    ## ─ Packages ───────────────────────────────────────────────────────────────────
    ##  package     * version  date       lib source        
    ##  assertthat    0.2.1    2019-03-21 [1] CRAN (R 3.6.1)
    ##  backports     1.1.5    2019-10-02 [1] CRAN (R 3.6.1)
    ##  callr         3.4.1    2020-01-24 [1] CRAN (R 3.6.2)
    ##  cli           2.0.1    2020-01-08 [1] CRAN (R 3.6.2)
    ##  crayon        1.3.4    2017-09-16 [1] CRAN (R 3.6.1)
    ##  desc          1.2.0    2018-05-01 [1] CRAN (R 3.6.1)
    ##  devtools      2.2.1    2019-09-24 [1] CRAN (R 3.6.1)
    ##  digest        0.6.23   2019-11-23 [1] CRAN (R 3.6.1)
    ##  ellipsis      0.3.0    2019-09-20 [1] CRAN (R 3.6.1)
    ##  evaluate      0.14     2019-05-28 [1] CRAN (R 3.6.1)
    ##  fansi         0.4.1    2020-01-08 [1] CRAN (R 3.6.2)
    ##  fs            1.3.1    2019-05-06 [1] CRAN (R 3.6.1)
    ##  glue          1.3.1    2019-03-12 [1] CRAN (R 3.6.1)
    ##  htmltools     0.4.0    2019-10-04 [1] CRAN (R 3.6.1)
    ##  httpuv        1.5.2    2019-09-11 [1] CRAN (R 3.6.1)
    ##  igraph        1.2.4.2  2019-11-27 [1] CRAN (R 3.6.1)
    ##  jsonlite      1.6      2018-12-07 [1] CRAN (R 3.6.1)
    ##  knitr         1.27     2020-01-16 [1] CRAN (R 3.6.2)
    ##  later         1.0.0    2019-10-04 [1] CRAN (R 3.6.1)
    ##  magrittr      1.5      2014-11-22 [1] CRAN (R 3.6.1)
    ##  memoise       1.1.0    2017-04-21 [1] CRAN (R 3.6.1)
    ##  pkgbuild      1.0.6    2019-10-09 [1] CRAN (R 3.6.1)
    ##  pkgconfig     2.0.3    2019-09-22 [1] CRAN (R 3.6.1)
    ##  pkgload       1.0.2    2018-10-29 [1] CRAN (R 3.6.1)
    ##  prettyunits   1.1.1    2020-01-24 [1] CRAN (R 3.6.2)
    ##  processx      3.4.1    2019-07-18 [1] CRAN (R 3.6.1)
    ##  promises      1.1.0    2019-10-04 [1] CRAN (R 3.6.1)
    ##  ps            1.3.0    2018-12-21 [1] CRAN (R 3.6.1)
    ##  R6            2.4.1    2019-11-12 [1] CRAN (R 3.6.1)
    ##  Rcpp          1.0.3    2019-11-08 [1] CRAN (R 3.6.1)
    ##  remotes       2.1.0    2019-06-24 [1] CRAN (R 3.6.1)
    ##  rgexf       * 0.15.999 2020-01-31 [1] local         
    ##  rlang         0.4.4    2020-01-28 [1] CRAN (R 3.6.2)
    ##  rmarkdown     2.1      2020-01-20 [1] CRAN (R 3.6.2)
    ##  rprojroot     1.3-2    2018-01-03 [1] CRAN (R 3.6.1)
    ##  servr         0.15     2019-08-07 [1] CRAN (R 3.6.1)
    ##  sessioninfo   1.1.1    2018-11-05 [1] CRAN (R 3.6.1)
    ##  stringi       1.4.5    2020-01-11 [1] CRAN (R 3.6.2)
    ##  stringr       1.4.0    2019-02-10 [1] CRAN (R 3.6.1)
    ##  testthat      2.3.1    2019-12-01 [1] CRAN (R 3.6.1)
    ##  usethis       1.5.1    2019-07-04 [1] CRAN (R 3.6.1)
    ##  withr         2.1.2    2018-03-15 [1] CRAN (R 3.6.1)
    ##  xfun          0.12     2020-01-13 [1] CRAN (R 3.6.2)
    ##  XML           3.99-0.3 2020-01-20 [1] CRAN (R 3.6.2)
    ##  yaml          2.2.0    2018-07-25 [1] CRAN (R 3.6.1)
    ## 
    ## [1] /home/george/R/x86_64-pc-linux-gnu-library/3.6
    ## [2] /usr/local/lib/R/site-library
    ## [3] /usr/lib/R/site-library
    ## [4] /usr/lib/R/library
