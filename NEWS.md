## 1.0.0

In progress

- Fix appendix alignment from center to left

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
