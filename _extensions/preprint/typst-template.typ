#let preprint(
  title: none,
  running-head: none,
  authors: none,
  affiliations: none,
  authornote: none,
  abstract: none,
  keywords: none,
  margin: (x: 3.5cm, y: 3cm),
  paper: "a4",
  lang: "en",
  region: "US",
  font: ("Times", "Times New Roman"),
  fontsize: 12pt,
  section-numbering: none,
  toc: false,
  doc,
) = {
  set page(
    paper: paper, 
    margin: margin,
    numbering: "1",
    header-ascent: 48pt,
    header: locate(
        loc => if [#loc.page()] == [1] {
          []
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
          stack(
            spacing: 6pt,
            line(length: 100%,  stroke: 0.5pt),
            authornote
          )
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

  if authors != none {
    let author_strings = ()
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
    }
    align(center)[
      #text(size: fontsize + 0.2*fontsize)[
        #author_strings.join(", ", last: " & ")
      ]
    ]
  }

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
    block(above: 1em, below: -3em, inset: 2em)[
      #abstract
    ]
  }

  if keywords != none {
    block(above: -3em, below: -1em, inset: 2em)[
      #text(weight: "semibold")[Keywords] #h(1em) #keywords
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

  doc
}
