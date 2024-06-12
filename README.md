# Preprint Quarto extension

This is a manuscript / preprint template for Quarto documents. It renders a Quarto source document to a PDF document using Typst. 

This template's goal is to

- Look nice
- Be fast
- Just Work
- Be 100% Quarto standards compliant
  - Write manuscripts without worrying about special formatting & metadata
  - Switch to a journal format without changing anything but `format:`

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

Write Quarto markdown (incl. code). Render document, for example from the command line with

```bash
quarto render <filename>.qmd
```

### YAML metadata

All relevant Quarto YAML metadata options are supported. See <https://quarto.org/docs/authoring/front-matter.html> and <https://quarto.org/docs/output-formats/typst.html>. Please [submit a reproducible example issue](https://github.com/mvuorre/quarto-preprint/issues) if something isn't working.

See `example.qmd` for common options
