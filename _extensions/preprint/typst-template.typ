// Standalone Typst preprint template

// Imports
#import "@preview/wordometer:0.1.5": total-words, word-count

// ORCID logo
#let fa-orcid(size: 0.8em) = box(
  height: size,
  width: size,
  image(
    bytes(
      "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 256 256\"><path fill=\"#A6CE39\" d=\"M256,128c0,70.7-57.3,128-128,128C57.3,256,0,198.7,0,128C0,57.3,57.3,0,128,0C198.7,0,256,57.3,256,128z\"/><path fill=\"#FFFFFF\" d=\"M86.3,186.2H70.9V79.1h15.4v48.4V186.2z\"/><path fill=\"#FFFFFF\" d=\"M108.9,79.1h41.6c39.6,0,57,28.3,57,53.6c0,27.5-21.5,53.6-56.8,53.6h-41.8V79.1z M124.3,172.4h24.5c34.9,0,42.9-26.5,42.9-39.7c0-21.5-13.7-39.7-43.7-39.7h-23.7V172.4z\"/><path fill=\"#FFFFFF\" d=\"M88.7,56.8c0,5.5-4.5,10.1-10.1,10.1c-5.6,0-10.1-4.6-10.1-10.1c0-5.6,4.5-10.1,10.1-10.1C84.2,46.7,88.7,51.3,88.7,56.8z\"/></svg>",
    ),
    format: "svg",
    width: 100%,
    height: 100%,
  ),
)

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
    counter(figure.where(kind: "quarto-callout-Box")).update(0)
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
  abstract-title: none,
  abstract: none,
  thanks: none,
  categories: none,
  wordcount: none,
  authornote: none,
  citation: none, // Not used currently
  date: none,
  corresponding-text: "Send correspondence to:",
  // Layout settings (can override theme defaults)
  spacing: 0.6em,
  first-line-indent: 1.8em,
  all: false,
  linkcolor: blue,
  citecolor: none,
  filecolor: none,
  margin: (x: 2.8cm, y: 2.6cm),
  paper: "a4",
  // Typography settings
  lang: "en",
  region: "US",
  font: "libertinus serif",
  codefont: none,
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: none,
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: none,
  heading-line-height: none,
  mathfont: none,
  linestretch: 10 / 13,
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
  // Apply journal theme defaults
  if theme == "jou" {
    margin = (x: 2cm, y: 2.6cm)
    fontsize = 10pt
    cols = 2
  }

  /* Document settings */
  set document(
    title: title,
    description: abstract,
    keywords: if categories != none { categories.text } else { "" },
  )
  set document(
    author: authors.map(author => content-to-string(author.name)).join(", ", last: " & "),
  ) if authors != none and authors != ()
  // Link and cite colors
  show link: set text(fill: linkcolor)
  // citecolor has no effect if `citeproc: true`
  show cite: set text(fill: if citecolor != none { citecolor } else { linkcolor })
  show ref: set text(fill: citecolor) if citecolor != none
  show link: this => {
    if filecolor != none and type(this.dest) == label {
      text(this, fill: filecolor)
    } else {
      text(this)
    }
  }

  // Customize Typst bibliography (no effect if using citeproc)
  set bibliography(title: bibliography-title, style: bibliographystyle)
  show bibliography: set par(spacing: spacing, leading: linestretch * 0.65em)

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
  show figure: f => { [#v(linestretch * 0.65em) #f #v(linestretch * 0.65em) ] }
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
  set par(justify: true, leading: linestretch * 0.65em, spacing: spacing, first-line-indent: (
    amount: first-line-indent,
    all: all,
  ))
  set par.line(numbering: linenumbering)

  // Text settings
  set text(lang: lang, region: region, size: fontsize)
  set text(font: font) if font != none
  show math.equation: set text(font: mathfont) if mathfont != none
  // Code font
  show raw: set text(font: codefont) if codefont != none

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

  let combined_authornote = if authornote != none and thanks != none {
    [#authornote #h(0.5em) #thanks]
  } else if authornote != none {
    authornote
  } else {
    thanks
  }

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
          parts.push(link(a.orcid, fa-orcid()))
        }
        parts.join()
      })
      .join(", ", last: " & ")

    // Keep all note-like metadata on the same brittle footnote path.
    if combined_authornote != none {
      result + footnote_non_numbered(combined_authornote)
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

  let has-front-matter = (
    title != none
      or subtitle != none
      or author_display != none
      or affiliations != none
      or date != none
      or abstract != none
      or categories != none
      or wordcount == true
      or toc
  )
  if has-front-matter {
    // Place title, author, abstract always in one column.
    place(top, scope: "parent", float: true, {
      if title != none {
        align(center, block(width: 100%, above: 0em, below: 0em)[
          #set par(leading: heading-line-height) if heading-line-height != none
          #set text(font: heading-family) if heading-family != none
          #set text(weight: heading-weight)
          #set text(style: heading-style) if heading-style != "normal"
          #set text(fill: heading-color) if heading-color != none

          #text(size: title-size)[#title]
          #(
            if subtitle != none {
              parbreak()
              text(size: subtitle-size)[#subtitle]
            }
          )
        ])
      } else if subtitle != none {
        align(center)[
          #block(width: 100%, above: 1em, below: 0em)[
            #text(weight: heading-weight, size: subtitle-size)[#subtitle]
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
          #block(width: 100%, above: 1em, below: if date != none { 1em } else { 2em })[
            #text(weight: "regular", size: 1.1em)[
              #for a in affiliations [
                #if authors.len() > 1 [#super[#a.id]]#a.name#if a.keys().contains("department") [, #a.department] \
              ]
            ]
          ]
        ]
      }

      if date != none {
        align(center)[#block(inset: 1em)[
          #date
        ]]
      }

      /* Abstract and metadata section */
      block(inset: (bottom: if toc { 0em } else { 2em }, left: 2.4em, right: 2.4em))[
        #set text(size: 0.92em)
        #set par(first-line-indent: 0em)
        #if abstract != none {
          if abstract-title != none {
            block()[#text(weight: "semibold")[#abstract-title] #h(1em) #abstract]
          } else {
            abstract
          }
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
  }

  // Word count with wordometer package
  show: word-count.with(exclude: (<refs>))

  /* Document content */
  doc
}
