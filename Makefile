
# `pst-pdf' -- Rolf Niepraschk, 2017-03-05, Rolf.Niepraschk@gmx.de


.SUFFIXES : .tex .ltx .dvi .ps .pdf .eps

PACKAGE = pst-pdf

PDFLATEX = pdflatex

LATEX = latex

ARCHNAME = $(PACKAGE)-$(shell date +"%Y%m%d")
ARCHNAME_TDS = $(PACKAGE).tds

EXAMPLE = $(PACKAGE)-example.tex

ADDINPUTS = penguin.eps elephant.ps knuth.png psf-demo.eps \
  insect1.eps insect15.eps

PDF_CONTAINER = $(EXAMPLE:.tex=-pics.pdf)

ARCHFILES = $(PACKAGE).dtx $(PACKAGE).ins $(ADDINPUTS) Makefile \
            README.md CHANGES CHANGES.tex \
            $(PACKAGE).pdf $(PACKAGE)-DE.pdf $(EXAMPLE:.tex=.pdf) \
            ps4pdf \
            ps4pdf.bat \
            ps4pdf.bat.noMiKTeX \
            ps4pdf.bat.w95 \

PS2PDF = GS_OPTIONS=-dPDFSETTINGS=/prepress ps2pdf

all : pdf doc example

pdf : $(EXAMPLE:.tex=.pdf)

doc : $(PACKAGE).pdf

doc-DE : $(PACKAGE)-DE.pdf

example : $(EXAMPLE:.tex=.pdf)

$(EXAMPLE:.tex=.pdf) : $(EXAMPLE) $(ADDINPUTS) $(PDF_CONTAINER) $(PACKAGE).sty
	$(PDFLATEX) $<

dist : doc doc-DE pdf example
	rm -rf $(PACKAGE)
	mkdir $(PACKAGE)
	cp -p $(ARCHFILES) $(PACKAGE)/
	tar cvzf $(ARCHNAME).tar.gz $(PACKAGE)
	rm -rf $(PACKAGE)
	@ echo
	@ echo $(ARCHNAME).tar.gz

%.gls %.pdf : %.dtx $(PACKAGE).sty
	test -f $(basename $<).glo || touch -f $(basename $<).glo
	test -f $(basename $<).idx || touch -f $(basename $<).idx
	makeindex -s gglo.ist -t $(basename $<).glg -o $(basename $<).gls \
		$(basename $<).glo
	makeindex -s gind.ist -t $(basename $<).ilg -o $(basename $<).ind \
		$(basename $<).idx
	$(PDFLATEX) $<

$(PACKAGE)-DE.gls $(PACKAGE)-DE.pdf : $(PACKAGE).dtx $(PACKAGE).sty
	test -f $(basename $@).glo || touch -f $(basename $@).glo
	test -f $(basename $@).idx || touch -f $(basename $@).idx
	makeindex -s gglo.ist -t $(basename $@).glg -o $(basename $@).gls \
		$(basename $@).glo
	makeindex -s gind.ist -t $(basename $@).ilg -o $(basename $@).ind \
		$(basename $@).idx
	cp $< $(basename $@).dtx
	$(PDFLATEX) '\newcommand*{\mainlang}{ngerman}\input{$(basename $@).dtx}'
	$(RM) $(basename $@).dtx

%.pdf : %.tex
	$(PDFLATEX) $<

$(PACKAGE).sty $(EXAMPLE) : $(PACKAGE).ins $(PACKAGE).dtx
	tex $<

$(EXAMPLE:.tex=.dvi) : $(EXAMPLE) $(ADDINPUTS) $(PACKAGE).sty
	$(LATEX) $<

$(PDF_CONTAINER:.pdf=.ps) : $(EXAMPLE:.tex=.dvi)
	dvips -Ppdf -o $@ $<

$(PDF_CONTAINER) : $(PDF_CONTAINER:.pdf=.ps)
	@ if grep "needs cropping" $(<:-pics.ps=.log) > /dev/null; \
	then \
	  $(PS2PDF) $< $@.tmp; pdfcrop $@.tmp $@ ; rm $@.tmp; \
	else \
	  $(PS2PDF) $< $@; \
	fi

CHANGES : CHANGES.pdf
	pdftotext -enc UTF-8 -layout -nopgbrk $< $@

CHANGES.pdf : CHANGES.tex $(PACKAGE).gls
	$(PDFLATEX) $<

arch : CHANGES pst-pdf.pdf pst-pdf-DE.pdf pst-pdf-example.pdf
	mkdir $(PACKAGE)
	cp -p $(ARCHFILES) $(PACKAGE)/
	zip -r $(ARCHNAME).zip $(PACKAGE)/
	rm -rf $(PACKAGE)/

arch-tds : CHANGES pst-pdf.pdf pst-pdf-DE.pdf pst-pdf-example.pdf
	$(RM) $(ARCHNAME_TDS).zip
	mkdir -p tds/tex/latex/pst-pdf
	mkdir -p tds/doc/latex/pst-pdf
	mkdir -p tds/source/latex/pst-pdf
	mkdir -p tds/scripts/pst-pdf
	cp pst-pdf.sty tds/tex/latex/pst-pdf/
	cp CHANGES pst-pdf.pdf pst-pdf-DE.pdf pst-pdf-example.pdf \
          README.md tds/doc/latex/pst-pdf/
	cp CHANGES.tex elephant.ps insect1.eps insect15.eps \
          knuth.png penguin.eps psf-demo.eps pst-pdf.dtx \
          pst-pdf.ins tds/source/latex/pst-pdf
	cp ps4pdf ps4pdf.bat ps4pdf.bat.noMiKTeX \
          ps4pdf.bat.w95 tds/scripts/pst-pdf/
	cd tds ; zip -r ../$(ARCHNAME_TDS).zip tex doc source scripts
	rm -rf tds


clean :
	$(RM) $(addprefix $(PACKAGE), \
	      .dvi .log .aux .bbl .blg .idx .ind .ilg .gls .glg .glo) \
	      $(addprefix $(basename $(EXAMPLE)), .ps .dvi .log .aux) \
	      $(EXAMPLE) $(PDF_CONTAINER:.pdf=.ps) $(PDF_CONTAINER) \
              CHANGES.pdf

veryclean : clean
	$(RM) $(PACKAGE).pdf pst-pdf-DE.pdf $(EXAMPLE:.tex=.pdf) CHANGES

# EOF
