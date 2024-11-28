all: docs

docs: index.qmd _extensions/preprint/typst-show.typ _extensions/preprint/typst-template.typ
	quarto render

# Render all test documents
TEST_FILES := $(wildcard tests/*.qmd)
tests: $(TEST_FILES)
	cd tests; quarto add ../. --no-prompt
	@for file in $^; do \
		quarto render $$file; \
	done

clean:
	rm -rf *.pdf *.typ *.png *_cache/ *_files/ tests/_extensions

.PHONY: all clean tests
