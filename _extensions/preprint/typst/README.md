# Preprint Typst Package

A standalone Typst template for academic preprints and papers. Intended to be used with the `preprint-typst` Quarto format (so may include Quarto-specific features.)

## Usage

```typst
// Note not yet released in the preview package repo; copy locally and modify
#import "@preview/preprint:1.1.0": preprint, appendix

#show: preprint.with(
  title: [Your Paper Title],
  authors: (
    (
      name: [Your Name],
      affiliation: [1],
      orcid: "https://orcid.org/0000-0000-0000-0000",
      email: [you@example.com],
      corresponding: true
    ),
  ),
  affiliations: (
    (id: "1", name: "Your University", department: "Your Department"),
  ),
  abstract: [Your abstract here.],
  categories: [keyword1, keyword2],
)

= Introduction

Your content here.
```

## Features

- Academic paper formatting with proper typography
- Author/affiliation management
- Abstract and keywords
- Table of contents support
- Appendices with proper numbering
- Word count integration
- ORCID support

## Examples

See `example.typ`.
