# Makefile for Rotartsilib Monorepo

.PHONY: all lean docs tex typst clean verso

all: lean docs tex typst verso

lean:
	lake build

docs:
	lake exe mk_all
	lake build Rotartsilib:docs

verso: lean
	lake exe build_blog
	lake exe build_book
	lake exe build_slides
	@mkdir -p outputs/verso/blog
	@mkdir -p outputs/verso/book
	@mkdir -p outputs/verso/slides
	@cp -r _site/* outputs/verso/blog/ || true
	@cp -r _out/html-multi/* outputs/verso/book/ || true
	@cp -r _slides/* outputs/verso/slides/ || true

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
	rm -rf outputs/ _site/ _out/ _slides/
