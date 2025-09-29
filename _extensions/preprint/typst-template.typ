// Quarto Typst template

#import "_extensions/preprint/typst/preprint.typ": appendix, preprint

// Remove gridlines from basic (e.g. `knitr::kable()`) tables
#set table(
  inset: 6pt,
  stroke: none,
)
