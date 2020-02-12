rgexf: Build, Import and Export GEXF Graph Files
================

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/rgexf)](https://cran.r-project.org/package=rgexf) [![Downloads](http://cranlogs.r-pkg.org/badges/rgexf?color=brightgreen)](http://cran.rstudio.com/package=rgexf) [![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/rgexf)](http://cran.rstudio.com/package=rgexf) [![Travis-CI Build Status](https://travis-ci.org/gvegayon/rgexf.svg?branch=master)](https://travis-ci.org/gvegayon/rgexf) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/gvegayon/rgexf?branch=master&svg=true)](https://ci.appveyor.com/project/gvegayon/rgexf) [![Coverage Status](https://img.shields.io/codecov/c/github/gvegayon/rgexf/master.svg)](https://codecov.io/github/gvegayon/rgexf?branch=master)

The first R package to work with GEXF graph files (used in Gephi and others). Using XML library, it allows the user to easily build/read graph files including attributes, GEXF viz attributes (such as colour, size, and position), network dynamics (for both edges and nodes, including spells) and edges weighting. Users can build/handle graphs element-by-element or massively through data-frames, visualize the graph on a web browser through ~~sigmajs javascript~~ [gexf-js](https://github.com/raphv/gexf-js) library and interact with the igraph package.

News
----

-   \[2016-11-08\] Restarting the project.
-   \[2015-02-03\] Version 0.15.2.3 of rgexf is on CRAN. Just updating emails...
-   \[2014-03-10\] Version 0.14.9 of rgexf is on CRAN! solves issues 15-18. Thanks =).
-   \[2013-08-07\] Version 0.13.8 of rgexf is on CRAN! New plot.gexf method and igraph integration working =).
-   \[2013-05-09\] Version 0.13.05 of rgexf (transitory) solves issues N 9 & 10. Looking forward for the next CRAN version.
-   \[2013-03-14\] Version 0.13.03 of rgexf is on its way to CRAN. It now supports working with spells!
-   \[2013-01-04\] Version 0.13.01 of rgexf is on its way to CRAN. Significant improvements and new features!
-   \[2012-06-19\] Version 0.12.06 of rgexf is on CRAN! Now it can be directly download from R.
-   \[2012-03-29\] Version 0.12.03.29 of rgexf has been released including many bug fixes. Please download the latest version to check it out.

Installation
------------

To install the latest version of `rgexf` you can use `devtools`

``` r
library(devtools)
install_github("gvegayon/rgexf")
```

The more stable (but old) version of `rgexf` can be found on cran too:

    install.packages("rgexf")

Example 1: Static net
---------------------

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
    ##   <meta lastmodifieddate="2017-11-13">
    ##     <creator>NodosChile</creator>
    ##     <description>A GEXF file written in R with "rgexf"</description>
    ##     <keywords>GEXF, NodosChile, R, rgexf, Gephi</keywords>
    ##   </meta>
    ##   <graph mode="static" defaultedgetype="undirected">
    ##     <nodes>
    ##       <node id="1" label="juan">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="52.0639630965889" y="-94.8048901744187" z="0"/>
    ##         <viz:size value="3.10406068805605"/>
    ##       </node>
    ##       <node id="2" label="pedro">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="21.2372082285583" y="73.1311740353703" z="0"/>
    ##         <viz:size value="3.10406068805605"/>
    ##       </node>
    ##       <node id="3" label="matthew">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="187.268371134996" y="-148.024958837777" z="0"/>
    ##         <viz:size value="3.10406068805605"/>
    ##       </node>
    ##       <node id="4" label="carlos">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="133.985258545727" y="162.381109967828" z="0"/>
    ##         <viz:size value="3.10406068805605"/>
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

Example 2: Dynamic net
----------------------

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
    ##   <meta lastmodifieddate="2017-11-13">
    ##     <creator>NodosChile</creator>
    ##     <description>A GEXF file written in R with "rgexf"</description>
    ##     <keywords>GEXF, NodosChile, R, rgexf, Gephi</keywords>
    ##   </meta>
    ##   <graph mode="dynamic" start="10" end="2" timeformat="double" defaultedgetype="undirected">
    ##     <nodes>
    ##       <node id="1" label="juan" start="10" end="12">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="10.3595019318163" y="-55.2962249144912" z="0"/>
    ##         <viz:size value="2.0540074557066"/>
    ##       </node>
    ##       <node id="2" label="pedro" start="13" end="2">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="-85.4386020451784" y="-152.502709627151" z="0"/>
    ##         <viz:size value="2.0540074557066"/>
    ##       </node>
    ##       <node id="3" label="matthew" start="2" end="2">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="-14.4910593517125" y="-0.558461435139179" z="0"/>
    ##         <viz:size value="2.0540074557066"/>
    ##       </node>
    ##       <node id="4" label="carlos" start="2" end="2">
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="106.204542052001" y="52.8980359435081" z="0"/>
    ##         <viz:size value="2.0540074557066"/>
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

Example 3: More complex... Dynamic graph with attributes both for nodes and edges
---------------------------------------------------------------------------------

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
    ##   <meta lastmodifieddate="2017-11-13">
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
    ##         <viz:position x="49.2411283776164" y="-175.18544672057" z="0"/>
    ##         <viz:size value="2.28561248257756"/>
    ##       </node>
    ##       <node id="2" label="pedro" start="13" end="5">
    ##         <attvalues>
    ##           <attvalue for="att1" value="b"/>
    ##           <attvalue for="att2" value="2"/>
    ##         </attvalues>
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="-123.652352951467" y="-121.231841016561" z="0"/>
    ##         <viz:size value="2.28561248257756"/>
    ##       </node>
    ##       <node id="3" label="matthew" start="2" end="5">
    ##         <attvalues>
    ##           <attvalue for="att1" value="c"/>
    ##           <attvalue for="att2" value="3"/>
    ##         </attvalues>
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="-179.32011988014" y="-15.3864706866443" z="0"/>
    ##         <viz:size value="2.28561248257756"/>
    ##       </node>
    ##       <node id="4" label="carlos" start="2" end="5">
    ##         <attvalues>
    ##           <attvalue for="att1" value="d"/>
    ##           <attvalue for="att2" value="4"/>
    ##         </attvalues>
    ##         <viz:color r="255" g="99" b="71" a="1"/>
    ##         <viz:position x="-48.9882820285857" y="-104.820774961263" z="0"/>
    ##         <viz:size value="2.28561248257756"/>
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

Session info
============

``` r
devtools::session_info()
```

    ## ─ Session info ──────────────────────────────────────────────────────────
    ##  setting  value                       
    ##  version  R version 3.4.2 (2017-09-28)
    ##  os       Ubuntu 14.04.5 LTS          
    ##  system   x86_64, linux-gnu           
    ##  ui       X11                         
    ##  language en_US                       
    ##  collate  en_US.UTF-8                 
    ##  tz       America/Los_Angeles         
    ##  date     2017-11-13                  
    ## 
    ## ─ Packages ──────────────────────────────────────────────────────────────
    ##  package     * version     date       source                            
    ##  assertthat    0.2.0       2017-04-11 CRAN (R 3.4.0)                    
    ##  backports     1.1.1       2017-09-25 CRAN (R 3.4.1)                    
    ##  cli           1.0.0       2017-11-10 Github (r-lib/cli@ab1c3aa)        
    ##  clisymbols    1.2.0       2017-05-21 CRAN (R 3.4.2)                    
    ##  crayon        1.3.4       2017-09-16 CRAN (R 3.4.1)                    
    ##  desc          1.1.1       2017-08-03 CRAN (R 3.4.1)                    
    ##  devtools      1.13.3.9000 2017-11-10 Github (hadley/devtools@25315a6)  
    ##  digest        0.6.12      2017-01-27 CRAN (R 3.4.0)                    
    ##  evaluate      0.10.1      2017-06-24 CRAN (R 3.4.0)                    
    ##  htmltools     0.3.6       2017-04-28 CRAN (R 3.4.0)                    
    ##  httpuv        1.3.5       2017-07-04 CRAN (R 3.4.1)                    
    ##  igraph        1.1.2       2017-07-21 CRAN (R 3.4.1)                    
    ##  knitr         1.17        2017-08-10 CRAN (R 3.4.1)                    
    ##  magrittr      1.5         2014-11-22 CRAN (R 3.4.0)                    
    ##  memoise       1.1.0       2017-04-21 CRAN (R 3.4.0)                    
    ##  pkgbuild      0.0.0.9000  2017-11-10 Github (r-lib/pkgbuild@a70858f)   
    ##  pkgconfig     2.0.1       2017-03-21 CRAN (R 3.4.0)                    
    ##  pkgload       0.0.0.9000  2017-11-10 Github (r-lib/pkgload@70eaef8)    
    ##  R6            2.2.2       2017-06-17 CRAN (R 3.4.0)                    
    ##  Rcpp          0.12.13     2017-09-28 CRAN (R 3.4.1)                    
    ##  rgexf       * 0.16.0      2017-11-13 local                             
    ##  rlang         0.1.4.9000  2017-11-10 Github (tidyverse/rlang@762ba98)  
    ##  rmarkdown     1.7         2017-11-10 CRAN (R 3.4.2)                    
    ##  rprojroot     1.2         2017-01-16 CRAN (R 3.4.0)                    
    ##  servr         0.7         2017-08-17 CRAN (R 3.4.1)                    
    ##  sessioninfo   1.0.1.9000  2017-11-10 Github (r-lib/sessioninfo@c871d01)
    ##  stringi       1.1.5       2017-04-07 CRAN (R 3.4.0)                    
    ##  stringr       1.2.0       2017-02-18 CRAN (R 3.4.0)                    
    ##  testthat      1.0.2.9000  2017-11-10 Github (hadley/testthat@7be97ba)  
    ##  usethis       1.0.0.9000  2017-11-10 Github (r-lib/usethis@61d97e9)    
    ##  withr         2.1.0       2017-11-01 CRAN (R 3.4.2)                    
    ##  XML           3.98-1.9    2017-06-19 CRAN (R 3.4.1)                    
    ##  yaml          2.1.14      2016-11-12 CRAN (R 3.4.0)
