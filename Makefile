# Makefile for Rotartsilib Monorepo

.PHONY: all lean docs tex typst clean

all: lean docs tex typst

lean:
	lake build

docs:
	lake build Rotartsilib:docs

TEX_FILES := $(shell find tex -type f -name '*.tex' -exec grep -l '\\begin{document}' {} +)
TEX_PDFS := $(patsubst tex/%.tex, outputs/tex/%.pdf, $(TEX_FILES))

outputs/tex/%.pdf: tex/%.tex
	@mkdir -p $(dir $@)
	latexmk -cd -pdfxe -shell-escape -interaction=nonstopmode -output-directory=$(abspath $(dir $@)) $<

tex: $(TEX_PDFS)

TYPST_FILES := $(shell find typst -type f -name '*.typ')
TYPST_PDFS := $(patsubst typst/%.typ, outputs/typst/%.pdf, $(TYPST_FILES))

outputs/typst/%.pdf: typst/%.typ
	@mkdir -p $(dir $@)
	typst compile --root $(abspath .) $< $@

typst: $(TYPST_PDFS)

clean:
	lake clean
	rm -rf outputs/
