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
	rm -rf tests/use; mkdir -p tests/use; cd tests/use; quarto use template ../../. --no-prompt

clean:
	rm -rf *.pdf *.typ *.png *_cache/ *_files/ tests/*.pdf tests/*.html docs/
	find tests/ -mindepth 1 -type d -exec rm -r {} +

.PHONY: all clean tests
