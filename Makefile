all: docs

docs: index.qmd _extensions/preprint/typst-show.typ _extensions/preprint/typst-template.typ
	quarto render

clean:
	rm -rf *.pdf *.typ *.png *_cache/ *_files/

.PHONY: all clean
