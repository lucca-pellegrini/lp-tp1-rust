# SPDX-License-Identifier: ISC

NAME       = Linguagens_de_Programação_-_Rust
MAIN       = main
TEXT       = *.tex
ETC        = Makefile
# FIG        = fig-*.pdf
VER        = $(shell git describe --long --tags \
              | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g')
LATEX      = latexrun --latex-cmd lualatex --bibtex-cmd biber
LATEXFLAGS = -O build
CLEANFLAGS = --clean-all -O build
RELEASE    = $(NAME)_$(VER)

.PHONY: all clean release force

all: $(MAIN).pdf

release: $(RELEASE).zip $(RELEASE).tar.gz

clean:
	$(LATEX) $(CLEANFLAGS)
	$(RM) -r *.pdf *.ps *.idx *.bbl *.brf *.glo *.dvi *.toc *.lof *.aux   \
		*.log *.blg *.ilg *.ind *.out *.wsp *.fls *.synctex* *.zip    \
		*.tar.gz *.*~ build/ latex.out/

$(MAIN).pdf: $(ETC) force # $(FIG)
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex

$(RELEASE).pdf: $(MAIN).pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress \
		-dNOPAUSE -dQUIET -dBATCH -sOutputFile=$(RELEASE).pdf         \
		$(MAIN).pdf

$(RELEASE).tar.gz: $(MAIN).pdf $(RELEASE).pdf
	tar -vcf               \
		$(RELEASE).tar \
		$(RELEASE).pdf
	gzip -f $(RELEASE).tar

$(RELEASE).zip: $(MAIN).pdf $(RELEASE).pdf
	zip -r                 \
		$(RELEASE).zip \
		$(RELEASE).pdf
