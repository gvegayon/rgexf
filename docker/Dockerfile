FROM rocker/r-base:latest

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	r-cran-ape r-cran-coda r-cran-mass r-cran-rmarkdown r-cran-knitr \
	r-cran-xml2 r-cran-covr r-cran-tinytest && \
	Rscript -e 'utils::install.packages("fmcmc")'

RUN Rscript -e 'utils::install.packages("AUC")'

CMD ["bash"]

