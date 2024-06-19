all: pdf docx

pdf: example.qmd
	quarto render $< \
	--to preprint-typst

docx: example.qmd
	quarto render $< \
	--to preprint-docx

test-typst: example.qmd
	quarto render $< --to preprint-typst \
	-M fontsize:9pt \
	-M mainfont:'Comic Sans MS' \
	-M authornote:'Sagittis id consectetur purus ut faucibus. Sodales ut etiam sit amet nisl. Nec tincidunt praesent semper feugiat nibh sed. Nisl pretium fusce id velit ut. Massa eget egestas purus viverra accumsan in. Nisl tincidunt eget nullam non nisi est. Ut diam quam nulla porttitor massa. Turpis egestas pretium aenean pharetra magna ac. Pretium nibh ipsum consequat nisl vel. Blandit volutpat maecenas volutpat blandit aliquam. Amet dictum sit amet justo donec enim diam vulputate. Mattis enim ut tellus elementum sagittis vitae et leo duis. Nam aliquam sem et tortor consequat id porta nibh venenatis. In ante metus dictum at. Feugiat vivamus at augue eget arcu dictum varius duis at.'

test-docx: example.qmd
	quarto render $< --to preprint-docx \
	-M fontsize:9pt \
	-M mainfont:'Comic Sans MS' \
	-M authornote:'Sagittis id consectetur purus ut faucibus. Sodales ut etiam sit amet nisl. Nec tincidunt praesent semper feugiat nibh sed. Nisl pretium fusce id velit ut. Massa eget egestas purus viverra accumsan in. Nisl tincidunt eget nullam non nisi est. Ut diam quam nulla porttitor massa. Turpis egestas pretium aenean pharetra magna ac. Pretium nibh ipsum consequat nisl vel. Blandit volutpat maecenas volutpat blandit aliquam. Amet dictum sit amet justo donec enim diam vulputate. Mattis enim ut tellus elementum sagittis vitae et leo duis. Nam aliquam sem et tortor consequat id porta nibh venenatis. In ante metus dictum at. Feugiat vivamus at augue eget arcu dictum varius duis at.'

clean:
	rm -rf *.pdf *.typ *.png *_cache/ *_files/

.PHONY: all clean
