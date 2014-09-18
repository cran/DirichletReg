SET file=DirichletReg-vig
R CMD Sweave %file%
pdflatex --quiet %file%
bibtex %file%
pdflatex --quiet %file%
bibtex %file%
pdflatex --quiet %file%
RENAME DirichletReg-vig.pdf DirichletReg-vig-uncompressed.pdf
gswin64c.exe -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dUseCIEColor -dPDFSETTINGS=/printer -dCompatibilityLevel=1.5 -dAutoRotatePages=/None -sOutputFile=DirichletReg-vig-compressed.pdf DirichletReg-vig-uncompressed.pdf
qpdf --linearize --stream-data=compress --object-streams=generate DirichletReg-vig-compressed.pdf DirichletReg-vig.pdf
DEL Rplots.pdf DirichletReg-vig-compressed.pdf DirichletReg-vig-uncompressed.pdf DirichletReg-vig-*.pdf *.aux *.bbl *.blg *.log *.out
START %file%.pdf
