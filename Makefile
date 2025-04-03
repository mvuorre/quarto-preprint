all: render

# Render example document
render: index.pdf
index.pdf: index.qmd _extensions/preprint/typst-show.typ _extensions/preprint/typst-template.typ
	quarto render index.qmd

# Render all test documents
TEST_FILES := $(wildcard tests/*.qmd)
tests: $(TEST_FILES)
	cd tests; quarto add ../. --no-prompt
	@for file in $^; do \
		quarto render $$file; \
	done
	rm -rf tests/use; mkdir -p tests/use; cd tests/use; quarto use template ../../. --no-prompt

# Create a GitHub release
.release.timestamp: index.pdf NEWS.md _extensions/preprint/_extension.yml
	@echo "Creating GitHub release..."
	@VERSION=$$(grep -m 1 "version:" _extensions/preprint/_extension.yml | sed 's/version: *//; s/"//g'); \
	CHANGELOG=$$(awk '/^## '$$VERSION'$$/{flag=1; next} /^## [0-9]/{flag=0} flag' NEWS.md); \
	gh release create v$$VERSION --title "v$$VERSION" --notes "$$CHANGELOG"
	@touch .release.timestamp
release: .release.timestamp

# Clean all intermediate files
clean:
	rm -rf *.pdf *.typ *.png *_cache/ *_files/ tests/*.pdf tests/*.html .release.timestamp
	find tests/ -mindepth 1 -type d -exec rm -r {} +

.PHONY: clean tests release all render
