#import "@preview/fontawesome:0.5.0": *

#let preprint(
  // Document metadata
  title: none,
  running-head: none,
  authors: (),
  affiliations: none,
  abstract: none,
  categories: none,
  wordcount: none,
  authornote: none,
  citation: none,
  date: none,
  branding: none,
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
  font: ("Times", "Times New Roman", "Arial"),
  fontsize: 11pt,
  // Structure settings
  section-numbering: none,
  toc: false,
  toc-title: none,
  toc-depth: none,
  toc-indent: 1.5em,
  bibliography-title: "References",
  bibliography-style: "apa",
  cols: 1,
  col-gutter: 4.2%,
  doc,
) = {
  /* Document settings */
  // Link and cite colors
  show link: set text(fill: linkcolor)
  show cite: set text(fill: linkcolor)

  // Allow custom title for bibliography section
  set bibliography(title: bibliography-title, style: bibliography-style)

  // Bibliography paragraph spacing
  show bibliography: set par(spacing: spacing, leading: leading)

  // Space around figures
  show figure: f => { [#v(leading * 2) #f #v(leading * 2) ] }

  /* Page layout settings */
  set page(
    paper: paper,
    margin: margin,
    numbering: none,
    header-ascent: 50%,
    header: context {
      if (counter(page).get().at(0) > 1) [
        #grid(
          columns: (1fr, 1fr),
          align(left)[#running-head], align(right)[#counter(page).display()],
        )
      ]
    },
    footer-descent: 10%,
  )

  /* Typography settings */

  // Paragraph settings
  set par(
    justify: true,
    leading: leading,
    spacing: spacing,
    first-line-indent: (amount: first-line-indent, all: all),
  )

  // Text settings
  set text(
    lang: lang,
    region: region,
    font: font,
    size: fontsize,
  )

  // Headers
  set heading(numbering: section-numbering)
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

  /* Front matter formatting */

  let titleblock(
    body,
    width: 100%,
    size: 1.5em,
    weight: "bold",
    above: 1em,
    below: 0em,
  ) = [
    #align(center)[
      #block(width: width, above: above, below: below)[
        #text(weight: weight, size: size, hyphenate: false)[#body]
      ]
    ]
  ]

  if title != none {
    titleblock(title, above: 0em, below: 2em)
  }

  /* Author formatting */

  // Format author strings here, so can use in author note
  let author_strings = ()
  let equal_contributors = ()

  if authors != none {
    // First pass: collect equal contributors
    for a in authors {
      if a.keys().contains("equal-contributor") and a.at("equal-contributor") == true {
        equal_contributors.push(a.name)
      }
    }

    // Create equal contributor note text to reuse
    let equal_contrib_text = none
    if equal_contributors.len() > 1 {
      equal_contrib_text = [#equal_contributors.join(", ", last: " & ") contributed equally to this work.]
    }

    // Second pass: build author display strings with attached footnotes
    for a in authors {
      let author_elements = (a.name,)

      // Add affiliation superscript for multi-author papers
      if authors.len() > 1 {
        author_elements.push(super(a.affiliation))
      }

      // Add equal contributor marker if needed
      if a.keys().contains("equal-contributor") and a.at("equal-contributor") == true and equal_contributors.len() > 1 {
        author_elements.push(super[§])
      }

      // Add corresponding author footnote directly to the author name
      if a.keys().contains("corresponding") {
        author_elements.push(
          footnote(
            numbering: "*",
            [
              Send correspondence to: #a.name, #a.email.
              #if equal_contrib_text != none [
                #super[§]#equal_contrib_text
              ]
              #if authornote != none [#authornote]
            ],
          ),
        )
      }

      // Add ORCID if available
      if a.keys().contains("orcid") {
        author_elements.push(link(a.orcid, fa-orcid(fill: rgb("a6ce39"), size: 0.8em)))
      }

      // Add author string to the list
      author_strings.push(box(author_elements.join()))
    }
  }

  if authors != none {
    titleblock(
      weight: "regular",
      size: 1.25em,
      [#author_strings.join(", ", last: " & ")],
    )
  }

  if affiliations != none {
    titleblock(
      weight: "regular",
      size: 1.1em,
      below: 2em,
      for a in affiliations [
        #if authors.len() > 1 [#super[#a.id]]#a.name#if a.keys().contains("department") [, #a.department] \
      ],
    )
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
      [#v(0.4em)#text(style: "italic")[Keywords:] #categories]
    }
    #if wordcount != none {
      [\ #text(style: "italic")[Words:] #wordcount]
    }
  ]

  // Table of contents
  if toc {
    block(inset: (top: 2em, bottom: 0em, left: 2.4em, right: 2.4em))[
      #outline(
        title: toc-title,
        depth: toc-depth,
        indent: toc-indent,
      )
    ]
  }

  /* Document content */

  // Separate content a bit from front matter
  v(2em)

  // Show document content with cols if specified
  if cols == 1 {
    doc
  } else {
    columns(
      cols,
      gutter: col-gutter,
      doc,
    )
  }
}

// Remove gridlines from tables
#set table(
  inset: 6pt,
  stroke: none,
)
