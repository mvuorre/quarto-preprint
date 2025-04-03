*quarto-preprint* is a [Quarto](https://quarto.org) extension for rendering Quarto source documents to PDF documents via [Typst](https://typst.app/docs). It aims to

- Just Work™️
  - Typst doesn't require complicated LaTeX installations
- Be fast
  - Typst creates PDF files very quickly
- Be 100% Quarto standards compliant
  - Write manuscripts without worrying about formatting & metadata
  - Switch to any Quarto journal format without changing anything but `format:` (and whatever is required by the destination format)

To use (see below), install the extension and set your Quarto output format to `preprint-typst`. The extension also provides a `preprint-docx` format, which renders Quarto source documents to MS Word documents with some basic layout improvements.

Example output: <https://github.com/mvuorre/quarto-preprint/releases/latest/download/index.pdf>.

## Install

Add template to an existing project:

```bash
quarto add mvuorre/quarto-preprint
```

Start a new Quarto project that uses `quarto-preprint`:

```bash
quarto use template mvuorre/quarto-preprint
```

## Configuration

The output of Quarto documents is configured through YAML metadata either in the document's front matter (between triple dashes), or in a `_quarto.yml` file. Read more about these at Quarto's [guide](https://quarto.org/docs/authoring/front-matter.html) to writing scholarly documents, Quarto's Typst format [documentation](https://quarto.org/docs/output-formats/typst.html), and the [Typst documentation](https://typst.app/docs) pages.

`preprint-typst` aims to include all standard Quarto front matter options for scholarly writing. Please report missing features (or other bugs) on [GitHub](https://github.com/mvuorre/quarto-preprint/issues). In addition, there are a few options specific to Typst, and the `quarto-preprint` format.

## Options specific to `quarto-preprint`

```{yaml}
running-head: "*preprint* Quarto extension manual"
authornote: This is an example author note.
wordcount: "{{< words-body >}}"
```

`running-head` should be a text string and is used as the document's running head.

`authornote` allows adding information to the footer of the first page.

`wordcount` add a word count using <https://github.com/andrewheiss/quarto-wordcount> (see above example, and link for instructions on use).

# Help

## Known limitations and issues

- Must add `suppress-bibliography: true` to YAML so that the wordcount extension doesn't lead to duplicated bibliographies.

## Contributing

Send your bug reports and pull requests to <https://github.com/mvuorre/quarto-preprint>. If you're reporting a bug, please include a reproducible example / full details of what you're trying to do, how, and what goes wrong.

## Tips

### Collaboration

It can be useful to also output a MS Word document for collaboration. To do so, you can include `docx` as an output format as shown [here](https://quarto.org/docs/output-formats/ms-word.html). `quarto-preprint` also provides a slightly improved bare-bones MS Word output format `preprint-docx`.

[Typst](https://typst.app) also provides an online interface. That could be especially useful for collaborating on documents. You can create a .typ file by including

```yaml
format:
  preprint-typst:
    keep-typ: true
```

in the document's YAML. Then, copy-paste the resulting .typ file and other required materials (bibliography & image files, etc.) to the Typst online interface. See an example [here](https://typst.app/project/rk4zWONKPIF5lRxF_HU1I5).
