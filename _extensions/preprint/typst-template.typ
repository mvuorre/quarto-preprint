#let preprint(
  title: none,
  running-head: none,
  authors: none,
  affiliations: none,
  abstract: none,
  keywords: none,
  authornote: none,
  citation: none,
  date: none,
  branding: none,
  leading: 0.6em,
  spacing: 1em,
  first-line-indent: 0cm,
  linkcolor: rgb(0, 0, 0),
  margin: (x: 3.2cm, y: 3cm),
  paper: "a4",
  lang: "en",
  region: "US",
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
  col-gutter: 4.2%,
  doc,
) = {

  /* Document settings */

  // Set link and cite colors
  show link: set text(fill: linkcolor)
  show cite: set text(fill: linkcolor)

  // Allow custom title for bibliography section
  set bibliography(title: bibliography-title, style: bibliography-style)

  // Format author strings here, so can use in author note
  let author_strings = ()
  if authors != none {
    for a in authors {
      let author_string = [
        // Solo manuscripts don't have institutional id
        #a.name#if authors.len() > 1 [#super[#a.affiliation]]#if a.keys().contains("email") {[\*]}
        #if a.keys().contains("orcid") {
            box(
              height: 1em,
              link(
                a.orcid, 
                figure(
                  image("orcid.svg", height: 0.9em)
                )
              )
            )
          }
        ]
      if a.keys().contains("email") {
        authornote = [\*Send correspondence to: #a.name, #a.email.\ #authornote]
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
        // Page 1 header can include citation and branding
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
          // Page >1 header has running head and page number
          grid(
            columns: (1fr, 1fr),
            align(left)[#running-head],
            align(right)[#counter(page).display()]
          )
        }
    ),
    footer-descent: 24pt,
    footer: locate(
        // Page 1 footer has author note
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
  // Set space between paragraphs
  show par: set block(spacing: spacing)

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

  let titleblock(
    body, 
    width: 100%, 
    size: 1.5em, 
    weight: "bold", 
    above: 1em, 
    below: 0em
  ) = [
    #align(center)[
      #block(width: width, above: above, below: below)[
        #text(weight: weight, size: size)[#body]
      ]
    ]
  ]

  if title != none {
    titleblock(title)
  }

  if authors != none {
    titleblock(
      weight: "regular", size: 1.25em,
      [#author_strings.join(", ", last: " & ")]
    )
  }

  if affiliations != none {
    titleblock(
      weight: "regular", size: 1.1em, below: 2em,
      for a in affiliations [
        #if authors.len() > 1 [#super[#a.id]]#a.name#if a.keys().contains("department") [, #a.department] \
      ]
    )
  }
  
  // Abstract and keywords block
  block(inset: (top: 2em, bottom: 0em, left: 2.4em, right: 2.4em))[
    #set text(size: 0.92em)
    #if abstract != none {
      abstract
    }
    #if keywords != none {
      [#v(0.4em)#text(style: "italic")[Keywords:] #keywords]
    }
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
      )
    ]
  }

  /* Content */

  // Separate content a bit from front matter
  v(2em)
  
  // Show document content with cols if specified
  if cols == 1 {
    doc
  } else {
    columns(
      cols, 
      gutter: col-gutter, 
      doc
    )
  }

}

// Remove gridlines from tables
#set table(
  inset: 6pt,
  stroke: none
)
