// Quarto Typst template

// Imports
#import "@preview/fontawesome:0.6.0": *
#import "@preview/wordometer:0.1.5": total-words, word-count

// Appendix function, use with YAML
// functions: [place, appendix]
// And wrap appendix in a {.appendix} div
#let appendix(content) = {
  pagebreak()
  set heading(numbering: none)
  // Reset counters
  // TODO: Programmatically reset all (callout) counters
  // TODO: Reset equation and other counters
  counter(heading).update(0)
  counter(figure.where(kind: "quarto-float-fig")).update(0)
  counter(figure.where(kind: "quarto-float-tbl")).update(0)
  counter(figure.where(kind: "quarto-float-lst")).update(0)
  counter(figure.where(kind: "quarto-callout-Note")).update(0)
  counter(figure.where(kind: "quarto-callout-Warning")).update(0)
  counter(figure.where(kind: "quarto-callout-Important")).update(0)
  counter(figure.where(kind: "quarto-callout-Tip")).update(0)
  counter(figure.where(kind: "quarto-callout-Caution")).update(0)

  // Figure & Table Numbering
  set figure(numbering: it => {
    [A.#it]
  })
  place(auto, scope: "parent", float: true, {
    set align(left)
    content
  })
}


#let preprint(
  // Document metadata
  title: none,
  running-head: none,
  subtitle: none,
  authors: (),
  affiliations: none,
  abstract: none,
  categories: none,
  wordcount: none,
  authornote: none,
  citation: none, // Not used currently
  date: none, // Not used currently
  // Layout settings
  leading: 0.5em,
  spacing: 0.6em,
  first-line-indent: 1.8em,
  all: false,
  linkcolor: blue,
  margin: (x: 2.8cm, y: 2.6cm),
  paper: "a4",
  // Typography settings
  lang: "en",
  region: "US",
  font: ("Libertinus Serif", "Times", "Times New Roman", "Arial"),
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  // Structure settings
  sectionnumbering: none,
  pagenumbering: "1",
  linenumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  cols: 1,
  col-gutter: 4.2%,
  // Bibliography settings (no effect if citeproc used)
  bibliography-title: "References",
  bibliographystyle: "apa",
  doc,
) = {
  /* Document settings */
  set document(
    title: if title != none { title } else { none },
    author: if authors != none { authors.map(a => str(a.name.text)) } else { () },
    description: if abstract != none { abstract } else { none },
    keywords: if categories != none { categories.text } else { "" },
  )
  // Link and cite colors
  show link: set text(fill: linkcolor)
  show cite: set text(fill: linkcolor) // No effect when `citeproc: true`

  // Customize Typst bibliography (no effect if using citeproc)
  set bibliography(title: bibliography-title, style: bibliographystyle)
  show bibliography: set par(spacing: spacing, leading: leading)

  // List spacing
  show list: it => {
    // Space between list items
    set par(leading: 0.48em)
    // Space around whole list
    set block(spacing: spacing * 1.2, inset: (left: first-line-indent, right: first-line-indent))
    it
  }

  /* Improved figure display */
  // Add space above and below
  show figure: f => { [#v(leading) #f #v(leading) ] }
  // Set block width to align caption to page/column
  // Target figure only as could otherwise mess with table formatting
  show figure.where(kind: "quarto-float-fig"): set block(width: 100%)
  // Left-align captions and italicize "Figure X."
  show figure.caption: it => [
    #set align(left)
    #set par(first-line-indent: 0em)
    #emph([#it.supplement #context it.counter.display(it.numbering).])
    #it.body
  ]

  /* Page layout settings */
  set page(
    paper: paper,
    margin: margin,
    numbering: none,
    columns: cols,
    header-ascent: 50%,
    header: context {
      if (counter(page).get().at(0) > 1) [
        #grid(
          columns: (1fr, 1fr),
          align(left)[#running-head], align(right)[#counter(page).display(pagenumbering)],
        )
      ]
    },
    footer-descent: 10%,
  )
  set columns(gutter: col-gutter)

  /* Typography settings */

  // Paragraph settings
  set par(justify: true, leading: leading, spacing: spacing, first-line-indent: (amount: first-line-indent, all: all))
  set par.line(numbering: linenumbering)

  // Text settings
  set text(
    lang: lang,
    region: region,
    font: font,
    size: fontsize,
  )

  // Headers
  set heading(numbering: sectionnumbering)
  show heading.where(level: 1): it => block(width: 100%, below: 0.8em, above: 1em)[
    #set align(center)
    #set text(size: fontsize * 1.1, weight: "bold")
    #it
  ]
  show heading.where(level: 2): it => block(width: 100%, below: 0.8em, above: 1em)[
    #set text(size: fontsize * 1.05)
    #it
  ]
  show heading.where(level: 3): it => block(width: 100%, below: 0.6em, above: 0.8em)[
    #set text(size: fontsize, style: "italic")
    #it
  ]
  // Level 4 & 5 headers are in paragraph
  show heading.where(level: 4): it => box(inset: (top: 0em, bottom: 0em, left: 0em, right: 0.1em), text(
    size: 1em,
    weight: "bold",
    it.body + [.],
  ))
  show heading.where(level: 5): it => box(inset: (top: 0em, bottom: 0em, left: 0em, right: 0.1em), text(
    size: 1em,
    weight: "bold",
    style: "italic",
    it.body + [.],
  ))

  // Construct author display
  let author_display = if authors != none {
    authors
      .map(a => {
        let parts = (a.name,)
        if authors.len() > 1 { parts.push(super(a.affiliation)) }
        let equal_authors = authors.filter(auth => (
          auth.keys().contains("equal-contributor") and auth.at("equal-contributor") == true
        ))
        if a.keys().contains("equal-contributor") and a.at("equal-contributor") == true and equal_authors.len() > 1 {
          parts.push(super[§])
        }
        if a.keys().contains("corresponding") {
          parts.push(footnote(numbering: "*")[
            Send correspondence to: #a.name, #a.email.
            #if equal_authors.len() > 1 [
              #super[§]#equal_authors.map(auth => auth.name).join(", ", last: " & ") contributed equally to this work.
            ]
            #if authornote != none [#authornote]
          ])
        }
        if a.keys().contains("orcid") { parts.push(link(a.orcid, fa-orcid(fill: rgb("a6ce39"), size: 0.8em))) }
        parts.join()
      })
      .join(", ", last: " & ")
  } else { none }

  // Hack: Include authors outside of "scope: parent" to ensure footnotes show
  if author_display != none {
    hide(author_display)
    counter(footnote).update(n => n - 1)
    v(-2.4em)
  }

  // Place title, author, abstract always in one column
  place(top, scope: "parent", float: true, {
    if title != none {
      align(center)[
        #block(width: 100%, above: 0em, below: 0em)[
          #text(weight: "bold", size: title-size)[#title]
        ]
      ]
    }
    if subtitle != none {
      align(center)[
        #block(width: 100%, above: 1em, below: 0em)[
          #text(weight: "bold", size: subtitle-size)[#subtitle]
        ]
      ]
    }

    if author_display != none {
      align(center)[
        #block(width: 100%, above: 2.5em, below: 0em)[
          #text(weight: "regular", size: subtitle-size)[#author_display]
        ]
      ]
    }

    if affiliations != none {
      align(center)[
        #block(width: 100%, above: 1em, below: 2em)[
          #text(weight: "regular", size: 1.1em)[
            #for a in affiliations [
              #if authors.len() > 1 [#super[#a.id]]#a.name#if a.keys().contains("department") [, #a.department] \
            ]
          ]
        ]
      ]
    }

    /* Abstract and metadata section */
    block(inset: (top: 1em, bottom: if toc { 0em } else { 2em }, left: 2.4em, right: 2.4em))[
      #set text(size: 0.92em)
      #set par(first-line-indent: 0em)
      #if abstract != none {
        abstract
      }
      #if categories != none {
        block()[#v(0.4em)#text(style: "italic")[Keywords:] #categories]
      }
      #if wordcount == true {
        block()[#text(style: "italic")[Words:] #total-words]
      }
    ]

    // Reset footnote counter for the main document
    counter(footnote).update(0)

    // Table of contents
    if toc {
      block(inset: (top: 1em, bottom: 2em, left: 2.4em, right: 2.4em))[
        #outline(
          title: toc_title,
          depth: toc_depth,
          indent: toc_indent,
        )
      ]
    }
  })
  // Word count with wordometer package
  show: word-count.with(exclude: (<refs>))
  /* Document content */
  doc
}

// Remove gridlines from tables
#set table(
  inset: 6pt,
  stroke: none,
)
