all: docs

docs: index.qmd _extensions/preprint/typst-show.typ _extensions/preprint/typst-template.typ
	quarto render

# Render all test documents
TEST_FILES := $(wildcard tests/*.qmd)
tests: $(TEST_FILES)
	@for file in $^; do \
		quarto render $$file; \
	done

clean:
	rm -rf *.pdf *.typ *.png *_cache/ *_files/

.PHONY: all clean tests
