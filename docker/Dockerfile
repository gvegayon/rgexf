FROM rocker/r-base

RUN apt-get update && \
        apt-get install -y --no-install-recommends \
        r-cran-rmarkdown r-cran-knitr && \
        Rscript -e 'utils::install.packages(c("intergraph", "igraphdata"))'

RUN apt-get install -y --no-install-recommends \
        libharfbuzz-dev libfribidi-dev \
        libssl-dev libxml2-dev libfontconfig1-dev libcurl4-openssl-dev \
        libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev  && \
        Rscript -e 'utils::install.packages("pkgdown")'

RUN apt-get install -y --no-install-recommends r-cran-igraph
RUN apt-get install -y --no-install-recommends r-cran-covr r-cran-tinytest
RUN Rscript -e 'utils::install.packages(c("servr", "XML"))'

CMD ["bash"]

