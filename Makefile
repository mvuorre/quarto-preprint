all: index.pdf

# Render example document
index.pdf: index.qmd _extensions/preprint/typst-show.typ _extensions/preprint/typst-template.typ
	quarto render index.qmd

# Individual test targets
test-default: index.qmd
	mkdir -p tests
	quarto render $< --to preprint-typst --output-dir tests --output index_default.pdf

test-appendix: index.qmd
	mkdir -p tests
	quarto render $< --to preprint-typst --output-dir tests --output index_appendix_theme-jou.pdf -M theme-jou:true
	quarto render $< --to preprint-typst --output-dir tests --output index_appendix.pdf -M keep-typ:true
	quarto render $< --to html --output-dir tests --output index_appendix.html -M toc:true

test-theme-jou: index.qmd
	mkdir -p tests
	quarto render $< --to preprint-typst --output-dir tests --output index_theme-jou.pdf -M theme-jou:true

test-linenumbers: index.qmd
	mkdir -p tests
	quarto render $< --to preprint-typst --output-dir tests --output index_theme-jou_linenumber.pdf -M theme-jou:true -M line-number:true

test-single-author: index.qmd
	mkdir -p tests
	quarto render $< --to preprint-typst --output-dir tests --output index_single-author.pdf -M author:'[{name: "Solo Author", email: "solo@example.com", corresponding: true, affiliation: "Institution"}]'

test-typography: index.qmd
	mkdir -p tests
	quarto render $< --to preprint-typst --output-dir tests --output index_typography.pdf -M fontsize:12pt -M leading:0.8em -M first-line-indent:0em

test-toc-numbering: index.qmd
	mkdir -p tests
	quarto render $< --to preprint-typst --output-dir tests --output index_toc-numbering.pdf -M toc:true -M section-numbering:1.1.a

# Run all tests
test: test-default test-theme-jou test-linenumbers test-single-author test-typography test-toc-numbering test-appendix

# Update dependencies
deps:
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

.PHONY: clean test test-default test-theme-jou test-linenumbers test-single-author test-typography test-toc-numbering release all render deps
