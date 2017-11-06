news:
	Rscript -e "rmarkdown::pandoc_convert('NEWS.md', 'plain', output='inst/NEWS')"&& \
	head -n 80 inst/NEWS
check:
	cd ..&&R CMD build rgexf/ && \
		R CMD check --as-cran rgexf*.tar.gz

checkv:
	cd ..&&R CMD build rgexf/ && \
		R CMD check --as-cran --use-valgrind rgexf*.tar.gz

