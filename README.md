
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/rgexf)](https://cran.r-project.org/package=rgexf)
[![Downloads](http://cranlogs.r-pkg.org/badges/rgexf?color=brightgreen)](https://cran.r-project.org/package=rgexf)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/rgexf)](https://cran.r-project.org/package=rgexf)
[![Travis-CI Build
Status](https://travis-ci.org/gvegayon/rgexf.svg?branch=master)](https://travis-ci.org/gvegayon/rgexf)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/gvegayon/rgexf?branch=master&svg=true)](https://ci.appveyor.com/project/gvegayon/rgexf)
[![Coverage
Status](https://img.shields.io/codecov/c/github/gvegayon/rgexf/master.svg)](https://codecov.io/github/gvegayon/rgexf?branch=master)
[![lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)

# rgexf: Build, Import and Export GEXF Graph Files <img src="man/figures/logo.svg" align="right" height="200"/>

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

  - \[2020-06-12\] Please refer to \[NEWS.md\] for more news.
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
    ##   <meta lastmodifieddate="2021-06-13">
    ##     <creator>NodosChile</creator>
    ##     <description>A GEXF file written in R with "rgexf"</description>
    ##     <keywords>GEXF, NodosChile, R, rgexf, Gephi</keywords>
    ##   </meta>
    ##   <graph mode="static" defaultedgetype="undirected">
    ##     <nodes>
    ##       <node id="1" label="juan">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="-94.9591185968857" y="-100" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="2" label="pedro">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="-100" y="46.0826743556705" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="3" label="matthew">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="23.8647662870158" y="96.9051340252578" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="4" label="carlos">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="100" y="100" z="0"/>
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
    ##   <meta lastmodifieddate="2021-06-13">
    ##     <creator>NodosChile</creator>
    ##     <description>A GEXF file written in R with "rgexf"</description>
    ##     <keywords>GEXF, NodosChile, R, rgexf, Gephi</keywords>
    ##   </meta>
    ##   <graph mode="dynamic" start="10" end="2" timeformat="double" defaultedgetype="undirected">
    ##     <nodes>
    ##       <node id="1" label="juan" start="10" end="12">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="100" y="-100" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="2" label="pedro" start="13" end="2">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="-19.3500467608754" y="-74.6672521656976" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="3" label="matthew" start="2" end="2">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="-100" y="100" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="4" label="carlos" start="2" end="2">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="-70.0800701960264" y="-13.5772745940554" z="0"/>
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
    ##   <meta lastmodifieddate="2021-06-13">
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
    ##         <viz:position x="100" y="81.1081592078988" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="2" label="pedro" start="13" end="5">
    ##         <attvalues>
    ##           <attvalue for="att1" value="b"/>
    ##           <attvalue for="att2" value="2"/>
    ##         </attvalues>
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="-100" y="-100" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="3" label="matthew" start="2" end="5">
    ##         <attvalues>
    ##           <attvalue for="att1" value="c"/>
    ##           <attvalue for="att2" value="3"/>
    ##         </attvalues>
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="99.3920588156637" y="100" z="0"/>
    ##         <viz:size value="10"/>
    ##       </node>
    ##       <node id="4" label="carlos" start="2" end="5">
    ##         <attvalues>
    ##           <attvalue for="att1" value="d"/>
    ##           <attvalue for="att2" value="4"/>
    ##         </attvalues>
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="97.0013444404504" y="-39.2128266101758" z="0"/>
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
    ##  version  R version 4.1.0 (2021-05-18)
    ##  os       Ubuntu 18.04.5 LTS          
    ##  system   x86_64, linux-gnu           
    ##  ui       X11                         
    ##  language en_US:en                    
    ##  collate  en_US.UTF-8                 
    ##  ctype    en_US.UTF-8                 
    ##  tz       America/Los_Angeles         
    ##  date     2021-06-13                  
    ## 
    ## ─ Packages ───────────────────────────────────────────────────────────────────
    ##  package     * version  date       lib source        
    ##  cachem        1.0.5    2021-05-15 [1] CRAN (R 4.1.0)
    ##  callr         3.7.0    2021-04-20 [1] CRAN (R 4.1.0)
    ##  cli           2.5.0    2021-04-26 [1] CRAN (R 4.1.0)
    ##  crayon        1.4.1    2021-02-08 [1] CRAN (R 4.1.0)
    ##  desc          1.3.0    2021-03-05 [1] CRAN (R 4.1.0)
    ##  devtools      2.4.2    2021-06-07 [1] CRAN (R 4.1.0)
    ##  digest        0.6.27   2020-10-24 [1] CRAN (R 4.1.0)
    ##  ellipsis      0.3.2    2021-04-29 [1] CRAN (R 4.1.0)
    ##  evaluate      0.14     2019-05-28 [1] CRAN (R 4.1.0)
    ##  fastmap       1.1.0    2021-01-25 [1] CRAN (R 4.1.0)
    ##  fs            1.5.0    2020-07-31 [1] CRAN (R 4.1.0)
    ##  glue          1.4.2    2020-08-27 [1] CRAN (R 4.1.0)
    ##  htmltools     0.5.1.1  2021-01-22 [1] CRAN (R 4.1.0)
    ##  httpuv        1.6.1    2021-05-07 [1] CRAN (R 4.1.0)
    ##  igraph        1.2.6    2020-10-06 [1] CRAN (R 4.1.0)
    ##  jsonlite      1.7.2    2020-12-09 [1] CRAN (R 4.1.0)
    ##  knitr         1.33     2021-04-24 [1] CRAN (R 4.1.0)
    ##  later         1.2.0    2021-04-23 [1] CRAN (R 4.1.0)
    ##  lifecycle     1.0.0    2021-02-15 [1] CRAN (R 4.1.0)
    ##  magrittr      2.0.1    2020-11-17 [1] CRAN (R 4.1.0)
    ##  memoise       2.0.0    2021-01-26 [1] CRAN (R 4.1.0)
    ##  pkgbuild      1.2.0    2020-12-15 [1] CRAN (R 4.1.0)
    ##  pkgconfig     2.0.3    2019-09-22 [1] CRAN (R 4.1.0)
    ##  pkgload       1.2.1    2021-04-06 [1] CRAN (R 4.1.0)
    ##  prettyunits   1.1.1    2020-01-24 [1] CRAN (R 4.1.0)
    ##  processx      3.5.2    2021-04-30 [1] CRAN (R 4.1.0)
    ##  promises      1.2.0.1  2021-02-11 [1] CRAN (R 4.1.0)
    ##  ps            1.6.0    2021-02-28 [1] CRAN (R 4.1.0)
    ##  purrr         0.3.4    2020-04-17 [1] CRAN (R 4.1.0)
    ##  R6            2.5.0    2020-10-28 [1] CRAN (R 4.1.0)
    ##  Rcpp          1.0.6    2021-01-15 [1] CRAN (R 4.1.0)
    ##  remotes       2.3.0    2021-04-01 [1] CRAN (R 4.1.0)
    ##  rgexf       * 0.16.0   2021-06-13 [1] local         
    ##  rlang         0.4.11   2021-04-30 [1] CRAN (R 4.1.0)
    ##  rmarkdown     2.8      2021-05-07 [1] CRAN (R 4.1.0)
    ##  rprojroot     2.0.2    2020-11-15 [1] CRAN (R 4.1.0)
    ##  servr         0.22     2021-04-14 [1] CRAN (R 4.1.0)
    ##  sessioninfo   1.1.1    2018-11-05 [1] CRAN (R 4.1.0)
    ##  stringi       1.6.2    2021-05-17 [1] CRAN (R 4.1.0)
    ##  stringr       1.4.0    2019-02-10 [1] CRAN (R 4.1.0)
    ##  testthat      3.0.2    2021-02-14 [1] CRAN (R 4.1.0)
    ##  usethis       2.0.1    2021-02-10 [1] CRAN (R 4.1.0)
    ##  withr         2.4.2    2021-04-18 [1] CRAN (R 4.1.0)
    ##  xfun          0.23     2021-05-15 [1] CRAN (R 4.1.0)
    ##  XML           3.99-0.6 2021-03-16 [1] CRAN (R 4.1.0)
    ##  yaml          2.2.1    2020-02-01 [1] CRAN (R 4.1.0)
    ## 
    ## [1] /home/george/R/x86_64-pc-linux-gnu-library/4.1
    ## [2] /usr/local/lib/R/site-library
    ## [3] /usr/lib/R/site-library
    ## [4] /usr/lib/R/library
