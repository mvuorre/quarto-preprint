# Preprint Quarto extension

*quarto-preprint* is a [Quarto](https://quarto.org) extension that provides two custom Quarto formats. The main format provided by this extension is `preprint-typst`. It renders a Quarto source document to a PDF document using [Typst](https://typst.app/docs). 

The extension also provides a `preprint-docx` format, which renders Quarto source documents to MS Word documents with some basic layout improvements. 

View the example output and manual: [PDF (Typst)](https://mvuorre.github.io/quarto-preprint/index.pdf), [MS Word](https://mvuorre.github.io/quarto-preprint/index.docx), & [HTML](https://mvuorre.github.io/quarto-preprint).

## Purpose

This extension aims to

- Look nice     
- Be fast
- Just Work
- Be 100% Quarto standards compliant
  - Write manuscripts without worrying about formatting & metadata
  - Switch to any Quarto journal format without changing anything but `format:` (and whatever is required by the destination format)

In other words, `quarto-preprint` should provide a reliable and fuss-free Quarto format (`preprint-typst`) for writing reproducible manuscripts. 

# Use

## Install

Add template to an existing project:

```bash
quarto add template mvuorre/quarto-preprint
```

Start a new Quarto project that uses `quarto-preprint`:

```bash
quarto use template mvuorre/quarto-preprint
```

## Use

Write Quarto markdown and add `format: apaish-typst` to the document's YAML metadata. Then, render your document, for example from the command line with

```bash
quarto render <filename>.qmd
```

### Configuration & options (YAML metadata)

(See the [manual](https://mvuorre.github.io/quarto-preprint) for more information.)

Below is an example document's YAML front matter, with comments providing additional explanation and links:

```yaml
# Title (required)
title: Long Title
# Running head (repeated in page header)
running-head: Short title 
# Author(s) (required) (https://quarto.org/docs/authoring/front-matter.html#authors-and-affiliations)
author:
  - name: Matti Vuorre
    email: mjvuorre@uvt.nl
    orcid: 0000-0001-5052-066X
    url: https://www.tilburguniversity.edu/staff/m-j-vuorre
    affiliation:
      - ref: 1
# Affiliation(s) (https://quarto.org/docs/authoring/front-matter.html#authors-and-affiliations)
affiliations:
  - id: 1
    name: Tilburg University
    department: Department of Social Psychology
# Abstract (https://quarto.org/docs/authoring/front-matter.html#abstract)
abstract: This is an example.
# Keywords (https://quarto.org/docs/authoring/front-matter.html#keywords)
keywords: 
  - Quarto 
  - Typst
# Date
date: "`r Sys.Date()`"  # Can use e.g. R to include current date
# Citation information (https://quarto.org/docs/authoring/create-citeable-articles.html#journal-articles)
citation:
  type: article-journal
  container-title: "PsyArXiv"
  doi: "an.example.doi"
  url: example.com
# Specify an OSF preprint provider to add its logo to the document
branding: psyarxiv
# This can include whatever you want
authornote: This is an example author note.
# Path to a bibliography file
bibliography: bibliography-manual.bib
# Title of reference section
bibliography-title: "References"
# Bibliography style (https://quarto.org/docs/output-formats/typst.html#bibliography)
bibliography-style: "apa"
# Specify a color for links (including in-text references)
linkcolor: blue
# Table of contents options
toc: true
toc_depth: 2
toc_title: "Contents"
# Section numbering (remove line or leave blank to omit)
section-numbering: ""
# Spacing between lines (https://typst.app/docs/reference/model/par/)
leading: 0.6em
# The indent the first line of a paragraph should have. (https://typst.app/docs/reference/model/par/)
first-line-indent: 0cm
# Space between paragraphs
spacing: 1em
# (https://quarto.org/docs/output-formats/typst.html#page-layout)
margin: (x: 3.2cm, y: 3cm)
paper: "a4"
# Number of columns for body text
cols: 1
# Space between columns (https://typst.app/docs/reference/layout/columns/)
col-gutter: 4.2%
# Typst language settings
lang: "en"
region: "US"
# Font settings
mainfont: Comic Sans
fontsize: 11pt
```

See also Quarto's Typst format [documentation](https://quarto.org/docs/output-formats/typst.html), and Quarto's [guide](https://quarto.org/docs/authoring/front-matter.html) on writing scholarly documents.

## Tips

###  Collaboration

It can be useful to also output a MS Word document for collaboration. To do so, you can include `docx` as an output format as shown [here](https://quarto.org/docs/output-formats/ms-word.html). `quarto-preprint` also provides a slightly improved bare-bones MS Word output format `preprint-docx`.

[Typst](https://typst.app) also provides an online interface. That could be especially useful for collaborating on documents. You can create a .typ file by including

```yaml
format:
  preprint-typst:
    keep-typ: true
```

in the document's YAML. Then, copypaste the resulting .typ file and other required materials (bibliography file, image files, etc) to the Typst online interface. See an example [here](https://typst.app/project/rk4zWONKPIF5lRxF_HU1I5).

## Help

If something isn't working, please submit an [issue](https://github.com/mvuorre/quarto-preprint/issues), optimally with a reproducible example / full details of what you're trying to do, how, and what goes wrong. You can also email Matti.

## Contributing

Yes please.
