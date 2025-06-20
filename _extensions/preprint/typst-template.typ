// Quarto Preprint Template for Typst
// A scholarly document template providing academic paper formatting
// Supports multi-column layouts, author metadata, and bibliographies

// Imports
#import "@preview/fontawesome:0.5.0": *
#import "@preview/wordometer:0.1.4": word-count, total-words

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
  counter(figure.where(kind: "quarto-callout-Tip")).update(0)

  // Figure & Table Numbering
  set figure(
    numbering: it => {
      [A.#it]
    },
  )
  place(
    auto,
    scope: "parent",
    float: true,
    {
      content
    },
  )
}

/* Front matter formatting helper functions */
// Collect authors marked as equal contributors
#let collect_equal_contributors(authors) = {
  let equal_contributors = ()
  for a in authors {
    if a.keys().contains("equal-contributor") and a.at("equal-contributor") == true {
      equal_contributors.push(a.name)
    }
  }
  equal_contributors
}

// Generate equal contributor note text
#let create_equal_contrib_text(equal_contributors) = {
  if equal_contributors.len() > 1 {
    [#equal_contributors.join(", ", last: " & ") contributed equally to this work.]
  } else {
    none
  }
}

// Build author display elements (name, affiliation, markers, etc.)
#let build_author_elements(author, authors, equal_contributors) = {
  let elements = (author.name,)

  // Add affiliation superscript for multi-author papers
  if authors.len() > 1 {
    elements.push(super(author.affiliation))
  }

  // Add equal contributor marker if needed
  if (
    author.keys().contains("equal-contributor")
      and author.at("equal-contributor") == true
      and equal_contributors.len() > 1
  ) {
    elements.push(super[§])
  }

  elements
}

// Create corresponding author footnote
#let create_corresponding_footnote(author, equal_contrib_text, authornote) = {
  footnote(
    numbering: "*",
    [
      Send correspondence to: #author.name, #author.email.
      #if equal_contrib_text != none [
        #super[§]#equal_contrib_text
      ]
      #if authornote != none [#authornote]
    ],
  )
}

// Add ORCID link if available
#let add_orcid_link(elements, author) = {
  if author.keys().contains("orcid") {
    elements.push(link(author.orcid, fa-orcid(fill: rgb("a6ce39"), size: 0.8em)))
  }
  elements
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
  leading: 0.6em,
  spacing: 0.6em,
  first-line-indent: 1.8em,
  all: false,
  linkcolor: black,
  margin: (x: 3.2cm, y: 3cm),
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
  // Link and cite colors
  show link: set text(fill: linkcolor)
  show cite: set text(fill: linkcolor)

  // Customize Typst bibliography (no effect if using citeproc)
  set bibliography(title: bibliography-title, style: bibliographystyle)
  show bibliography: set par(spacing: spacing, leading: leading)

  // Space around figures
  show figure: f => { [#v(leading) #f #v(leading) ] }

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
  set par(
    justify: true,
    leading: leading,
    spacing: spacing,
    first-line-indent: (amount: first-line-indent, all: all),
  )
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
  show heading.where(level: 1): it => block(width: 100%, below: 1em, above: 1.25em)[
    #set align(center)
    #set text(size: fontsize * 1.1, weight: "bold")
    #it
  ]
  show heading.where(level: 2): it => block(width: 100%, below: 1em, above: 1.25em)[
    #set text(size: fontsize * 1.05)
    #it
  ]
  show heading.where(level: 3): it => block(width: 100%, below: 0.8em, above: 1.2em)[
    #set text(size: fontsize, style: "italic")
    #it
  ]
  // Level 4 & 5 headers are in paragraph
  show heading.where(level: 4): it => box(
    inset: (top: 0em, bottom: 0em, left: 0em, right: 0.1em),
    text(size: 1em, weight: "bold", it.body + [.]),
  )
  show heading.where(level: 5): it => box(
    inset: (top: 0em, bottom: 0em, left: 0em, right: 0.1em),
    text(size: 1em, weight: "bold", style: "italic", it.body + [.]),
  )

  /* Author formatting */
  let author_strings = ()
  if authors != none {
    let equal_contributors = collect_equal_contributors(authors)
    let equal_contrib_text = create_equal_contrib_text(equal_contributors)

    // Build author display strings
    for a in authors {
      let author_elements = build_author_elements(a, authors, equal_contributors)

      // Add corresponding author footnote if needed
      if a.keys().contains("corresponding") {
        author_elements.push(create_corresponding_footnote(a, equal_contrib_text, authornote))
      }

      // Add ORCID link if available
      author_elements = add_orcid_link(author_elements, a)

      // Add completed author string to the list
      author_strings.push(box(author_elements.join()))
    }
  }
  // Hack: Include authors outside of scope: parent
  // to ensure their associated footnotes show in main document. (TODO)
  hide(author_strings.join(", ", last: " & "))
  counter(footnote).update(n => n - 1)
  v(-2.4em)

  place(
    top,
    scope: "parent",
    float: true,
    {
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

      if authors != none {
        align(center)[
          #block(width: 100%, above: 2.5em, below: 0em)[
            #text(weight: "regular", size: subtitle-size)[#author_strings.join(", ", last: " & ")]
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

      // Reset footnote counter for the main document
      counter(footnote).update(0)

      /* Abstract and metadata section */
      block(inset: (top: 1em, bottom: 0em, left: 2.4em, right: 2.4em))[
        #set text(size: 0.92em)
        #set par(first-line-indent: 0em)
        #if abstract != none {
          abstract
        }
        #if categories != none {
          block()[#v(0.4em)#text(style: "italic")[Keywords:] #categories]
        }
        #if wordcount == true {
          block(inset: (bottom: if toc { 0em } else { 2em }))[#text(style: "italic")[Words:] #total-words]
        }
      ]

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
    },
  )
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
