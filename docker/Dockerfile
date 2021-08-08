FROM rocker/r-base:latest

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	r-cran-xml r-cran-igraph r-cran-rmarkdown r-cran-knitr \
	r-cran-covr r-cran-tinytest

RUN Rscript -e 'utils::install.packages("servr")'

CMD ["bash"]

