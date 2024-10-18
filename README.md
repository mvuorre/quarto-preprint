# *quarto-preprint*: A Quarto Typst extension for efficient typesetting
of computationally reproducible manuscripts
Matti Vuorre
2024-10-18

- [<span class="toc-section-number">1</span> Preface](#preface)
- [<span class="toc-section-number">2</span> Preprint Quarto
  extension](#preprint-quarto-extension)
- [<span class="toc-section-number">3</span> Use](#use)
- [<span class="toc-section-number">4</span> *quarto-preprint*
  manual](#quarto-preprint-manual)
- [<span class="toc-section-number">5</span> Example
  content](#example-content)
- [<span class="toc-section-number">6</span> Help &
  contributing](#help--contributing)

# Preface

# Preprint Quarto extension

*quarto-preprint* is a [Quarto](https://quarto.org) extension that
provides two custom Quarto formats. The main format provided by this
extension is `preprint-typst`. It renders a Quarto source document to a
PDF document using [Typst](https://typst.app/docs).

The extension also provides a `preprint-docx` format, which renders
Quarto source documents to MS Word documents with some basic layout
improvements.

View the example output and manual: [PDF
(Typst)](https://mvuorre.github.io/quarto-preprint/index.pdf), [MS
Word](https://mvuorre.github.io/quarto-preprint/index.docx), &
[HTML](https://mvuorre.github.io/quarto-preprint).

## Purpose

This extension aims to

- Look nice  
- Be fast
- Just Work
- Be 100% Quarto standards compliant
  - Write manuscripts without worrying about formatting & metadata
  - Switch to any Quarto journal format without changing anything but
    `format:` (and whatever is required by the destination format)

In other words, `quarto-preprint` should provide a reliable and
fuss-free Quarto format (`preprint-typst`) for writing reproducible
manuscripts.

# Use

## Install

Add template to an existing project:

``` bash
quarto add template mvuorre/quarto-preprint
```

Start a new Quarto project that uses `quarto-preprint`:

``` bash
quarto use template mvuorre/quarto-preprint
```

## Use

Write Quarto markdown and add `format: preprint-typst` to the document’s
YAML metadata. Then, render your document, for example from the command
line with

``` bash
quarto render <filename>.qmd
```

### Configuration & options (YAML metadata)

(See the [manual](https://mvuorre.github.io/quarto-preprint) for more
information.)

Below is an example document’s YAML front matter, with comments
providing additional explanation and links:

``` yaml
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
date: "2024-10-18"  # Can use e.g. R to include current date
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

See also Quarto’s Typst format
[documentation](https://quarto.org/docs/output-formats/typst.html), and
Quarto’s [guide](https://quarto.org/docs/authoring/front-matter.html) on
writing scholarly documents.

## Tips

### Collaboration

It can be useful to also output a MS Word document for collaboration. To
do so, you can include `docx` as an output format as shown
[here](https://quarto.org/docs/output-formats/ms-word.html).
`quarto-preprint` also provides a slightly improved bare-bones MS Word
output format `preprint-docx`.

[Typst](https://typst.app) also provides an online interface. That could
be especially useful for collaborating on documents. You can create a
.typ file by including

``` yaml
format:
  preprint-typst:
    keep-typ: true
```

in the document’s YAML. Then, copypaste the resulting .typ file and
other required materials (bibliography file, image files, etc) to the
Typst online interface. See an example
[here](https://typst.app/project/rk4zWONKPIF5lRxF_HU1I5).

## Help

If something isn’t working, please submit an
[issue](https://github.com/mvuorre/quarto-preprint/issues), optimally
with a reproducible example / full details of what you’re trying to do,
how, and what goes wrong. You can also email Matti.

I hope that *quarto-preprint* could help encourage scholars to think
more proactively about the roles that preprints play in the modern
scholarly communication landscape (Sever 2023; Syed 2024; Moshontz et
al. 2021; Ahmed et al. 2023).

Why might one use the *quarto-preprint* extension? One, it renders
documents from Quarto markdown to PDF using
[Typst](https://typst.app/docs)[^1], and therefore is very fast in doing
so. Typst doesn’t require complicated LaTeX installations and so is
practically easier to use than other PDF-producing methods. Typst also
simplifies the development and codebase of templates and Quarto formats,
and thus makes edits, bug fixes, forks, and new features easier. Second,
*quarto-preprint* aims to be 100% Quarto standards compliant: Users
don’t need to adapt their source code in any way when they switch to
other formats, such as other journal extensions, or completely different
output formats such as HTML[^2].

This document is both the *quarto-preprint* manual, and an example
document making use of it. You can find its Quarto markdown source code
[here](https://github.com/mvuorre/quarto-preprint/blob/main/index.qmd).
You can view the latest version of the PDF output
[here](https://mvuorre.github.io/quarto-preprint/index.pdf) ([MS
Word](https://mvuorre.github.io/quarto-preprint/index.docx),
[HTML](https://mvuorre.github.io/quarto-preprint)).

## A Quarto example

Here are the contents of a basic Quarto markdown file, called
`myfile.qmd`:

``` yaml
---
title: Example preprint
author:
  - name: Matti Vuorre
    email: mjvuorre@uvt.nl
    orcid: 0000-0001-5052-066X
    affiliation:
      - ref: 1
affiliations:
  - id: 1
    name: Tilburg University
    department: Department of Social Psychology
bibliography: bibliography.bib
format: pdf
---

This text will end up in the rendered .html file. Exciting [@r2024]!
```

This source code renders (e.g. in
[RStudio](https://quarto.org/docs/get-started/authoring/rstudio.html#rendering)
or
[CLI](https://quarto.org/docs/get-started/authoring/text-editor.html#rendering))
to <a href="#fig-ex" class="quarto-xref">Figure 1</a> (left).

<div id="fig-ex">

![](ex.png)


Figure 1: A cropped version of a basic Quarto .pdf document (left) and a
*preprint* Quarto .pdf document (right).

</div>

However, <a href="#fig-ex" class="quarto-xref">Figure 1</a> (left) lacks
several features that we’ve come to expect from scholarly outputs, such
as authors’ affiliations. *quarto-preprint* includes many such features.
Changing `format: pdf` in the above source code to
`format: preprint-typst` instructs Quarto to use the extension, which
produces the PDF document in
<a href="#fig-ex" class="quarto-xref">Figure 1</a> (right).

That is, *quarto-preprint* is a Quarto extension that provides a Quarto
format called `preprint-typst`, which formats your Quarto source—which
can be prose, code, math, tables, figures, etc.—to a pleasant looking
.pdf via Typst.

# *quarto-preprint* manual

The preprint Quarto extension provides functionality through Quarto
metadata, some of which is mapped to a Typst template and its variables.
Therefore, if you cannot find the information you’re looking for in this
manual, consult either the
[Quarto](https://quarto.org/docs/output-formats/typst.html) or
[Typst](https://typst.app/docs) documentation.

In the documentation below, we have divided the YAML metadata options to
two sections. First are options that are common to most if not all
Quarto formats. Second are options specific to the Typst format and the
*quarto-preprint* Typst format extension.

## Common Quarto options

The code snippet above showed YAML metadata between triple-dashes. This
YAML metadata can be used to control the output such as fonts, authors,
whether to include a table of contents, and many more. We list and
explain these options, with examples, below in roughly a decreasing
order of importance to typical scholarly manuscripts.

### Title

``` yaml
title: "*preprint*: A Quarto Typst extension for computationally reproducible manuscripts"
```

Title of the manuscript. Required; needs to be in quotation marks only
if it includes special characters such as colons. See relevant Quarto
[documentation](https://quarto.org/docs/output-formats/html-basics.html#overview).

### Authors & affiliations

``` yaml
author:
  - name: Matti Vuorre
    email: mjvuorre@uvt.nl
    orcid: 0000-0001-5052-066X
    url: https://www.tilburguniversity.edu/staff/m-j-vuorre
    affiliation:
      - ref: 1
affiliations:
  - id: 1
    name: Tilburg University
    department: Department of Social Psychology
```

Authors and their affiliations as explained in Quarto’s scholarly
writing
[documentation](https://quarto.org/docs/authoring/front-matter.html).

A few features are not yet included. The `corresponding: true` syntax
for indicating corresponding authors does not work. To indicate a
corresponding author, specify an email for that author (as in above
example). The `equal-contributor: true` option is not yet implemented.

### Abstract, keywords, & date

``` yaml
abstract: |
  This document and its source code (`manual.qmd`) illustrate uses of various [Quarto](https://quarto.org) & *preprint* extension features, such as weaving R code [@r2024] and prose.
keywords: 
  - list 
  - keywords
  - here
  - but not
  - too many
date: "`r Sys.Date()`"
```

The document’s abstract can include multiple paragraphs, Markdown,
maths, references, and more. A list of keywords and the document’s date
can be added. Above example shows how to include the current date using
R.

### Citation information

``` yaml
citation:
  type: article-journal
  container-title: "PsyArXiv"
  doi: "10.31234/osf.io/z3ejx"
  url: https://osf.io/preprints/psyarxiv/z3ejx
```

This information is used by Quarto to include the document’s citation
information to various formats and the document’s metadata. See relevant
Quarto
[documentation](https://quarto.org/docs/authoring/create-citeable-articles.html).

### Other common options

``` yaml
bibliography: bibliography-manual.bib
linkcolor: blue
mainfont: Fira Sans
fontsize: 10pt
toc: true
toc_depth: 2
toc_title: "Contents of the document"
code-links: repo
```

The above shows how to specify a bibliography file, color for links in
the document, the main font and its size, table of contents (and its
options). The `code-links` option is useful when the output formats
include HTML.

### Format

You can specify one or more formats, and settings specific to them,
under the `format` key. See
[here](https://quarto.org/docs/output-formats/typst.html) for Quarto’s
Typst-specific format options.

``` yaml
format:
  preprint-typst: 
    keep-typ: true
```

## Typst & preprint-extension options

``` yaml
running-head: "*preprint* Quarto extension manual"
branding: psyarxiv
authornote: This is an example author note.
```

`running-head` should be a text string and is used as the document’s
running head.

`branding` adds a specified preprint service’s logo to the document.
Currently only “psyarxiv” is a valid value.

`authornote` allows adding information to the footer of the first page.

### Typst geometry, layout, and formatting options

``` yaml
leading: 0.6em
spacing: 1em
section-numbering: none
bibliography-title: "References"
bibliography-style: "apa"
margin:
  x: 1cm
  y: 3cm
cols: 1
```

- leading
  - Space between lines of text
    <https://typst.app/docs/reference/model/par/#parameters-leading>
- spacing
  - Space between paragraphs
    <https://typst.app/docs/reference/layout/block/#parameters-spacing>
- section-numbering
  - In Typst format e.g. “1.1”, do not include or leave empty (““) to
    not number sections.
- first-line-indent
  - <https://typst.app/docs/reference/model/par/#parameters-first-line-indent>
- margin
  - Page margins
    <https://typst.app/docs/reference/layout/page/#parameters-margin>
- paper
  - <https://typst.app/docs/reference/layout/page/#parameters-paper>
- lang
  - <https://typst.app/docs/reference/text/text/#parameters-lang>
- region
  - <https://typst.app/docs/reference/text/text/#parameters-region>
- bibliography-title: “References”
- bibliography-style: “apa”
- cols: columns in the main document (experimental)

# Example content

Let us first take a look at body text and headings.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Enim sed faucibus
turpis in. Nec dui nunc mattis enim ut tellus. Bibendum ut tristique et
egestas quis ipsum suspendisse ultrices gravida. Convallis posuere morbi
leo urna. Sed velit dignissim sodales ut eu sem integer vitae justo.
Convallis posuere morbi leo urna molestie at elementum eu facilisis.
Aliquam sem et tortor consequat. Quam viverra orci sagittis eu. Sed arcu
non odio euismod lacinia at quis risus sed. Egestas dui id ornare arcu
odio ut sem. Lorem ipsum dolor sit amet consectetur.

## Heading level 2

Eget arcu dictum varius duis at. Netus et malesuada fames ac turpis.
Pellentesque sit amet porttitor eget. Egestas tellus rutrum tellus
pellentesque eu tincidunt tortor. Risus quis varius quam quisque id
diam. Vel pretium lectus quam id leo in vitae. Sit amet aliquam id diam
maecenas ultricies mi eget mauris. Auctor urna nunc id cursus metus
aliquam eleifend. Arcu dictum varius duis at consectetur lorem. Tempus
iaculis urna id volutpat lacus laoreet non. Adipiscing elit ut aliquam
purus sit amet. At auctor urna nunc id cursus metus aliquam. Pharetra
vel turpis nunc eget lorem dolor.

### Heading level 3

Tristique et egestas quis ipsum suspendisse ultrices gravida dictum
fusce. Mauris commodo quis imperdiet massa tincidunt nunc pulvinar.
Commodo elit at imperdiet dui accumsan sit amet nulla. Consectetur lorem
donec massa sapien faucibus. In vitae turpis massa sed elementum tempus
egestas sed sed. Aliquam faucibus purus in massa tempor. Dignissim diam
quis enim lobortis scelerisque fermentum dui faucibus in. Montes
nascetur ridiculus mus mauris vitae ultricies leo. Sociis natoque
penatibus et magnis dis parturient montes nascetur.

#### Heading level 4

Consectetur libero id faucibus nisl. Consequat interdum varius sit amet
mattis vulputate enim. Amet mattis vulputate enim nulla aliquet
porttitor lacus luctus. Mauris augue neque gravida in fermentum et
sollicitudin ac. Pharetra diam sit amet nisl suscipit adipiscing
bibendum est ultricies. Nisi quis eleifend quam adipiscing. Diam ut
venenatis tellus in. Dignissim enim sit amet venenatis urna cursus eget.
Hac habitasse platea dictumst quisque sagittis. In fermentum et
sollicitudin ac orci phasellus egestas tellus rutrum.

##### Heading level 5

Aliquam faucibus purus in massa tempor nec feugiat nisl pretium.
Malesuada proin libero nunc consequat interdum varius. Vulputate
dignissim suspendisse in est. Congue eu consequat ac felis donec et odio
pellentesque diam. Viverra justo nec ultrices dui sapien. Faucibus vitae
aliquet nec ullamcorper sit amet risus. Metus aliquam eleifend mi in.
Risus quis varius quam quisque id diam vel quam. Et malesuada fames ac
turpis egestas integer eget aliquet.

## Floats

### Tables

Tables are still the achilles heel of Typst (and any cross-format
output, really). However, basic tables are more than possible, and below
is an example table produced in R with the tinytable package
(<a href="#tbl-example" class="quarto-xref">Table 1</a>). Note that some
features of tables, such as footnotes, are not yet implemented in Typst
/ Quarto.

``` r
tinytable::tt(
  head(data, 2),
  digits = 2
)
```

<div id="tbl-example">

Table 1: Table created with `tinytable::tt()`

<div class="cell-output-display">

| x     | y    |
|-------|------|
| -0.63 | 1.4  |
| 0.18  | -0.1 |

</div>

</div>
<div id="tbl-example2">

Table 2: Table created with `knitr::kable()`

<div class="cell-output-display">

|     x |     y |
|------:|------:|
| -0.63 |  1.36 |
|  0.18 | -0.10 |

</div>

</div>

### Figures

Below is an example figure created in R
(<a href="#fig-example" class="quarto-xref">Figure 2</a>).

<div id="fig-example">

![](index_files/figure-commonmark/fig-example-1.png)


Figure 2: Example R scatterplot.

</div>

## Quarto markdown features

### Maths

LaTeX math notation is automatically converted to Typst and as such
works just fine either inline ($y_i = \alpha + \beta x_i + \epsilon_i$)
or in display mode (<a href="#eq-1" class="quarto-xref">Equation 1</a>):

<span id="eq-1">$$
f(x \mid \mu, \sigma^2) = \frac{1}{\sqrt{2\pi \sigma^2}} \exp\left(-\frac{(x-\mu)^2}{2\sigma^2}\right)
 \qquad(1)$$</span>

### Block quotes

To insert a quote block, prepend a paragraph with `>`:

> A quote: “*Elit ullamcorper dignissim cras tincidunt lobortis feugiat
> vivamus at.*”

### Callouts

[Callout blocks](https://quarto.org/docs/authoring/callouts.html), such
as <a href="#tip-example" class="quarto-xref">Tip 1</a>, can be useful
for highlighting content, such as one might do in a box that defines key
terms, etc.

> [!TIP]
>
> ### All kinds of markup
>
>     This is basic markdown: **bold text** & ~subscript~.
>
> This is basic markdown: **bold text** & <sub>subscript</sub>.

### Code listings

Code listings can also be cross-referenced
(<a href="#lst-r" class="quarto-xref">Listing 1</a>).

<div id="lst-r">

Listing 1: R code for pRos.

    1+1
    ## [1] 2

</div>

# Help & contributing

Send your bug reports and pull requests to
<https://github.com/mvuorre/quarto-preprint>.

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0">

<div id="ref-ahmedFutureAcademicPublishing2023" class="csl-entry">

Ahmed, Abubakari, Aceil Al-Khatib, Yap Boum, Humberto Debat, Alonso
Gurmendi Dunkelberg, Lisa Janicke Hinchliffe, Frith Jarrad, et al. 2023.
“The Future of Academic Publishing.” *Nature Human Behaviour*, July,
1–6. <https://doi.org/10.1038/s41562-023-01637-2>.

</div>

<div id="ref-moshontzGuidePostingManaging2021" class="csl-entry">

Moshontz, Hannah, Grace Binion, Haley Walton, Benjamin T. Brown, and
Moin Syed. 2021. “A Guide to Posting and Managing Preprints.” *Advances
in Methods and Practices in Psychological Science* 4 (2):
25152459211019948. <https://doi.org/10.1177/25152459211019948>.

</div>

<div id="ref-severBiomedicalPublishingHistoric2023" class="csl-entry">

Sever, Richard. 2023. “Biomedical Publishing: Past Historic, Present
Continuous, Future Conditional.” *PLOS Biology* 21 (10): e3002234.
<https://doi.org/10.1371/journal.pbio.3002234>.

</div>

<div id="ref-syedValuingPreprintsMust2024" class="csl-entry">

Syed, Moin. 2024. “Valuing Preprints Must Be Part of Responsible
Research Assessment.” *Meta-Psychology* 8 (March).
<https://doi.org/10.15626/MP.2023.3758>.

</div>

</div>

[^1]: “*[Typst](https://typst.app/docs) is a new markup-based
    typesetting system for the sciences. It is designed to be an
    alternative both to advanced tools like LaTeX and simpler tools like
    Word and Google Docs.*”

[^2]: There are a few small features that likely won’t show up in other
    formats, such as `branding` (see below), but their inclusion or
    exclusion in the metadata doesn’t impact how sources are rendered to
    other formats.
