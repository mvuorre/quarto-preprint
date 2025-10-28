#import "typst-template.typ": appendix, preprint

#show: preprint.with(
  theme: "jou",
  title: [Test Document],
  subtitle: [Standalone Typst Package Test],
  authors: (
    (
      name: [Matti Vuorre],
      affiliation: [1],
      orcid: "https://orcid.org/0000-0000-0000-0000",
      email: [mjvuorre\@uvt.nl],
      corresponding: true,
      equal-contributor: true,
    ),
    (
      name: [Test Author],
      affiliation: [2],
      orcid: "https://orcid.org/0000-0000-0000-0000",
      email: [test\@example.com],
      corresponding: true,
      equal-contributor: true,
    ),
  ),
  affiliations: (
    (id: "1", name: "Tilburg University", department: "Department of Social Psychology"),
    (id: "2", name: "Test University", department: "Test Department"),
  ),
  corresponding-text: "Corresponding authors:",
  abstract: [#lorem(25)],
  categories: [test, typst, package],
  sectionnumbering: "1.",
  authornote: "This is an author note.",
  wordcount: true,
  toc: true,
)

= Introduction

This is an example *Typst* document using the _Typst template_ for the `quarto-preprint` Quarto @allaireQuarto2025 extension.

#quote(block: true)[
  #lorem(10)

  ---Source
]

#lorem(20)

== Subsection

#lorem(20)

= Main Content

#lorem(20) See @fig-test.

#figure(
  rect(width: 80%, height: 60pt, fill: gray),
  caption: [A test figure.],
) <fig-test>

== A Table

#lorem(20) See @tbl-test.

#figure(table(
  columns: (auto, auto, auto),
  inset: 1em,
  align: center,
  table.header([Image], [*Volume*], [*Parameters*]),
  rect(width: 4em, height: 4em, fill: gray),
  math.equation(numbering: none)[$ pi h (D^2 - d^2) / 4 $],
  [
    $h$: height \
    $D$: outer radius \
    $d$: inner radius
  ],

  rect(width: 80%, height: 6pt, fill: gray), math.equation(numbering: none)[$ sqrt(2) / 12 a^3 $], [$a$: edge length],
)) <tbl-test>

== Equation

#lorem(30)

An example equation is show in @eq-1.

$
  pi h (D^2 - d^2) / 4, \
  1 + 1 = 2
$<eq-1>

This line helps to show how much spacing there is around equations

== Code

Inline code `r x <- rnorm(10)`. Code block:

```r
data <- data.frame(
  Category = c("Type A", "Type B", "Type C"),
  Count = c(15, 23, 8),
  Percentage = c("35%", "54%", "19%")
)
```

#lorem(100)

== Full-width content

When the document is laid out in multiple columns, use `#place()` to make content span the entire page (see @fig-test-fw).

#place(top, scope: "parent", float: true)[

  = A full-width section
  #lorem(20)
  #figure(
    rect(
      width: 80%,
      height: 60pt,
      fill: gradient.linear(..color.map.rainbow),
    ),
    caption: [A test figure that spans the whole page in multiple-column documents.],
  ) <fig-test-fw>
  #lorem(30)
  == A full-width subsection
  #lorem(20)
]

== Appendices

See @example-appendix, it has more equations (@eq-app) and figures (@fig-app).

#bibliography("example.bib")

#show: appendix.with(numbering: "1.")

= Example appendix
<example-appendix>

This is an example appendix.

== Appendix content

Appendix content here. Counters reset: @eq-app, @fig-app, @tbl-app.

$ pi h (D^2 - d^2) / 4 $<eq-app>

#figure(
  rect(width: 80%, height: 60pt, fill: gray),
  caption: [A test figure.],
) <fig-app>

#figure(table(
  columns: (auto, auto, auto),
  inset: 1em,
  align: center,
  table.header([Image], [*Volume*], [*Parameters*]),
  rect(width: 4em, height: 4em, fill: gray),
  math.equation(numbering: none)[$ pi h (D^2 - d^2) / 4 $],
  [
    $h$: height \
    $D$: outer radius \
    $d$: inner radius
  ],

  rect(width: 4em, height: 4em, fill: gray), math.equation(numbering: none)[$ sqrt(2) / 12 a^3 $], [$a$: edge length],
)) <tbl-app>

= Example second appendix

A second Appendix (@eq-app2).

$ pi h (D^2 - d^2) / 4 $<eq-app2>

== A subsection
