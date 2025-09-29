all: render

render: prepare clean
	quarto render

prepare: _extensions/preprint/typst/preprint.typ README.md

_extensions/preprint/typst/preprint.typ: typst/lib.typ
	mkdir -p _extensions/preprint/typst/
	cp $< $@

README.md: index.qmd
	quarto render $< --to gfm --output $@ --output-dir . -M toc-depth:1 -M wrap:none

# Tests
test-use:
	mkdir -p tests/use && cd tests/use && quarto use template ../../. --no-prompt

test-add:
	mkdir -p tests/add && cd tests && quarto create project default add --no-prompt --no-open && cd add && quarto add ../../. --no-prompt

# Update dependencies
deps:
	quarto add christopherkenny/typst-function --embed preprint --no-prompt

# Create a GitHub release if new version is specified
release: NEWS.md _extensions/preprint/_extension.yml
	@VERSION=$$(yq '.version' _extensions/preprint/_extension.yml); \
	CHANGELOG=$$(awk '/^## '$$VERSION'$$/{flag=1; next} /^## [0-9]/{flag=0} flag' NEWS.md); \
	gh release create v$$VERSION --title "v$$VERSION" --notes "$$CHANGELOG"

# Clean all intermediate files
clean:
	rm -rf *.pdf *.typ *.png *.html *_cache/ *_files/ *_libs/ tests/ docs/ .quarto
