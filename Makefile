all: render

# Render example document
render: index.pdf
index.pdf: index.qmd _extensions/preprint/typst-show.typ _extensions/preprint/typst-template.typ
	quarto render index.qmd

# Test metadata options
test: index.qmd
	mkdir -p tests
	# Test default output
	quarto render $< --to preprint-typst --output-dir tests --output index.pdf
	# Test theme-jou
	quarto render $< --to preprint-typst --output-dir tests --output index_theme-jou.pdf -M theme-jou:true
	# Test theme-jou with line numbers
	quarto render $< --to preprint-typst --output-dir tests --output index_theme-jou_linenumber.pdf -M theme-jou:true -M line-number:true

# Update dependencies
deps:
	quarto add andrewheiss/quarto-wordcount --embed preprint --no-prompt
	quarto add christopherkenny/typst-function --embed preprint --no-prompt

# Create a GitHub release
.release.timestamp: index.pdf NEWS.md _extensions/preprint/_extension.yml
	@echo "Creating GitHub release..."
	@VERSION=$$(grep -m 1 "version:" _extensions/preprint/_extension.yml | sed 's/version: *//; s/"//g'); \
	CHANGELOG=$$(awk '/^## '$$VERSION'$$/{flag=1; next} /^## [0-9]/{flag=0} flag' NEWS.md); \
	gh release create v$$VERSION --title "v$$VERSION" --notes "$$CHANGELOG" index.pdf
	@touch .release.timestamp

release: .release.timestamp

# Clean all intermediate files
clean:
	rm -rf *.pdf *.typ *.png *_cache/ *_files/ tests/ .release.timestamp

.PHONY: clean test release all render deps
