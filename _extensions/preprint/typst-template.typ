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
      let x = [
        #a.name#super[#a.affiliation]
        #if a.keys().contains("orcid") {
            box(
              inset: -fontsize*0.2,
              link(
                a.orcid, 
                figure(
                  image("_extensions/preprint/orcid.svg", width: fontsize)
                )
              )
            )
          }
        ]
      author_strings.push(x)
      // Hack to add corresponding author since no such key exists in any author.
      if a.keys().contains("email") {
        authornote = [Send correspondence to #a.name (#a.email). #authornote]
      }
    }
  }

  show link: set text(fill: linkcolor)
  show cite: set text(fill: linkcolor)

  set page(
    paper: paper, 
    margin: margin,
    numbering: "1",
    header-ascent: 30pt,
    header: locate(
        loc => if [#loc.page()] == [1] {
          set align(right)
          set text(size: fontsize*0.85)
          date; linebreak()
          [#link("https://doi.org/" + citation.doi, "https://doi.org/" + citation.doi)]
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
          [#text(size: fontsize*0.9)[#authornote]]
        } else {
          []
        }
    )
  )
  set par(justify: true, linebreaks: "optimized")
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: section-numbering)

  if title != none {
    align(center)[
      #text(weight: 400, size: fontsize + 0.5*fontsize)[#title]
    ]
  }

  align(center)[
      #text(size: fontsize + 0.2*fontsize)[
        #author_strings.join(", ", last: " & ")
      ]
    ]

  if affiliations != none {
    align(center)[
      #block(below: 12pt)[
        #for a in affiliations [
          #super[#a.id]#a.name#if a.keys().contains("department") {[, #a.department]} \
        ]
      ]
    ]
  }

  if abstract != none {
    block(below: -3em, inset: 2.5em)[
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
      title: text(weight: "semibold", size: fontsize*1.15)[Contents],
      depth: 2,
      indent: fontsize
    );
    ]
  }

  show heading.where(
    level: 1
  ): it => block(width: 100%, below: fontsize*1.5, above: fontsize*2)[
    #set align(center)
    #set text(size: fontsize*1.15)
    #it
  ]

  show heading.where(
    level: 2
  ): it => block(width: 100%, below: fontsize*1.25, above: fontsize*1.5)[
    #set text(size: fontsize)
    #it
  ]

  show heading.where(
    level: 3
  ): it => block(width: 100%, below: fontsize, above: fontsize*1.25)[
    #set text(size: fontsize)
    #it
  ]

  set bibliography(title: bibliography-title)

  doc
}
