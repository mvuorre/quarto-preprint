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
  sectionnumbering: none,
  toc: false,
  doc,
) = {
  set page(
    paper: paper, 
    margin: margin,
    numbering: "1",
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
    footer-descent: 0pt,
    footer: locate(
        loc => if [#loc.page()] == [1] {
          authornote
        } else {
          []
        }
    )
  )
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)

  if title != none {
    align(center)[
      #block(inset: 2em)[
        #text(weight: 400, size: fontsize + 0.5*fontsize)[#title]
      ]
    ]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(
        author =>
        align(center)[
          #text(
            size: fontsize + 0.2*fontsize
          )[#author.name#super[#author.affiliation]]
          #if author.keys().contains("orcid") {
            box(
              width: fontsize, 
              link(
                author.orcid, 
                figure(image("_extensions/preprint/orcid.svg", width: fontsize))
              )
            )
          }
        ]
      )
    )
  }

  if affiliations != none {
    align(center)[
      #block(below: 12pt)[
        #for a in affiliations [
          #super[#a.id]#a.name, #a.department \
        ]
      ]
    ]
  }

  if abstract != none {
    block(above: 1em, below: -3em, inset: 2em)[
      #text(weight: "semibold")[Abstract] #h(1em) #abstract
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
    #it.body
  ]
  
  show heading.where(
    level: 2
  ): it => block(width: 100%, below: fontsize*1.25, above: fontsize*1.5)[
    #set text(size: fontsize)
    #it.body
  ]

  show heading.where(
    level: 3
  ): it => block(width: 100%, below: fontsize, above: fontsize*1.25)[
    #set text(size: fontsize)
    #it.body
  ]

  doc
}
