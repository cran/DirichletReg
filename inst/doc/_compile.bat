SET file=DirichletReg-vig
R CMD Sweave %file%
pdflatex %file%
bibtex %file%
pdflatex %file%
bibtex %file%
pdflatex %file%
del Rplots.pdf
del DirichletReg-vig-*.pdf
START %file%.pdf