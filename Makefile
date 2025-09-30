.PHONY: all examples test-use test-add deps release clean

all: _extensions/preprint/typst/preprint.typ examples

_extensions/preprint/typst/preprint.typ: typst/lib.typ
	mkdir -p _extensions/preprint/typst/
	cp $< $@

# Generate example PDFs and PNG previews
examples/example.pdf: example.qmd
	mkdir -p examples
	quarto render $< -M line-number:true --output-dir examples --output example.pdf --to preprint-typst

examples/example-jou.pdf: example.qmd
	mkdir -p examples
	quarto render $< -M theme:jou --output-dir examples --output example-jou.pdf --to preprint-typst

examples/example.png: examples/example.pdf
	pdftoppm -png -singlefile -r 100 $< examples/example

examples/example-jou.png: examples/example-jou.pdf
	pdftoppm -png -singlefile -r 100 $< examples/example-jou

examples/example-jou-p2.png: examples/example-jou.pdf
	pdftoppm -png -f 2 -l 2 -singlefile -r 100 $< examples/example-jou-p2

examples/example-jou-p3.png: examples/example-jou.pdf
	pdftoppm -png -f 3 -l 3 -singlefile -r 100 $< examples/example-jou-p3

examples: examples/example.png examples/example-jou.png examples/example-jou-p2.png examples/example-jou-p3.png

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
	rm -rf *.pdf *.typ *.png *.html *_cache/ *_files/ *_libs/ tests/ docs/ .quarto examples/ _freeze/
