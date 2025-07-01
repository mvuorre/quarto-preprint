all: render

# Define target file using Makefile variable
# This allows us to easily change the target file without modifying the render command
# and to use the same target in multiple places.
# The target file is the main document that will be rendered.
# In this case, it is `manual.qmd`, which is the main document for the
TARGET := manual.qmd

# Render example document using target variable
render: $(TARGET) _extensions/preprint/typst-show.typ _extensions/preprint/typst-template.typ update-version
	# Render PDF and HTML to docs/
	quarto render $<
	# Render README.md to root
	quarto render $< --to gfm --output README.md --output-dir . -M toc-depth:2
	# Render additional preprint-typst examples
	quarto render $< --to preprint-typst -M theme-jou:true --output manual_ex2.pdf
	quarto render $< --to preprint-typst --output manual_ex3.pdf -M author:'[{name: "Author One", email: "author-one@example.com", corresponding: true, affiliation: "Institution One"}, {name: "Author two", email: "author-two@example.com", affiliation: "Institution Two"}]' -M line-number:true -M mainfont:'PT Serif'

# Individual test targets
test-default: $(TARGET)
	mkdir -p tests
	quarto render $< --to preprint-typst --output-dir tests --output index_default.pdf -M keep-typ:true
	quarto render $< --to html --output-dir tests --output index_default.html

test-theme-jou: $(TARGET)
	mkdir -p tests
	quarto render $< --to preprint-typst --output-dir tests --output index_theme-jou.pdf -M theme-jou:true

test-linenumbers: $(TARGET)
	mkdir -p tests
	quarto render $< --to preprint-typst --output-dir tests --output index_theme-jou_linenumber.pdf -M theme-jou:true -M line-number:true

test-two-author: $(TARGET)
	mkdir -p tests
	quarto render $< --to preprint-typst --output-dir tests --output index_two-author.pdf -M author:'[{name: "Author One", email: "author-one@example.com", corresponding: true, affiliation: "Institution One"}, {name: "Author two", email: "author-two@example.com", affiliation: "Institution Two"}]'

test-typography: $(TARGET)
	mkdir -p tests
	quarto render $< --to preprint-typst --output-dir tests --output index_typography.pdf -M fontsize:12pt -M leading:0.8em -M first-line-indent:0em

test-toc-numbering: $(TARGET)
	mkdir -p tests
	quarto render $< --to preprint-typst --output-dir tests --output index_toc-numbering.pdf -M toc:true -M section-numbering:1.1.a

test-use:
	mkdir -p tests/use && cd tests/use && quarto use template ../../. --no-prompt
	ls -l tests/use

test-add:
	mkdir -p tests/add && cd tests && quarto create project default add --no-prompt --no-open && cd add && quarto add ../../. --no-prompt
	ls -l tests/add

# Run all tests
test: test-default test-theme-jou test-linenumbers test-single-author test-typography test-toc-numbering test-appendix

# Update dependencies
deps:
	quarto add christopherkenny/typst-function --embed preprint --no-prompt

# Get version to use as variable `extension-version` from _quarto.yml
update-version:
	@VERSION=$$(yq '.version' _extensions/preprint/_extension.yml); \
	touch _variables.yml; \
	yq -i ".extension-version = \"$$VERSION\"" _variables.yml; \
	echo "Updated extension version to $$VERSION"

# Create a GitHub release
.release.timestamp: manual.pdf NEWS.md _extensions/preprint/_extension.yml
	@echo "Creating GitHub release..."
	@VERSION=$$(grep -m 1 "version:" _extensions/preprint/_extension.yml | sed 's/version: *//; s/"//g'); \
	CHANGELOG=$$(awk '/^## '$$VERSION'$$/{flag=1; next} /^## [0-9]/{flag=0} flag' NEWS.md); \
	gh release create v$$VERSION --title "v$$VERSION" --notes "$$CHANGELOG" $<
	@touch .release.timestamp

release: .release.timestamp

# Publish docs/ using Quarto
publish:
	quarto publish gh-pages

# Clean all intermediate files
clean:
	rm -rf *.pdf *.typ *.png *_cache/ *_files/ tests/ .release.timestamp

.PHONY: clean test test-default test-theme-jou test-linenumbers test-single-author test-typography test-toc-numbering release deps update-version
