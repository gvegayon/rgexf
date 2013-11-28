cd ..
R CMD REMOVE rgexf
rm -f rgexf_*
R CMD build rgexf
#R CMD check --as-cran rgexf_*
R CMD INSTALL rgexf_*
cd rgexf
# Rscript test.rgexf.R
