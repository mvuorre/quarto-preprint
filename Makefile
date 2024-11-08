all: docs

docs: index.qmd _extensions/preprint/typst-show.typ _extensions/preprint/typst-template.typ
	quarto render

tests: 
	quarto render tests/*.qmd

clean:
	rm -rf *.pdf *.typ *.png *_cache/ *_files/

.PHONY: all clean tests
