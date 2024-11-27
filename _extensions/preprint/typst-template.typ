#let preprint(
  title: none,
  running-head: none,
  authors: (),
  affiliations: none,
  abstract: none,
  keywords: none,
  wordcount: none,
  authornote: none,
  citation: none,
  date: none,
  branding: none,
  leading: 0.6em,
  spacing: 1em,
  first-line-indent: 0cm,
  linkcolor: black,
  margin: (x: 3.2cm, y: 3cm),
  paper: "a4",
  lang: "en",
  region: "US",
  font: ("Times", "Times New Roman", "Arial"),
  fontsize: 11pt,
  section-numbering: none,
  toc: false,
  toc-title: "contents",
  toc-depth: none,
  toc-indent: 1.5em,
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

  let orcidSvg = ```<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 24 24"> <path fill="#AECD54" d="M21.8,12c0,5.4-4.4,9.8-9.8,9.8S2.2,17.4,2.2,12S6.6,2.2,12,2.2S21.8,6.6,21.8,12z M8.2,5.8c-0.4,0-0.8,0.3-0.8,0.8s0.3,0.8,0.8,0.8S9,7,9,6.6S8.7,5.8,8.2,5.8z M10.5,15.4h1.2v-6c0,0-0.5,0,1.8,0s3.3,1.4,3.3,3s-1.5,3-3.3,3s-1.9,0-1.9,0H10.5v1.1H9V8.3H7.7v8.2h2.9c0,0-0.3,0,3,0s4.5-2.2,4.5-4.1s-1.2-4.1-4.3-4.1s-3.2,0-3.2,0L10.5,15.4z"/></svg>```.text

  // Allow custom title for bibliography section
  set bibliography(title: bibliography-title, style: bibliography-style)

  // Bibliography paragraph spacing
  show bibliography: set par(spacing: spacing, leading: leading) if sys.version >= version(0, 12, 0)
  show bibliography: set block(spacing: leading) if sys.version < version(0, 12, 0)

  // Format author strings here, so can use in author note
  let author_strings = ()
  if authors != none {
    for a in authors {
      let author_string = box[#{
        // Solo manuscripts don't have institutional id
        a.name
        if authors.len() > 1 {super(a.affiliation)}
        if a.keys().contains("email") {[\*]}
        if a.keys().contains("orcid") {
            box(
              height: 1em,
              link(
                a.orcid,
                figure(
                  image.decode(orcidSvg, height: 0.9em)
                )
              )
            )
          }
        }
        ]

      if a.keys().contains("corresponding") {
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
        loc => if [#loc.page()] != [1] {
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
  if sys.version >= version(0,12,0) {
    set par(spacing: spacing)
  } else {
    show par: set block(spacing: spacing)
  }

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
  show heading.where(
    level: 1
  ): it => block(width: 100%, below: 1em, above: 1.25em)[
    #set align(center)
    #set text(size: fontsize*1.1, weight: "bold")
    #it
  ]
  show heading.where(
    level: 2
  ): it => block(width: 100%, below: 1em, above: 1.25em)[
    #set text(size: fontsize*1.05)
    #it
  ]
  show heading.where(
    level: 3
  ): it => block(width: 100%, below: 0.8em, above: 1.2em)[
    #set text(size: fontsize, style: "italic")
    #it
  ]
  // Level 4 & 5 headers are in paragraph
  show heading.where(
    level: 4
  ): it => box(
    inset: (top: 0em, bottom: 0em, left: 0em, right: 1em),
    text(size: 1em, weight: "bold", it)
  )
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
        #text(weight: weight, size: size, hyphenate: false)[#body]
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
    #if wordcount != none {
      [\ #text(style: "italic")[Words:] #wordcount]
    }
  ]

  // Table of contents
  if toc {
    let title = if toc-title == none {
      auto
    } else {
      toc-title
    }
    block(inset: (top: 2em, bottom: 0em, left: 2.4em, right: 2.4em))[
      #outline(
        title: toc-title,
        depth: toc-depth,
        indent: toc-indent
      )
    ]
  }

  // Center figure, left-align caption.
  show figure: set block(inset: (top: 0.4em, bottom: 0.2em))
    show figure: it => {
      align(center, it.body)
      align(left, it.caption)
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
  stroke: none,
)
