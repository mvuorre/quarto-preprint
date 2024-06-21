#let preprint(
  title: none,
  running-head: none,
  authors: none,
  affiliations: none,
  abstract: none,
  keywords: none,
  authornote: none, // Appears in 1st page footer
  citation: none, // citation.doi appears in 1st page header
  date: none, // Appears in 1st page header
  branding: none, // Appears in 1st page header
  leading: 0.6em, // https://typst.app/docs/reference/model/par/#parameters-leading
  spacing: 1em, // Between paragraphs https://typst.app/docs/reference/layout/block/#parameters-spacing
  first-line-indent: 0cm, // https://typst.app/docs/reference/model/par/#parameters-first-line-indent
  linkcolor: rgb(0, 0, 0), // https://typst.app/docs/reference/visualize/color/
  margin: (x: 3.2cm, y: 3cm), // https://typst.app/docs/reference/layout/page/#parameters-margin
  paper: "a4", // https://typst.app/docs/reference/layout/page/#parameters-paper
  lang: "en", // https://typst.app/docs/reference/text/text/#parameters-lang
  region: "US", // https://typst.app/docs/reference/text/text/#parameters-region
  font: ("Times", "Times New Roman", "Arial"),
  fontsize: 11pt,
  section-numbering: none,
  toc: false,
  toc_title: "contents",
  toc_depth: none,
  toc_indent: 1.5em,
  bibliography-title: "References",
  bibliography-style: "apa",
  cols: 1,
  doc,
) = {

  /* Document settings */

  // Set link and cite colors
  show link: set text(fill: linkcolor)
  show cite: set text(fill: linkcolor)
  
  // Set space between paragraphs
  show par: set block(spacing: spacing)

  // Allow custom title for bibliography section
  set bibliography(title: bibliography-title, style: bibliography-style)

  // Format author strings here, so can use in author note
  let author_strings = ()
  if authors != none {
    for a in authors {
      let author_string = [
        #a.name#super[#a.affiliation]#if a.keys().contains("email") {[\*]}
        #if a.keys().contains("orcid") {
            box(
              inset: -0.2em,
              link(
                a.orcid, 
                figure(
                  image("orcid.svg", width: 0.92em)
                )
              )
            )
          }
        ]
      if a.keys().contains("email") {
        authornote = [\*Corresponding author: #a.name, #a.email.\ #authornote]
      }
      author_strings.push(author_string)
    }
  }

  // Page settings (including headers & footers)
  set page(
    paper: paper, 
    margin: margin,
    numbering: "1",
    header-ascent: 50%,
    header: locate(
        loc => if [#loc.page()] == [1] {
          set align(right)
          set text(size: 0.85em)
          box(
            inset: 0.2em,
            [
              #date
              #if citation != none {linebreak(); link("https://doi.org/" + citation.doi, "https://doi.org/" + citation.doi)}
            ]
          )
          box(
            inset: 0.2em,
            if branding == "psyarxiv" {
              image("psyarxiv.svg", width: 2.25em)
            }
          )
        } else {
          grid(
            columns: (1fr, 1fr),
            align(left)[#running-head],
            align(right)[#counter(page).display()]
          )
        }
    ),
    footer-descent: 24pt,
    footer: locate(
        loc => if [#loc.page()] == [1] {
          [#text(size: 0.85em)[#authornote]]
        } else {
          []
        }
    )
  )
  
  // Paragraph settings
  set par(
    justify: true, 
    leading: leading,
    first-line-indent: first-line-indent
  )

  // Text settings
  set text(
    lang: lang,
    region: region,
    font: font,
    size: fontsize
  )

  // Headers
  set heading(
    numbering: section-numbering
  )
  // Level 1 headers
  show heading.where(
    level: 1
  ): it => block(width: 100%, below: 1em, above: 1.25em)[
    #set align(center)
    #set text(size: fontsize*1.1, weight: "bold")
    #it
  ]
  // Level 2 headers
  show heading.where(
    level: 2
  ): it => block(width: 100%, below: 1em, above: 1.25em)[
    #set text(size: fontsize*1.05)
    #it
  ]
  // Level 3 headers
  show heading.where(
    level: 3
  ): it => block(width: 100%, below: 0.8em, above: 1.2em)[
    #set text(size: fontsize, style: "italic")
    #it
  ]
  // Level 4 headers are in paragraph
  show heading.where(
    level: 4
  ): it => box(
    inset: (top: 0em, bottom: 0em, left: 0em, right: 1em), 
    text(size: 1em, weight: "bold", it)
  )
  // Level 5 headers are in paragraph
  show heading.where(
    level: 5
  ): it => box(
    inset: (top: 0em, bottom: 0em, left: 0em, right: 1em), 
    text(size: 1em, weight: "bold", style: "italic", it)
  )

  /* Content front matter */

  // Title, authors, and affiliations block
  set align(center)
  block(inset: (top: 2em, bottom: 0em, left: 2em, right: 2em))[
    #if title != none {
      v(2em)
      [#text(weight: 400, size: 1.5em)[#title]]
    }
    #if authors != none {
      v(0.4em)
      text(size: 1.2em)[#author_strings.join(", ", last: " & ")]
    }
    #if affiliations != none {
      v(0.3em)
      for a in affiliations [
        #super[#a.id]#a.name#if a.keys().contains("department") [, #a.department] \
      ]
    }
  ]
  set align(left)
  
  // Abstract and keywords block
  block(inset: (top: 2em, bottom: 0em, left: 2.4em, right: 2.4em))[
    #set text(size: 0.89em)
    #if abstract != none {
      abstract
    }
    #if keywords != none {[#v(0.4em)#text(style: "italic")[Keywords:] #keywords]}
  ]

  // Table of contents
  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(inset: (top: 2em, bottom: 0em, left: 2.4em, right: 2.4em))[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  /* Content */
  v(2em)
  
  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }

}

#set table(
  inset: 6pt,
  stroke: none
)
