# pst-pdf

A LaTeX package to integrate PostScript code into a PDF output.
Load the testfiles pst-pdf-example?.tex and run it with the shell script
```
ps4pdf pst-pdf-example.tex
```
It produces the output file pst-pdf-example.pdf. Be sure that the script is
executable.
```
pst-pdf.sty -> $TEXMF-LOCAL
ps4pdf      -> /usr/local/bin
```
Without a shell script, run
```
latex <file>
dvips -Ppdf -o <file>-pics.ps <file>.dvi
ps2pdf -dAutoRotatePages=/None <file>-pics.ps <file>-pics.pdf
pdflatex <file>
```
For bug reports: https://github.com/rolfn/pst-pdf/issues

Rolf Niepraschk, 2016-06-23

