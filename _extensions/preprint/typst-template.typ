#let preprint(
  title: none,
  running-head: none,
  authors: none,
  affiliations: none,
  authornote: none,
  abstract: none,
  keywords: none,
  date: none,
  citation: none,
  branding: none,
  leading: 0.6em,
  spacing: 1em,
  linkcolor: rgb(0, 0, 0),
  margin: (x: 3.5cm, y: 3cm),
  paper: "a4",
  lang: "en",
  region: "US",
  font: ("Times", "Times New Roman"),
  fontsize: 12pt,
  section-numbering: none,
  toc: false,
  bibliography-title: "References",
  doc,
) = {

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
                  image("_extensions/preprint/orcid.svg", width: 0.92em)
                )
              )
            )
          }
        ]
      // Hack to add corresponding author since no such key exists in any author.
      if a.keys().contains("email") {
        authornote = [\*Corresponding author: #a.name, #a.email. #authornote]
      }
      author_strings.push(author_string)
    }
  }

  show link: set text(fill: linkcolor)
  show cite: set text(fill: linkcolor)
  // Space between paragraphs
  show par: set block(spacing: spacing)

  set page(
    paper: paper, 
    margin: margin,
    numbering: "1",
    header-ascent: 30pt,
    header: locate(
        loc => if [#loc.page()] == [1] {
          set align(right)
          set text(size: 0.85em)
          box(
            inset: 0.2em,
            [#date; #linebreak()
            #link("https://doi.org/" + citation.doi, "https://doi.org/" + citation.doi)]
          )
          box(
            if branding == "psyarxiv" {
              image("_extensions/preprint/psyarxiv.svg", width: 2.25em)
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
    footer-descent: 8pt,
    footer: locate(
        loc => if [#loc.page()] == [1] {
          [#text(size: 0.9em)[#authornote]]
        } else {
          []
        }
    )
  )
  set par(
    justify: true,
    leading: leading
  )
  set text(
    lang: lang,
    region: region,
    font: font,
    size: fontsize
  )
  set heading(
    numbering: section-numbering
  )

  if title != none {
    align(center)[
      #v(4em)
      #block(below: 2em)[
        #text(weight: 400, size: 1.5em)[#title]
      ]
    ]
  }

  align(center)[
    #block(below: 2em)[
      #text(size: 1.2em)[
        #author_strings.join(", ", last: " & ")
      ]
    ]
  ]

  if affiliations != none {
    align(center)[
      #block(below: 1em)[
        #for a in affiliations [
          #super[#a.id]#a.name#if a.keys().contains("department") [, #a.department] \
        ]
      ]
    ]
  }

  if abstract != none {
    block(above: 1em, below: -3em, inset: 2.5em)[
      #abstract
    ]
  }

  if keywords != none {
    block(above: -4em, below: -1em, inset: 2.5em)[
      #text(style: "italic")[Keywords:] #keywords
    ]
  }

  if toc {
    block(above: -2em, below: 0em, inset: 2em)[
    #outline( 
      title: text(weight: "semibold", size: 1.15em)[Contents],
      depth: 2,
      indent: 1em
    );
    ]
  }

  show heading.where(
    level: 1
  ): it => block(width: 100%, below: 1.25em, above: 1.5em)[
    #set align(center)
    #set text(size: 1em)
    #it
  ]

  show heading.where(
    level: 2
  ): it => block(width: 100%, below: 1.2em, above: 1.4em)[
    #set text(size: 1em)
    #it
  ]

  show heading.where(
    level: 3
  ): it => block(width: 100%, below: 1em, above: 1.25em)[
    #set text(size: 1em)
    #it
  ]

  set bibliography(title: bibliography-title)

  doc
}
