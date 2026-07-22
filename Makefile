VERSION:=$(shell Rscript -e 'x<-readLines("DESCRIPTION");cat(gsub(".+[:]\\s*", "", x[grepl("^Vers", x)]))')
PKGNAME:=$(shell Rscript -e 'x<-readLines("DESCRIPTION");cat(gsub(".+[:]\\s*", "", x[grepl("^Package", x)]))')

install: 
	Rscript -e 'devtools::install()'
		

$(PKGNAME)_$(VERSION).tar.gz: R/*.R inst/NEWS README.md
	R CMD build --no-build-vignettes --no-manual . 

inst/NEWS: NEWS.md
	Rscript -e "rmarkdown::pandoc_convert('NEWS.md', 'plain', output='inst/NEWS')"&& \
	head -n 80 inst/NEWS

README.md: README.qmd
	quarto render README.qmd

.PHONY: checfull checkv clean

check:
	Rscript -e 'devtools::check()'

clean:
	rm -rf $(PKGNAME).Rcheck $(PKGNAME)_$(VERSION).tar.gz

.PHONY: man docker docs
man: R/* 
	Rscript -e 'devtools::document()'

docs: man

docker:
	docker run -v$(pwd):/pkg/ -w/pkg --rm -i uscbiostats/fmcmc:latest make check

paper/paper.pdf: paper/paper.md paper/paper.bib
	docker run --rm -v$(pwd)/paper:/data --user $(id -u):$(id -g) --env JOURNAL=joss openjournals/paperdraft

