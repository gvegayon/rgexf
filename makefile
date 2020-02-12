rgexf.tar.gz: R/*.R
	rm rgexf.tar.gz; \
	R CMD build . && mv rgexf*.tar.gz rgexf.tar.gz

NAMESPACE: R/*.R
	Rscript -e 'roxygen2::roxygenize()'

check: rgexf.tar.gz
	R CMD check --as-cran rgexf.tar.gz

README.md: README.Rmd
	Rscript -e 'rmarkdown::render("README.Rmd")' && \
		rm README.html

.PHONY: check
