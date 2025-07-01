# *quarto-preprint*: A Quarto extension for creating PDF documents with Typst
Matti Vuorre
2025-07-01

- [Install](#install)
- [Use & configuration](#use--configuration)
  - [Universal Quarto options](#universal-quarto-options)
  - [Quarto Typst options](#quarto-typst-options)
  - [Advanced Typst formatting](#advanced-typst-formatting)
  - [*preprint-typst* extension options](#preprint-typst-extension-options)
- [Example content](#example-content)
  - [Floats](#floats)
  - [Full-width content](#full-width-content)
  - [Maths](#maths)
- [Get help & contribute](#get-help--contribute)
- [References](#references)
- [Appendix A: Tips and tricks](#appendix-a-tips-and-tricks)

<!-- README.md is automatically generated from manual.qmd -->

**[Example *preprint-typst* document](https://vuorre.com/quarto-preprint/manual.pdf)**.

> “An article about computational science in a scientific publication is not the scholarship itself, it is merely advertising of the scholarship. The actual scholarship is the complete software development environment and the complete set of instructions which generated the figures.” –Buckheit and Donoho (1995, paraphrasing Jon Claerbout)

[Quarto](https://quarto.org/) is “An open-source scientific and technical publishing system” (Allaire et al., 2025) for writing reproducible documents that combine computations and prose written in [markdown](https://quarto.org/docs/authoring/markdown-basics.html) into HTML, PDF, Word, and other outputs. For many R users, Quarto is a successor of [R Markdown](https://rmarkdown.rstudio.com/) but with a broader scope and better support for different output formats and computational content in other languages.

[*quarto-preprint*](https://github.com/mvuorre/quarto-preprint) is a Quarto extension that provides one such output format, called *preprint-typst*. When using this format, Quarto renders your document into PDF using [Typst](https://typst.app/), a modern replacement for LaTeX. *preprint-typst* builds on the standard Quarto Typst template and enables separated author-affiliation formatting, additional (Quarto, Typst, and custom) metadata variables, opinionated typesetting, improved two-column layouts (including full-width floats), appendices, and more (read below).

This document explains how to install, use and customize the output of Quarto documents created with the *preprint-typst* format. Example manuscripts using *preprint-typst* format include:

- Vuorre, M. (2025). Estimating Signal Detection Models with regression using the brms R package. OSF. <https://doi.org/10.31234/osf.io/vtfc3_v1>
- Vuorre, M., Johannes, N., & Przybylski, A. (2025). Three objections to a novel paradigm in social media effects research. OSF. <https://doi.org/10.31234/osf.io/dpuya_v2>
- Vuorre, M., Kay, M., & Bolger, N. (2024). Communicating causal effect heterogeneity. OSF. <https://doi.org/10.31234/osf.io/mwg4f>

# Install

You can use this Quarto extension in two ways. First, you can add it to an existing project with

``` zsh
quarto add mvuorre/quarto-preprint
```

The `quarto add` command, which you use on the command line and not the R console, creates a `_extensions/preprint/` directory in your project. The *preprint-typst* format is then ready to use in any Quarto document in that project.

Second, you can start a new [Quarto project](https://quarto.org/docs/projects/quarto-projects.html) that uses *quarto-preprint* with `quarto-use`:

``` bash
quarto use template mvuorre/quarto-preprint
```

You will then answer a series of questions (project name etc.) and end up with a new project directory with a {project-name}.qmd file that provides a starter Quarto document template that uses the *preprint-typst* format. It also creates a boilerplate [\_quarto.yml](https://quarto.org/docs/projects/quarto-projects.html#shared-metadata) file where you can specify the Quarto project’s metadata, and an example bibliography.bib file.

# Use & configuration

The output of Quarto documents is configured through YAML front matter [metadata](https://quarto.org/docs/authoring/front-matter.html). To specify an [output format](https://quarto.org/docs/output-formats/all-formats.html) for your document, include (for example) `format: preprint-typst` in the front matter. Here is a minimal example YAML front matter that specifies a title, a table of contents, and two output formats:

``` yaml
---
title: A document
# Top-level options apply to all formats,
# such as this table of contents
toc: true
format:
  preprint-typst:
    # Options under a format apply only to that format
    wordcount: true
  html:
    title-block-banner: true
---
Document content goes here...
```

Note that many front matter variables can be specified for all output formats (such as `toc` above) or for only some of them (like `wordcount` above). To learn more about Quarto’s front matter options, see Quarto’s [guide](https://quarto.org/docs/authoring/front-matter.html) to writing scholarly documents, and Quarto’s Typst format [documentation](https://quarto.org/docs/output-formats/typst.html).

*preprint-typst* aims to include all standard Quarto front matter options for scholarly writing. In addition to standard Quarto YAML variables, *preprint-typst* supports additional fields and Typst variables, such as author notes and paragraph formatting. Below, we list available YAML configuration options roughly organized by their specificity to different Quarto output formats.

## Universal Quarto options

*These work across all Quarto output formats (HTML, PDF, Word, etc.)*

### Document information

- `title` (string) - Document title \[Documentation: [Quarto](https://quarto.org/docs/authoring/front-matter.html)\]
  - Example: `title: "My Paper"`
- `author` (string/array) - Author details with name, affiliation, email, etc. \[[Quarto](https://quarto.org/docs/authoring/front-matter.html#authors-and-affiliations)\]
- `affiliations` (array) - Author affiliations with id, name, department \[[Quarto](https://quarto.org/docs/authoring/front-matter.html#authors-and-affiliations)\]
- `subtitle` (string) - Document subtitle \[[Quarto](https://quarto.org/docs/authoring/front-matter.html)\]
  - Example: `subtitle: "A Study"`
- `abstract` (string) - Document abstract \[[Quarto](https://quarto.org/docs/authoring/front-matter.html)\]
  - Example: `abstract: "This study..."`
- `categories` (array) - Keywords/categories for the document \[[Quarto](https://quarto.org/docs/authoring/front-matter.html)\]
  - Example: `categories: ["science", "study"]`
- `date` (string) - Publication date \[[Quarto](https://quarto.org/docs/authoring/front-matter.html)\]
  - Example: `date: "2024-01-01"`
- `toc` (boolean) - Include table of contents \[[Quarto](https://quarto.org/docs/output-formats/typst.html)\]
  - Example: `toc: true`
- `toc-title` (string) - Customize TOC title \[[Quarto](https://quarto.org/docs/output-formats/typst.html)\]
  - Example: `toc-title: "Contents"`
- `toc-depth` (integer) - Number of heading levels in TOC \[[Quarto](https://quarto.org/docs/output-formats/typst.html)\]
  - Example: `toc-depth: 2`
- `number-sections` (boolean) - Number section headings \[[Quarto](https://quarto.org/docs/output-formats/typst.html)\]
  - Example: `number-sections: true`

### Bibliography & citations

- `bibliography` (string/array) - Bibliography file \[[Quarto](https://quarto.org/docs/authoring/footnotes-and-citations.html)\]
  - Example: `bibliography: "bibliography.bib"`
- `csl` (string) - Citation Style Language file or [URL](https://www.zotero.org/styles/) \[[Quarto](https://quarto.org/docs/authoring/citations.html)\]
  - Example: `csl: https://www.zotero.org/styles/apa` or `csl: apa.csl`
- `citeproc` (boolean; <a href="#tip-bib" class="quarto-xref">Tip 1</a>) - Use Pandoc citation processing \[[Quarto](https://quarto.org/docs/authoring/citations.html#typst)\]
  - Example: `citeproc: true`

> [!NOTE]
>
> ### Quarto, Typst, and bibliography processing
>
> Typst has its [own citation processing system](https://quarto.org/docs/authoring/citations.html#typst), but by default *preprint-typst* turns it off by using `citeproc: true` to allow better bibliography customization and use of Quarto’s [`#refs` div](https://quarto.org/docs/authoring/citations.html#bibliography-generation). In your document, include
>
> ``` md
> # References
>
> ::: {#refs}
> :::
> ```
>
> to display the bibliography section anywhere in the document. Read more at Quarto’s [citations documentation](https://quarto.org/docs/authoring/citations.html#typst).
>
> - When citeproc is off (`citeproc: false`)
>   - `bibliography-title` (string) - Bibliography section title
>     - Example: `bibliography-title: "References"`
>   - `bibliographystyle` (string) - Citation style \[[Quarto](https://quarto.org/docs/output-formats/typst.html#bibliography), [Typst](https://typst.app/docs/reference/model/bibliography/#styles)\]
>     - Example: `bibliographystyle: "apa"`

### Typography

- `fontsize` (string) - Base font size for document text \[[Quarto](https://quarto.org/docs/output-formats/typst.html)\]
  - Example: `fontsize: "11pt"`
- `mainfont` (string) - Main document font \[[Quarto](https://quarto.org/docs/output-formats/typst.html)\]
  - Example: `mainfont: "Libertinus Serif"`
- `monofont` (string) - Font family for code \[[Quarto](https://quarto.org/docs/reference/formats/html.html#fonts)\]
  - Example: `monofont: "Monacy"`
  - Note: Currently does not work ([Quarto issue](https://github.com/quarto-dev/quarto-cli/issues/12890))
- `linkcolor` (string) - Color for hyperlinks \[[Quarto](https://quarto.org/docs/output-formats/html-themes.html#basic-options), [Typst](https://typst.app/docs/reference/visualize/color/)\]
  - Example: `linkcolor: "blue"` or `linkcolor: "#0066cc"`
- `font-paths` (array) - Additional font search directories \[[Quarto](https://quarto.org/docs/output-formats/typst.html)\]
  - Example: `font-paths: ["myfonts"]`

### Language & localization

- `lang` (string) - Document language \[[Quarto](https://quarto.org/docs/authoring/language.html)\]
  - Example: `lang: "en"` or `lang: "de"`
- `region` (string) - Document region \[[Quarto](https://quarto.org/docs/authoring/language.html)\]
  - Example: `region: "US"` or `region: "GB"`

### Figures

- `fig-format` (string) - Figure output format \[[Quarto](https://quarto.org/docs/computations/execution-options.html#figure-format)\]
  - Example: `fig-format: "svg"` or `fig-format: "png"`

## Quarto Typst options

*These work in Quarto’s Typst output formats but may not work in HTML, Word, etc.*

### Page layout

- `papersize` (string) - Page size specification \[[Quarto](https://quarto.org/docs/output-formats/typst.html)\]
  - Example: `papersize: a4`
- `margin` (object/string) - Page margins \[[Quarto](https://quarto.org/docs/output-formats/typst.html)\]
  - Example: `margin: {x: 2.8cm, y: 2.6cm}`
- `columns` (integer) - Number of content columns \[[Quarto](https://quarto.org/docs/output-formats/typst.html)\]
  - Example: `columns: 2`
- `page-numbering` (string) - Page numbering pattern \[[Typst](https://typst.app/docs/reference/model/page/#parameters-numbering)\]
  - Example: `page-numbering: "1"` or `page-numbering: "i"`

### Section numbering

- `section-numbering` (string) - Section numbering pattern \[[Quarto](https://quarto.org/docs/output-formats/typst.html)\]
  - Example: `section-numbering: "1.1.a"` or `section-numbering: "1.A.a"`

## Advanced Typst formatting

*These are native Typst variables exposed through the extension*

- `line-number` (boolean) - Enable line numbers \[[Typst](https://typst.app/docs/reference/model/par/#parameters-numbering)\]
  - Example: `line-number: true`
- `leading` (string) - Line height/spacing between lines \[[Typst](https://typst.app/docs/reference/model/par/#parameters-leading)\]
  - Example: `leading: "0.5em"`
- `spacing` (string) - Vertical spacing between paragraphs \[[Typst](https://typst.app/docs/reference/model/par/#parameters-spacing)\]
  - Example: `spacing: "0.6em"`
- `first-line-indent` (string) - Indentation for paragraph first lines \[[Typst](https://typst.app/docs/reference/model/par/#parameters-first-line-indent)\]
  - Example: `first-line-indent: "1.8em"`
- `all` (boolean) - Whether to indent all paragraphs (including first in section) \[[Typst](https://typst.app/docs/reference/model/par/#parameters-first-line-indent)\]
  - Example: `all: false`
- `col-gutter` (string) - Horizontal spacing between columns \[[Typst](https://typst.app/docs/reference/layout/columns/)\]
  - Example: `col-gutter: "4.2%"` or `col-gutter: "2em"`
- `toc-indent` (string) - TOC indentation \[[Typst](https://typst.app/docs/reference/model/outline/)\]
  - Example: `toc-indent: "1.5em"`

## *preprint-typst* extension options

*These are custom features specific to this extension*

- `running-head` (string) - Short title text displayed in page headers
  - Example: `running-head: "Short Title"`
- `authornote` (string) - Text appearing after corresponding author information
  - Example: `authornote: "Author affiliations and contact"`
- `wordcount` (boolean) - Display word count below abstract
  - Example: `wordcount: true`
- `theme-jou` (boolean) - Apply journal theme with 2-column layout and compact spacing
  - Example: `theme-jou: true`
- `functions` (array) - Enable Typst functions in divs \[[typst-function](https://github.com/christopherkenny/typst-function)\]
  - Example: `functions: ["place", "appendix"]`

When starting a new project that uses the *quarto-preprint* template (`quarto use template mvuorre/quarto-preprint`), the template Quarto file already includes some useful variables and their values. See Quarto’s Typst [documentation](https://quarto.org/docs/output-formats/typst.html) for standard options and Typst [documentation](https://typst.app/docs) for styling details.

# Example content

Below, we highlight some useful Quarto content features to show how they work with the *preprint-typst* output format.

## Floats

### Tables

<a href="#lst-r" class="quarto-xref">Listing 1</a> shows an example R (R Core Team, 2025) code snippet for creating tables (<a href="#tbl-example" class="quarto-xref">Table 1</a>) with the tinytable R package (Arel-Bundock, 2025).

<div id="lst-r">

Listing 1: R code example.

``` r
library(tinytable)
tt(mtcars[1:3, 1:5])
```

</div>

<div id="tbl-example">

Table 1: Information on various cars.

<div class="cell-output-display">

| mpg  | cyl | disp | hp  | drat |
|------|-----|------|-----|------|
| 21.0 | 6   | 160  | 110 | 3.90 |
| 21.0 | 6   | 160  | 110 | 3.90 |
| 22.8 | 4   | 108  | 93  | 3.85 |

</div>

</div>

### Figures

Figures are centered by default.

<div id="fig-1">

![](data:image/svg+xml;base64,PHN2ZyB3aWR0aCA9ICI0MDAiIGhlaWdodCA9ICIyMDAiIHhtbG5zID0gImh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB2aWV3Qm94ID0gIjAgMCA0MDAgMjAwIj48cmVjdCB3aWR0aCA9ICI0MDAiIGhlaWdodCA9ICIyMDAiIGZpbGwgPSAiI2RkZCIgLz48dGV4dCB4ID0gIjUwJSIgeSA9ICI1MCUiIGZvbnQtZmFtaWx5ID0gInNhbnMtc2VyaWYiIGZvbnQtc2l6ZSA9ICIyMCIgZmlsbCA9ICIjMDAwIiB0ZXh0LWFuY2hvciA9ICJtaWRkbGUiPjQwMCB4IDIwMDwvdGV4dD48L3N2Zz4=)

Figure 1: Example figure.

</div>

<a href="#fig-1" class="quarto-xref">Figure 1</a> is a figure.

## Full-width content

You can also include page-wide figures (or any other content) in documents that have more than one column. See <a href="#fig-2" class="quarto-xref">Figure 2</a> for an example. First, include

``` yaml
functions: place
```

in the document’s YAML. Then, wrap your figure in a [Quarto div](https://quarto.org/docs/authoring/markdown-basics.html#sec-divs-and-spans) like this:

    ::: {.place arguments='auto, scope: "parent", float: true'}
    Everything here will span the whole page.
    :::

The above uses the Typst’s [`place()` function](https://typst.app/docs/reference/layout/place/) through the [typst-function](https://github.com/christopherkenny/typst-function) Quarto extension to place the div’s content in `"parent"` scope (the document page is the column’s parent) and must specify that Typst should treat the content as a float. `auto` indicates where the figure should be on the page, and can be either `auto`, `bottom`, or `top`. (Note `auto` and `bottom` can make the figure appear below footnotes.)

<div class="place" arguments="auto, scope: &quot;parent&quot;, float: true">

<div id="fig-2">

![](data:image/svg+xml;base64,PHN2ZyB3aWR0aCA9ICI2MDAiIGhlaWdodCA9ICIxMDAiIHhtbG5zID0gImh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB2aWV3Qm94ID0gIjAgMCA2MDAgMTAwIj48cmVjdCB3aWR0aCA9ICI2MDAiIGhlaWdodCA9ICIxMDAiIGZpbGwgPSAiI2RkZCIgLz48dGV4dCB4ID0gIjUwJSIgeSA9ICI1MCUiIGZvbnQtZmFtaWx5ID0gInNhbnMtc2VyaWYiIGZvbnQtc2l6ZSA9ICIxMCIgZmlsbCA9ICIjMDAwIiB0ZXh0LWFuY2hvciA9ICJtaWRkbGUiPjYwMCB4IDEwMDwvdGV4dD48L3N2Zz4=)

Figure 2

</div>

</div>

## Maths

LaTeX math notation is automatically converted to Typst and as such works just fine either inline ($y_i = \alpha + \beta x_i + \epsilon_i$) or in display mode (<a href="#eq-1" class="quarto-xref">Equation 1</a>).

<span id="eq-1">$$
f(x \mid \mu, \sigma^2) = \frac{1}{\sqrt{2\pi \sigma^2}} \exp\left(-\frac{(x-\mu)^2}{2\sigma^2}\right)
 \qquad(1)$$</span>

# Get help & contribute

Send your comments, bug reports, and pull requests to <https://github.com/mvuorre/quarto-preprint>. If you’re reporting a bug, please include a reproducible example / full details of what you’re trying to do, how, and what goes wrong.

# References

<!-- Using Quarto's special `#refs` div allows placing the reference section anywhere in the document, for example above any potential appendices. -->

<div id="refs" class="references csl-bib-body hanging-indent" entry-spacing="0" line-spacing="2">

<div id="ref-allaireQuarto2025" class="csl-entry">

Allaire, J. J., Teague, C., Scheidegger, C., Xie, Y., Dervieux, C., & Woodhull, G. (2025). *Quarto*. <https://doi.org/10.5281/zenodo.5960048>

</div>

<div id="ref-tinytable" class="csl-entry">

Arel-Bundock, V. (2025). *Tinytable: Simple and configurable tables in ’HTML’, ’LaTeX’, ’markdown’, ’word’, ’PNG’, ’PDF’, and ’typst’ formats*. <https://vincentarelbundock.github.io/tinytable/>

</div>

<div id="ref-rcoreteamLanguageEnvironmentStatistical2025" class="csl-entry">

R Core Team. (2025). *R: A Language and Environment for Statistical Computing. Version 4.4.3* (Version 4.4.3) \[Computer software\]. R Foundation for Statistical Computing. <https://www.R-project.org/>

</div>

</div>

<div class="appendix">

# Appendix A: Tips and tricks

To include and appendix (<a href="#tip-appendix" class="quarto-xref">Tip 2</a>), place it at the end of the document and wrap all its content in an `.appendix` Quarto div:

``` md
::: {.appendix}
# Appendix: Computational details
Here we describe the computational details of our approach...
:::
```

> [!TIP]
>
> Appendices are an experimental feature. They are provided through a custom Typst function using the [`typst-function`](https://github.com/christopherkenny/typst-function/) Quarto extension, and their implementation and functionality may change as Quarto’s Typst integration matures.

## Citation management

Quarto documents require citations in a separate .bib file. The [vscode-zotero](https://vuorre.com/posts/zotero-positron-vscode/) VS Code plugin helps with inserting in-text citations and managing the .bib file. The plugin works in all VS Code based editors, including [Positron](https://github.com/posit-dev/positron).

## Fonts

Run `quarto typst fonts` in your terminal (not R console) to list all available fonts.

## Example appendix content

Appendices have appropriate float references like <a href="#fig-3" class="quarto-xref">Figure 3</a>, <a href="#tbl-3" class="quarto-xref">Table 2</a>, <a href="#lst-app" class="quarto-xref">Listing 2</a>.

<div id="fig-3">

![](data:image/svg+xml;base64,PHN2ZyB3aWR0aCA9ICIyMDAiIGhlaWdodCA9ICIxMDAiIHhtbG5zID0gImh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB2aWV3Qm94ID0gIjAgMCAyMDAgMTAwIj48cmVjdCB3aWR0aCA9ICIyMDAiIGhlaWdodCA9ICIxMDAiIGZpbGwgPSAiI2RkZCIgLz48dGV4dCB4ID0gIjUwJSIgeSA9ICI1MCUiIGZvbnQtZmFtaWx5ID0gInNhbnMtc2VyaWYiIGZvbnQtc2l6ZSA9ICIxMCIgZmlsbCA9ICIjMDAwIiB0ZXh0LWFuY2hvciA9ICJtaWRkbGUiPjIwMCB4IDEwMDwvdGV4dD48L3N2Zz4=)

Figure 3: A gray rectangle.

</div>

<div id="tbl-3">

Table 2: Another gray rectangle.

![](data:image/svg+xml;base64,PHN2ZyB3aWR0aCA9ICIyMDAiIGhlaWdodCA9ICIxMDAiIHhtbG5zID0gImh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB2aWV3Qm94ID0gIjAgMCAyMDAgMTAwIj48cmVjdCB3aWR0aCA9ICIyMDAiIGhlaWdodCA9ICIxMDAiIGZpbGwgPSAiI2RkZCIgLz48dGV4dCB4ID0gIjUwJSIgeSA9ICI1MCUiIGZvbnQtZmFtaWx5ID0gInNhbnMtc2VyaWYiIGZvbnQtc2l6ZSA9ICIxMCIgZmlsbCA9ICIjMDAwIiB0ZXh0LWFuY2hvciA9ICJtaWRkbGUiPjIwMCB4IDEwMDwvdGV4dD48L3N2Zz4=)

</div>

<div id="lst-app">

Listing 2: Example R code.

``` r
sqrt(1 + 1)
## [1] 1.414214
```

</div>

Equations (<a href="#eq-app" class="quarto-xref">Equation 2</a>) work too but their numbering continues from main document.

<span id="eq-app">$$
f(x \mid \mu, \sigma^2) = \frac{1}{\sqrt{2\pi \sigma^2}} \exp\left(-\frac{(x-\mu)^2}{2\sigma^2}\right)
 \qquad(2)$$</span>

</div>
