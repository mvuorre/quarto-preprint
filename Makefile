all: render

# Define target file using Makefile variable
TARGET := manual.qmd

# Render example document using target variable
render: $(TARGET) _extensions/preprint/typst-show.typ _extensions/preprint/typst-template.typ update-version
	# Render PDF and HTML to docs/
	quarto render $<
	quarto render $< --to preprint-typst --output manual-jou.pdf -M wordcount:true -M theme-jou:true
	# Render README.md to root
	quarto render $< --to gfm --output README.md --output-dir . -M toc-depth:2 -M wrap:none

# Tests
test-use:
	mkdir -p tests/use && cd tests/use && quarto use template ../../. --no-prompt
	ls tests/use

test-add:
	mkdir -p tests/add && cd tests && quarto create project default add --no-prompt --no-open && cd add && quarto add ../../. --no-prompt
	ls tests/add

# Update dependencies
deps:
	quarto add christopherkenny/typst-function --embed preprint --no-prompt

# Get version to use as variable `extension-version` from _quarto.yml
update-version:
	@VERSION=$$(yq '.version' _extensions/preprint/_extension.yml); \
	touch _variables.yml; \
	yq -i ".extension-version = \"$$VERSION\"" _variables.yml; \

# Create a GitHub release
.release.timestamp: render NEWS.md _extensions/preprint/_extension.yml
	@VERSION=$$(yq '.version' _extensions/preprint/_extension.yml); \
	CHANGELOG=$$(awk '/^## '$$VERSION'$$/{flag=1; next} /^## [0-9]/{flag=0} flag' NEWS.md); \
	gh release create v$$VERSION --title "v$$VERSION" --notes "$$CHANGELOG" docs/manual.pdf
	@touch .release.timestamp

release: .release.timestamp

# Publish docs/ using Quarto
publish: clean
	quarto render $(TARGET) --to preprint-typst --output-dir . --output manual-jou.pdf -M wordcount:true -M theme-jou:true
	quarto publish gh-pages --no-prompt --no-browser

# Clean all intermediate files
clean:
	rm -rf *.pdf *.typ *.png *_cache/ *_files/ tests/ docs/ .release.timestamp .quarto

.PHONY: clean release deps update-version
