all: pdf docx

pdf: example.qmd
	quarto render $< \
	--to preprint-pdf

docx: example.qmd
	quarto render $< \
	--to preprint-docx

clean:
	rm -rf *.pdf *.typ *_cache/ *_files/

.PHONY: all clean
