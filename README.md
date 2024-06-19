# Preprint Quarto extension

This is a manuscript template for [Quarto](https://quarto.org) documents. It renders a Quarto source document to a PDF document using [Typst](https://typst.app/docs). 

Manual ([HTML](https://mvuorre.github.io/quarto-preprint)) and example output: <https://mvuorre.github.io/quarto-preprint/index.pdf>

This template's goal is to

- Look nice
- Be fast
- Just Work
- Be 100% Quarto standards compliant
  - Write manuscripts without worrying about formatting & metadata
  - Switch to any Quarto journal format without changing anything but `format:` (and whatever is required by the destination format)

In other words, I intend `quarto-preprint` to be a reliable Quarto template for writing reproducible manuscripts that can mix code and prose. 

## Install

Add template to an existing project:

```bash
quarto add template mvuorre/preprint
```

To start a new project:

```bash
quarto use template mvuorre/preprint
```

## Use

Write Quarto markdown (incl. code) and add the [Quarto](https://quarto.org) output format `format: apaish-typst`. Then, render your document, for example from the command line with

```bash
quarto render <filename>.qmd
```

### YAML metadata

In addition to standard [Quarto front matter for scholarly writing](https://quarto.org/docs/authoring/front-matter.html), bibliography files, etc, some  options are passed to the Typst template.

See also <https://quarto.org/docs/output-formats/typst.html>, where Typst specifics are discussed. 

## Help

Please submit an [issue](https://github.com/mvuorre/quarto-preprint/issues), optimally with a reproducible example, if something isn't working. You can also email Matti.

## Contributing

Yes please.
