.PHONY: all examples test-use test-add deps release clean

all: _extensions/preprint/typst/preprint.typ examples

_extensions/preprint/typst/preprint.typ: typst/lib.typ
	cat typst/lib.typ > _extensions/preprint/typst-template.typ

# Generate example PDFs and PNG previews
examples/example.pdf: example.qmd _extensions/preprint/typst/preprint.typ
	mkdir -p examples
	quarto render $< -M line-number:true --output-dir examples --output example.pdf --to preprint-typst

examples/example-jou.pdf: example.qmd _extensions/preprint/typst/preprint.typ
	mkdir -p examples
	quarto render $< -M theme:jou --output-dir examples --output example-jou.pdf --to preprint-typst

# Easter egg
examples/example-dracula.pdf: example.qmd _extensions/preprint/typst/preprint.typ
	mkdir -p examples
	quarto render $< -M theme:dracula --output-dir examples --output example-dracula.pdf --to preprint-typst

examples/example.png: examples/example.pdf
	pdftoppm -png -singlefile -r 100 $< examples/example

examples/example-jou.png: examples/example-jou.pdf
	pdftoppm -png -singlefile -r 100 $< examples/example-jou

examples/example-jou-p2.png: examples/example-jou.pdf
	pdftoppm -png -f 2 -l 2 -singlefile -r 100 $< examples/example-jou-p2

examples/example-jou-p3.png: examples/example-jou.pdf
	pdftoppm -png -f 3 -l 3 -singlefile -r 100 $< examples/example-jou-p3

examples: examples/example.png examples/example-jou.png examples/example-jou-p2.png examples/example-jou-p3.png examples/example-dracula.pdf _extensions/preprint/typst/preprint.typ

# Tests
test-local: clean
	mkdir -p tests/local && cd tests/local && quarto use template ../../. --no-prompt && quarto render

test-remote: clean
	mkdir -p tests/remote && cd tests/remote && quarto use template mvuorre/quarto-preprint --no-prompt && quarto render

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
