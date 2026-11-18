## 1.7.0

### Breaking changes

- Remove the legacy `theme-jou: true` option (use `theme: jou`) and the ignored `prefix` and `numbering` arguments of `appendix()`
- Remove the `corresponding-text` option; use the `preprint-correspondence` language label instead (e.g. `language: {preprint-correspondence: "Corresponding authors:"}`)
- Remove the `bibliography-title` option; use the `section-title-references` language label instead. The default title of Typst's reference list now follows the document language
- Callouts have no icons by default (Quarto's `callout-icon: false`); use `icon=true` on a callout, or `callout-icon: true` in the document, to show them
- Unlabeled display equations are no longer numbered, so equation numbers match Quarto's HTML output
- `linkcolor`, `citecolor`, and `filecolor` take hex codes (e.g. `"#0066cc"`), as in Quarto's Typst format; Typst colour names such as `blue` are no longer accepted
- `theme: jou` no longer overrides explicit `fontsize`, `columns`, and `margin` settings
- Any margin content (margin notes, `.column-margin`) makes the document one column by default, also with `theme: jou`
- The word count (`wordcount: true`) counts only the main text's prose: code, tables, figures and captions, and appendices are no longer counted
- For direct users of the Typst `preprint()` function: authors' `affiliation` is now `affiliations` (an array of ids), `corresponding-text` is now `correspondence-text`, and `mathnumbering`, `bibliography-title`, and `bibliographystyle` are removed

### New features

- Equations, callouts, and subfigures are numbered within appendices ("Equation A1", "Box A1", "Figure A1a") (#46), as are custom cross-reference kinds
- Appendix TOC entries read as in the body ("Appendix A: Title")
- "Appendix" and "Keywords" labels follow the document language; all labels can be changed with Quarto's `language` option, including the new `preprint-words`, `preprint-correspondence`, and `preprint-equal-contribution` labels
- Fix & simplify callouts
  - All note callouts, not only cross-referenced ones, render as grayscale boxes labelled "Box". The implementation no longer copies Quarto's callout code, so it is robust to Quarto updates
- Bump bundled wordometer to 0.1.6

### Fixes

- Improve Appendix numberings and headings
- Improve list formatting
- Fix compile errors with hex colours, `page-numbering: false` in multi-page documents, corresponding authors without an email, keywords containing markup, and unnumbered figure captions
- Affiliations are shown as numbers in listed order instead of their ids (e.g. "aff-1")
- Affiliation names and departments keep special characters and markup
- Title block, headings, and code blocks are no longer justified
- The starter template uses `citeproc: true`, so references appear in the References section
- Long TOCs continue to the next page instead of overprinting the bottom of page 1; TOC follows the title block in normal flow (same as Quarto's Typst format)
- Figures between `appendix()` and the first appendix heading no longer get the number "01"
- Quarto's margin layout (margin notes, `.column-margin`) no longer prints margin content over the body text
- Table captions align to the column edge like figure captions, also when the table is narrow
- Figures, tables, and callouts no longer get extra space at the top of a page or column, and consecutive ones are spaced like a figure after a paragraph

## 1.6.5

- Correspondence, equal-contribution, author note and thanks are now rendered as a single footnote paragraph on the title page
- Don't superscript corresponding author footnote symbol ("*")

## 1.6.4

- Fix first-line indent in first paragraph if no heading: The hidden author line is created so that author footnotes no longer form a paragraph before the body

## 1.6.3

- [brand.yml](https://quarto.org/docs/authoring/brand.html) is now supported (#57) to the same extent as in Quarto's native Typst format

## 1.6.2

- Enable citations within author notes
- Remove apa.csl URL from example and template (renders without internet connection)
- Improvements to test and example rendering workflow

## 1.6.1

Bundle typst packages to enable offline use:
- Drop typst/fontawesome dependency and use inline ORCID logo SVG instead
- Bundle typst/wordometer

## 1.6.0

### Implement Boxes

Use 

```md
::: {#nte-boxes .callout-note icon=false}
## This is a box
Use `icon=false` to show the box without an icon.
:::

See @nte-boxes.
```

To display and cross-reference a "Box" commonly used to highlight content in academic articles. The implementation hijacks the standard "note"-type Quarto callout, so is directly interoperable with other formats and does not affect them, which will render the boxes as standard "note" callouts.

### Other

- Deprecate & remove easter egg (it's no longer easter friends)

## 1.5.1

- Hide the abstract title by default
- Add `hide-abstract-title: false` to show abstract label

## 1.5.0

### Breaking changes

- Rename `monofont` to `codefont`
- Remove `leading`; use `linestretch`

### Other changes

- Clean source (remove independent Typst package)
- Include [new Quarto variables](https://quarto.org/docs/blog/posts/2026-03-24-1.9-release/#improvements-to-typst-support):
  - `thanks`
  - `mathfont`
  - `codefont`
  - `linestretch`
  - `citecolor`
  - `filecolor`
- Support some Quarto brand variables

## 1.4.3

- Add space around math blocks
- Reduce space around block quotes
- Suggest only one font included in Typst
- Include page-width content example in template document

## 1.4.2

- Fix counter resetting in appendices

## 1.4.1

- Don't set default `citeproc: true`
  - This may affect previous uses of the template. To fix, include `citeproc: true` in your YAML configuration

## 1.4.0

- Fix author information and authornote footnotes ([#50](https://github.com/mvuorre/quarto-preprint/issues/50))
- Support `corresponding-text` ([#40](https://github.com/mvuorre/quarto-preprint/issues/40))

## 1.3.1

- Fix critical bug (#48) (thanks @martinfleis)

## 1.3.0

- Easter egg!

## 1.2.0

- Refactor to include a standalone Typst template
- Improve documentation
- Improve appendix function

## 1.1.0

### Appendices

Appendices are now created by prepending them with, rather than wrapping in, a Typst function. This enables appendices to spread across pages. To create an appendix, use the `appendix.with()` function in a raw Typst block. For example:

````
```{=typst}
#show: appendix.with()
```

# Appendix A: Example stuff {.appendix}

Text goes here.
````

### Other changes

- Remove deprecated `blockquote()` from definitions.typ.

## 1.0.0

- Document all features
  - Standard Quarto variables
  - Variables passed to Typst
  - *preprint-typst*-specific variables

## 0.19.0

- Use custom definitions.typ to customize more elements
    - <https://quarto.org/docs/output-formats/typst-custom.html#advanced-customization>
- Fix appendix alignment from center to left
- Fix figure caption alignment
- Fix callout body text alignment

## 0.18.1

- Fix author footnote bug

## 0.18.0

- Implement appendices
    - Requires using citeproc with known Typst bibliography formatting problems
- Fix a bug where author-related footnotes didn't show up
- Refactor codebase for improved maintainability and clarity
  - Create functions to format author info
  - Simplify theme-jou conditional logic

## 0.17.0

- Support "themes" that bundle layout settings
  - `theme-jou: true` is a two-column layout with smaller margins and text

## 0.16.0

- Support full-width floats in two-column documents using <https://github.com/christopherkenny/typst-function>
- Support `line-number` (`true`/`false`)

## 0.15.0

This release brings `quarto-preprint` closer to parity with updates to the default Quarto Typst template.

## 0.14.3

- Update `andrewheiss/word-count` and required Quarto version

## 0.14.2

- Add vertical space around floats

## 0.14.1

- Remove spurious callout captions

## 0.14.0

- Support `equal-contributor` author metadata

## 0.13.0

- Allow more control over layout settings with YAML variables
  - Use `first-line-indent` and `all` to control paragraph indents
- Small layout improvements to level 4 & 5 headers
- Document more YAML variables

## 0.12.2

- Fix issue with author notes

## 0.12.1

- Fix issue with citations (#23)

## 0.12.0

- Switch to MIT license
- Automate releases

## 0.11.2

- Use "categories" instead of "keywords" for Quarto HTML compatibility
