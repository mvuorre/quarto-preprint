# Define target files
INDEX := index.qmd
EXAMPLE := example.qmd

# Tests
test-use:
	mkdir -p tests/use && cd tests/use && quarto use template ../../. --no-prompt
	ls tests/use

test-add:
	mkdir -p tests/add && cd tests && quarto create project default add --no-prompt --no-open && cd add && quarto add ../../. --no-prompt
	ls tests/add

sync-typst:
	mkdir -p _extensions/preprint/typst/
	cp typst/lib.typ _extensions/preprint/typst/preprint.typ

# Update dependencies
deps:
	quarto add christopherkenny/typst-function --embed preprint --no-prompt

# Get version to use as variable `extension-version` from _quarto.yml
update-version:
	@VERSION=$$(yq '.version' _extensions/preprint/_extension.yml); \
	touch _variables.yml; \
	yq -i ".extension-version = \"$$VERSION\"" _variables.yml; \

# Create a GitHub release if new version is specified
release: NEWS.md _extensions/preprint/_extension.yml
	@VERSION=$$(yq '.version' _extensions/preprint/_extension.yml); \
	CHANGELOG=$$(awk '/^## '$$VERSION'$$/{flag=1; next} /^## [0-9]/{flag=0} flag' NEWS.md); \
	gh release create v$$VERSION --title "v$$VERSION" --notes "$$CHANGELOG"

# Render example PDFs to be included in website
example: $(EXAMPLE) sync-typst _extensions/preprint/typst-show.typ _extensions/preprint/typst-template.typ _extensions/preprint/typst/preprint.typ
	quarto render $(EXAMPLE) --to preprint-typst --output-dir . --output example.pdf
	quarto render $(EXAMPLE) --to preprint-typst --output-dir . --output example-jou.pdf -M theme:jou

# Render README.md to root from index.qmd
index: $(INDEX)
	quarto render $(INDEX) --to html --output index.html --output-dir .

readme: $(INDEX)
	quarto render $(INDEX) --to gfm --output README.md --output-dir . -M toc-depth:1 -M wrap:none

# Render website to docs/ including example docs
render: example index readme clean update-version
	quarto render

# Publish to gh-pages
publish: $(INDEX) $(EXAMPLE)
	# Render and publish website on gh-pages branch to github pages
	quarto publish gh-pages --no-prompt --no-browser

# Clean all intermediate files
clean:
	rm -rf *.pdf *.typ *.png *_cache/ *_files/ *_libs/ tests/ docs/ .quarto
