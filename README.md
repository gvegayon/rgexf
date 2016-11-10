
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/rgexf)](https://cran.r-project.org/package=rgexf) [![Downloads](http://cranlogs.r-pkg.org/badges/rgexf?color=brightgreen)](http://cran.rstudio.com/package=rgexf) [![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/rgexf)](http://cran.rstudio.com/package=rgexf) [![Travis-CI Build Status](https://travis-ci.org/gvegayon/rgexf.svg?branch=master)](https://travis-ci.org/gvegayon/rgexf) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/gvegayon/rgexf?branch=master&svg=true)](https://ci.appveyor.com/project/gvegayon/rgexf) [![Coverage Status](https://img.shields.io/codecov/c/github/gvegayon/rgexf/master.svg)](https://codecov.io/github/gvegayon/rgexf?branch=master)

rgexf: Build, Import and Export GEXF Graph Files
================================================

The first R package to work with GEXF graph files (used in Gephi and others). Using XML library, it allows the user to easily build/read graph files including attributes, GEXF viz attributes (such as colour, size, and position), network dynamics (for both edges and nodes, including spells) and edges weighting. Users can build/handle graphs element-by-element or massively through data-frames, visualize the graph on a web browser through sigmajs javascript library and interact with the igraph package.

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
-   \[2012-03-29\] Version 0.12.03.29 of rgexf has been released including many bug fixes. Please download the lastest version to check it out.

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

    ## Warning in write.gexf(people, relations): In future versions, rgexf 2.0,
    ## this function will be the equivalent of -print(..., file=)-, and replaced
    ## by -gexf-

    ## <?xml version="1.0" encoding="UTF-8"?>
    ## <gexf xmlns="http://www.gexf.net/1.3" xmlns:viz="http://www.gexf.net/1.3/viz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.gexf.net/1.3 http://www.gexf.net/1.3/gexf.xsd" version="1.3">
    ##   <meta lastmodifieddate="2016-11-10">
    ##     <creator>NodosChile</creator>
    ##     <description>A graph file writing in R using "rgexf"</description>
    ##     <keywords>gexf graph, NodosChile, R, rgexf</keywords>
    ##   </meta>
    ##   <graph mode="static" defaultedgetype="undirected">
    ##     <nodes>
    ##       <node id="1" label="juan"/>
    ##       <node id="2" label="pedro"/>
    ##       <node id="3" label="matthew"/>
    ##       <node id="4" label="carlos"/>
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

    ## Warning in write.gexf(people, relations, nodeDynamic = time): In future
    ## versions, rgexf 2.0, this function will be the equivalent of -print(...,
    ## file=)-, and replaced by -gexf-

    ## <?xml version="1.0" encoding="UTF-8"?>
    ## <gexf xmlns="http://www.gexf.net/1.3" xmlns:viz="http://www.gexf.net/1.3/viz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.gexf.net/1.3 http://www.gexf.net/1.3/gexf.xsd" version="1.3">
    ##   <meta lastmodifieddate="2016-11-10">
    ##     <creator>NodosChile</creator>
    ##     <description>A graph file writing in R using "rgexf"</description>
    ##     <keywords>gexf graph, NodosChile, R, rgexf</keywords>
    ##   </meta>
    ##   <graph mode="dynamic" start="10" end="2" timeformat="double" defaultedgetype="undirected">
    ##     <nodes>
    ##       <node id="1" label="juan" start="10" end="12"/>
    ##       <node id="2" label="pedro" start="13" end="2"/>
    ##       <node id="3" label="matthew" start="2" end="2"/>
    ##       <node id="4" label="carlos" start="2" end="2"/>
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

    ## Warning in write.gexf(nodes = people, edges = relations, edgeDynamic =
    ## time.edges, : In future versions, rgexf 2.0, this function will be the
    ## equivalent of -print(..., file=)-, and replaced by -gexf-

    ## <?xml version="1.0" encoding="UTF-8"?>
    ## <gexf xmlns="http://www.gexf.net/1.3" xmlns:viz="http://www.gexf.net/1.3/viz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.gexf.net/1.3 http://www.gexf.net/1.3/gexf.xsd" version="1.3">
    ##   <meta lastmodifieddate="2016-11-10">
    ##     <creator>NodosChile</creator>
    ##     <description>A graph file writing in R using "rgexf"</description>
    ##     <keywords>gexf graph, NodosChile, R, rgexf</keywords>
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
    ##       </node>
    ##       <node id="2" label="pedro" start="13" end="5">
    ##         <attvalues>
    ##           <attvalue for="att1" value="b"/>
    ##           <attvalue for="att2" value="2"/>
    ##         </attvalues>
    ##       </node>
    ##       <node id="3" label="matthew" start="2" end="5">
    ##         <attvalues>
    ##           <attvalue for="att1" value="c"/>
    ##           <attvalue for="att2" value="3"/>
    ##         </attvalues>
    ##       </node>
    ##       <node id="4" label="carlos" start="2" end="5">
    ##         <attvalues>
    ##           <attvalue for="att1" value="d"/>
    ##           <attvalue for="att2" value="4"/>
    ##         </attvalues>
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

    ## Session info --------------------------------------------------------------

    ##  setting  value                       
    ##  version  R version 3.3.2 (2016-10-31)
    ##  system   x86_64, linux-gnu           
    ##  ui       X11                         
    ##  language en_US                       
    ##  collate  en_US.UTF-8                 
    ##  tz       <NA>                        
    ##  date     2016-11-10

    ## Packages ------------------------------------------------------------------

    ##  package    * version   date       source        
    ##  assertthat   0.1       2013-12-06 CRAN (R 3.3.0)
    ##  devtools     1.12.0    2016-06-24 CRAN (R 3.3.1)
    ##  digest       0.6.10    2016-08-02 CRAN (R 3.3.1)
    ##  evaluate     0.9       2016-04-29 CRAN (R 3.3.0)
    ##  htmltools    0.3.5     2016-03-21 CRAN (R 3.3.0)
    ##  igraph       1.0.1     2015-06-26 CRAN (R 3.3.1)
    ##  knitr        1.14      2016-08-13 CRAN (R 3.3.1)
    ##  magrittr     1.5       2014-11-22 CRAN (R 3.3.0)
    ##  memoise      1.0.0     2016-01-29 CRAN (R 3.3.0)
    ##  Rcpp         0.12.7    2016-09-05 CRAN (R 3.3.1)
    ##  rgexf      * 0.16.9000 2016-11-10 local         
    ##  rmarkdown    1.1       2016-10-16 CRAN (R 3.3.1)
    ##  stringi      1.1.2     2016-10-01 CRAN (R 3.3.1)
    ##  stringr      1.1.0     2016-08-19 CRAN (R 3.3.1)
    ##  tibble       1.2       2016-08-26 CRAN (R 3.3.1)
    ##  withr        1.0.2     2016-06-20 CRAN (R 3.3.0)
    ##  XML          3.98-1.4  2016-03-01 CRAN (R 3.3.0)
    ##  yaml         2.1.13    2014-06-12 CRAN (R 3.3.0)
