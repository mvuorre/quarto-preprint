// Quarto Typst template
// Now imports from standalone package

#import "_extensions/preprint/lib/preprint.typ": preprint, appendix

// Remove gridlines from tables
#set table(
  inset: 6pt,
  stroke: none,
)