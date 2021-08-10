FROM rocker/drd

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	libssl-dev

RUN Rscript -e 'utils::install.packages(c("XML", "igraph", "rmarkdown", "knitr", \
	"covr", "tinytest")'

RUN Rscript -e 'utils::install.packages("servr")'

CMD ["bash"]

