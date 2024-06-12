all: example template

example:

.PHONY: all clean

example: example.qmd
	quarto render $<

template: template.qmd
	quarto render $<

clean:
	rm -rf *.pdf *.typ *_cache/ *_files/

.PHONY: renv clean
