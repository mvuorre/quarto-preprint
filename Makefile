all: example

example: example.qmd
	quarto render $< \
	--output example.pdf

clean:
	rm -rf *.pdf *.typ *_cache/ *_files/

.PHONY: all clean
