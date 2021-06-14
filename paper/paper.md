---
title: 'Building, Importing, and Exporting GEXF Graph Files with rgexf'
authors:
- affiliation: 1
  name: George G Vega Yon
  orcid: 0000-0002-3171-0844
date: "07 June 2021"
output:
  html_document:
    df_print: paged
bibliography: paper.bib
tags:
- sna
- networks
- graph visualization
- data visualization
- data management
- r programming
affiliations:
- index: 1
  name: Department of Preventive Medicine, University of Southern California
---

# Summary

First introduced in 2012, the **rgexf** package for the R programming language was the first effort to make the Graph Exchange XML Format (GEXF) [@heymann2009gexf] specification available to the **R** world. With more than 500,000 downloads[^cranlogs], it is one of the most popular ways to incorporate GEXF files into the R programming language environment.

[^cranlogs]: According to the [https://cranlogs.r-pkg.org/](https://cranlogs.r-pkg.org/) website, as of June 14, 2021.

Developed by the Gephi Core Group [@bastian2009gephi], the GEXF specification is a flexible and widely used format to describe graphs. Although it has not been updated since 2009, the GEXF format has been introduced to several tools and programming environments. A few examples include:

- The python library **networkx** [@hagberg2008exploring]

- The stand-alone software **Cytoscape** [@smoot2011cytoscape]

- The JavaScript library **sigma.js** [https://simga.js](https://simga.js)

- The java library **gexf4j** [https://github.com/francesco-ficarola/gexf4j)](https://github.com/francesco-ficarola/gexf4j) 

- The JavaScript library **gexf-js** [https://github.com/raphv/gexf-js](https://github.com/raphv/gexf-js)

Besides the **rgexf** package, other R packages provide functions that interact with GEXF files:

- **sigmajs**: Interface to 'Sigma.js' Graph Visualization Library [@Coene2018]

- **vkR**: Access to VK API via R [@vkR]

- **microeco**: Microbial Community Ecology Data Analysis [@microeco]

- **netCoin**: Interactive Analytic Networks [@netCoin]

Nevertheless, the **rgexf** package continues to be the de-facto tool to interact with GEXF files in **R**.

# Statement of Need

This R package has been serving the scientific community for many years now. Scientists and data analysts across the board have been using **rgexf** to enhance their analyses by smoothly moving between **R** and other applications used for graph visualization. Some concrete examples include gene networks [@Starr2017;@Kauffman2018], interactions among species [@Leclerc2018], and social networks [@Alsaedi2016].

# Features

Beyond reading and writing GEXF files from within R, the **rgexf** R package has various other features that can help to create beautiful network visualizations, in particular:

- Using gexf objects--the main class implemented in rgexf--users can create GEXF objects from scratch, adding and removing nodes and edges--including features--as needed.

- Users of the **igraph** package can directly convert objects between `gexf` and `igraph` classes.

- Thanks to the **gexf-js** javascript library, users can immediately visualize their network objects in the web browser.

Because of these and other reasons, the **rgexf** package has been featured in many scientific papers, stating the great utility that this R package has provided to the community. The **rgexf** package is available in the Comprehensive R Archive Network (CRAN) and the project repository at [https://github.com/gvegayon/rgexf](https://github.com/gvegayon/rgexf).

# References
