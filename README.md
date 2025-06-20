*quarto-preprint* is a [Quarto](https://quarto.org) extension for rendering Quarto source documents to PDF documents via [Typst](https://typst.app/docs). It aims to

- Just Work™️
  - Typst doesn't require complicated LaTeX installations
- Be fast
  - Typst creates PDF files very quickly
- Be 100% Quarto standards compliant
  - Write manuscripts without worrying about formatting & metadata
  - Switch to any Quarto journal format without changing anything but `format:` (and whatever is required by the destination format)

To use (see below), install the extension and set your Quarto output format to `preprint-typst`. The extension also provides a `preprint-docx` format, which renders Quarto source documents to MS Word documents with some basic layout improvements.

[See example PDF here](https://github.com/mvuorre/quarto-preprint/releases/latest/download/index.pdf).

## Install

Add template to an existing project:

```bash
quarto add mvuorre/quarto-preprint
```

Start a new Quarto project that uses `quarto-preprint`:

```bash
quarto use template mvuorre/quarto-preprint
```

## Configuration and use

The output of Quarto documents is configured through YAML front-matter metadata. Read more at Quarto's [guide](https://quarto.org/docs/authoring/front-matter.html) to writing scholarly documents, Quarto's Typst format [documentation](https://quarto.org/docs/output-formats/typst.html), and the [Typst documentation](https://typst.app/docs) pages.

`preprint-typst` aims to include all standard Quarto front matter options for scholarly writing. Please report missing features on [GitHub](https://github.com/mvuorre/quarto-preprint/issues). In addition to standard Quarto front-matter, `quarto-preprint` supports additional fields and Typst variables, such as author notes and paragraph formatting ([leading, spacing, first-line-indent](https://typst.app/docs/reference/model/par/#parameters)).

### Word count

Include `wordcount: true` in the document YAML to add an approximate word count just below the abstract and keywords.

### Full-width floats in two-column mode

When writing a two-column document, include `functions: place` in the document YAML. You can then use Typst's [`place()`](https://typst.app/docs/reference/layout/place/) function to specify a div that spans the entire page. For example:

````
::: {.place arguments='auto, scope: "parent", float: true'}
```{r}
#| label: fig-fullwidth
#| fig-cap: A figure across columns.

plot(1:10, 1:10)
```
:::
````

will produce an R plot that spans the page.

### Bibliography

This uses `citeproc: true` to allow inserting reference sections before appendices using Quarto's "[refs div](https://quarto.org/docs/authoring/citations.html#bibliography-generation)". Due to Typst limitations the bibliography won't necessarily be formatted exactly as specified, for example hanging indents in APA-style bibliographies don't work. Set [`citeproc: false`](https://quarto.org/docs/authoring/citations.html#typst) and provide a `bibliographystyle` to use a Typst native bibliography, but note it won't work well with appendices.

### Appendix

Include `functions: [place, appendix]` in the document's YAML, and write content inside a `::: {.appendix}` div. That content will be placed inside an appendix that is always page-width, and comes after the references section if desired (see above).

# Help

## Contributing

Send your bug reports and pull requests to <https://github.com/mvuorre/quarto-preprint>. If you're reporting a bug, please include a reproducible example / full details of what you're trying to do, how, and what goes wrong.
