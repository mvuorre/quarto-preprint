// Standalone Typst preprint template

// Imports
#import "@preview/fontawesome:0.5.0": *
#import "@preview/wordometer:0.1.5": total-words, word-count

// Appendix function. To use, include in .typ before appendix header
// #show: appendix.with(prefix: "A")
#let appendix(prefix: "A", columns: 1, numbering: none, doc) = {
  set page(columns: columns)

  // Add pagebreak before each level 1 heading in appendices and reset counters
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    // Reset figure counters for Quarto-specific kinds
    counter(figure.where(kind: "quarto-float-fig")).update(0)
    counter(figure.where(kind: "quarto-float-tbl")).update(0)
    counter(figure.where(kind: "quarto-float-lst")).update(0)

    // Reset callout counters (for each callout type used)
    counter(figure.where(kind: "quarto-callout-Note")).update(0)
    counter(figure.where(kind: "quarto-callout-Warning")).update(0)
    counter(figure.where(kind: "quarto-callout-Tip")).update(0)
    counter(figure.where(kind: "quarto-callout-Important")).update(0)
    counter(figure.where(kind: "quarto-callout-Caution")).update(0)

    // Reset generic counters
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(math.equation).update(0)
    it
  }

  // Numberings
  set heading(supplement: [Appendix], numbering: (..nums) => {
    let levels = nums.pos()
    [#prefix#levels.map(str).join(".")]
  })
  // Hide level 2+ headings from TOC in appendices
  set heading(outlined: false)
  show heading.where(level: 1): set heading(outlined: true)

  set figure(numbering: it => {
    let h = context counter(heading).get().first()
    [#prefix#h.#it]
  })
  set math.equation(numbering: it => {
    let h = context counter(heading).get().first()
    [(#prefix#h.#it)]
  })

  // Reset heading counter
  counter(heading).update(0)

  doc
}

#let preprint(
  // Theme (sets defaults for layout)
  theme: "default",
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
  corresponding-text: "Send correspondence to:",
  // Layout settings (can override theme defaults)
  leading: 0.5em,
  spacing: 0.6em,
  first-line-indent: 1.8em,
  all: false,
  linkcolor: blue,
  fontcolor: black,
  backgroundcolor: white,
  monobackgroundcolor: none,
  headingcolor: none,
  strongcolor: none,
  margin: (x: 2.8cm, y: 2.6cm),
  paper: "a4",
  // Typography settings
  lang: "en",
  region: "US",
  font: "libertinus serif",
  monofont: "Dejavu Sans Mono",
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  // Structure settings
  sectionnumbering: none,
  pagenumbering: "1",
  linenumbering: none,
  mathnumbering: "(1)",
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
  // Theme configurations
  let themes = (
    jou: (margin: (x: 2cm, y: 2.6cm), fontsize: 10pt, cols: 2),
    dracula: (
      backgroundcolor: rgb("#282A36"),
      fontcolor: rgb("#F8F8F2"),
      linkcolor: rgb("#FF5555"),
      monobackgroundcolor: rgb("#44475A"),
      headingcolor: rgb("#BD93F9"),
      strongcolor: rgb("#50FA7B"),
    ),
  )

  // Apply theme if it exists
  if theme in themes {
    let config = themes.at(theme)
    margin = config.at("margin", default: margin)
    fontsize = config.at("fontsize", default: fontsize)
    cols = config.at("cols", default: cols)
    linkcolor = config.at("linkcolor", default: linkcolor)
    fontcolor = config.at("fontcolor", default: fontcolor)
    backgroundcolor = config.at("backgroundcolor", default: backgroundcolor)
    monobackgroundcolor = config.at("monobackgroundcolor", default: monobackgroundcolor)
    headingcolor = config.at("headingcolor", default: headingcolor)
    strongcolor = config.at("strongcolor", default: strongcolor)
  }

  /* Document settings */
  set document(
    title: title,
    author: if authors != none { authors.map(a => str(a.name.text)) } else { () },
    description: abstract,
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
    set block(
      spacing: spacing * 1.2,
      inset: (left: first-line-indent, right: first-line-indent),
    )
    it
  }

  // Number equations
  set math.equation(numbering: mathnumbering)
  // Add space around math blocks
  show math.equation.where(block: true): set block(spacing: spacing * 1.6)

  // Define space around block quotes
  show quote.where(block: true): set block(spacing: spacing * 1.8)
  // Don't indent anything in block quotes
  show quote.where(block: true): set par(first-line-indent: 0em)

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
    fill: backgroundcolor,
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
    fill: fontcolor,
  )
  // Strong/bold text
  show strong: it => {
    if strongcolor != none {
      text(fill: strongcolor, it)
    } else {
      it
    }
  }
  // Code font
  show raw: set text(font: monofont)
  show raw.where(block: true): it => {
    if monobackgroundcolor != none {
      block(fill: monobackgroundcolor, width: 100%, inset: 8pt, radius: 2pt, it)
    } else {
      block(fill: luma(230), width: 100%, inset: 8pt, radius: 2pt, it)
    }
  }

  // Headers
  set heading(numbering: sectionnumbering)
  if headingcolor != none {
    show heading: set text(fill: headingcolor)
  }
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

  // Helper for unnumbered footnotes
  let footnote_non_numbered(body) = {
    footnote(numbering: _ => [], body)
    counter(footnote).update(n => if n > 0 { n - 1 } else { 0 })
  }

  // Collect author metadata once
  let corresponding_authors = if authors != none {
    authors.filter(a => (a.keys().contains("corresponding") and a.at("corresponding") == true))
  } else { () }

  let equal_authors = if authors != none {
    authors.filter(a => (
      a.keys().contains("equal-contributor") and a.at("equal-contributor") == true
    ))
  } else { () }

  // Find first author indices for each footnote type
  let first_corresponding_idx = if corresponding_authors.len() > 0 {
    authors.position(a => corresponding_authors.contains(a))
  } else { none }

  let first_equal_idx = if equal_authors.len() > 1 {
    authors.position(a => equal_authors.contains(a))
  } else { none }

  // Construct author display with inline footnotes
  let author_display = if authors != none {
    let result = authors
      .enumerate()
      .map(((idx, a)) => {
        let parts = (a.name,)
        if authors.len() > 1 { parts.push(super(a.affiliation)) }

        // Add correspondence footnote to first corresponding author
        if corresponding_authors.contains(a) and idx == first_corresponding_idx {
          parts.push(footnote(numbering: _ => "*")[
            #corresponding-text #corresponding_authors.map(a => [#a.name, #a.email]).join(", ", last: " & ").
          ])
        } else if corresponding_authors.contains(a) {
          parts.push(super("*"))
        }

        // Add equal contributor footnote to first equal contributor
        if equal_authors.len() > 1 and equal_authors.contains(a) and idx == first_equal_idx {
          parts.push(footnote(numbering: _ => "†")[
            #equal_authors.map(a => a.name).join(", ", last: " & ") contributed equally to this work.
          ])
        } else if equal_authors.len() > 1 and equal_authors.contains(a) {
          parts.push(super("†"))
        }

        if a.keys().contains("orcid") {
          parts.push(link(a.orcid, fa-orcid(fill: rgb("a6ce39"), size: 0.8em)))
        }
        parts.join()
      })
      .join(", ", last: " & ")

    // Add author note as unnumbered footnote (if provided)
    if authornote != none {
      result + footnote_non_numbered(authornote)
    } else {
      result
    }
  } else { none }

  // Hack: Include authors outside of "scope: parent" to ensure footnotes show
  if author_display != none {
    hide(author_display)
    counter(footnote).update(n => if n > 0 { n - 1 } else { 0 })
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
        #block(width: 100%, above: 2em, below: 0em)[
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
    block(inset: (bottom: if toc { 0em } else { 2em }, left: 2.4em, right: 2.4em))[
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
