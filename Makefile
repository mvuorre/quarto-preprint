.PHONY: all examples test test-local-use test-local-add test-remote deps release clean

all: examples

# Generate example PDFs and PNG previews. Always rebuilds.
examples:
	mkdir -p examples
	quarto render example.qmd --to preprint-typst --output-dir examples
	quarto render example.qmd --to preprint-typst -M theme:jou --output-dir examples --output example-jou.pdf
	pdftoppm -png -singlefile -r 100 examples/example.pdf examples/example
	pdftoppm -png -singlefile -r 100 examples/example-jou.pdf examples/example-jou
	pdftoppm -png -f 2 -l 2 -singlefile -r 100 examples/example-jou.pdf examples/example-jou-p2
	pdftoppm -png -f 3 -l 3 -singlefile -r 100 examples/example-jou.pdf examples/example-jou-p3

# Tests: render every tests/*/index.qmd; fail on first error.
TESTS := $(wildcard tests/*/index.qmd)

test:
	@for f in $(TESTS); do echo "== $$f"; quarto render $$f || exit 1; done

# Installation smoke tests
test-local-use: clean
	mkdir -p tests/local/use && cd tests/local/use && quarto use template ../../../. --no-prompt && quarto render

test-local-add: clean
	mkdir -p tests/local/add && cd tests/local && quarto create project default add --no-prompt --no-open && cd add && quarto add ../../../. --no-prompt

test-remote: clean
	mkdir -p tests/remote && cd tests/remote && quarto use template mvuorre/quarto-preprint --no-prompt && quarto render

# Update dependencies
deps:
	quarto add christopherkenny/typst-function --embed preprint --no-prompt

# Create a GitHub release if new version is specified.
# Rendered examples are attached as release assets (not tracked in git);
# README embeds them via releases/latest/download/ URLs.
release: examples NEWS.md _extensions/preprint/_extension.yml
	@VERSION=$$(yq '.version' _extensions/preprint/_extension.yml); \
	CHANGELOG=$$(awk '/^## '$$VERSION'$$/{flag=1; next} /^## [0-9]/{flag=0} flag' NEWS.md); \
	gh release create v$$VERSION --title "v$$VERSION" --notes "$$CHANGELOG" \
		examples/example.pdf examples/example.png \
		examples/example-jou.pdf examples/example-jou.png \
		examples/example-jou-p2.png examples/example-jou-p3.png

# Clean all intermediate files
clean:
	rm -rf *.pdf *.typ *.png *.html *_cache/ *_files/ *_libs/ docs/ .quarto examples/ _freeze/
	rm -rf tests/local/ tests/remote/ tests/*/*.pdf tests/*/*.typ tests/*/*.html tests/*/index_files/
