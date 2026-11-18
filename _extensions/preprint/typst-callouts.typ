// Note callouts as understated grayscale "Boxes".
//
// The "Box" label comes from language strings in _extension.yml
// (callout-note-title, crossref-nte-prefix, crossref-note-prefix), so
// Quarto's own callout and cross-reference code produces "Box 1: Title" and
// "Box 1" in references. Here we only change the colours.
//
// Quarto's callout() (definitions.typ) receives colours but not the callout
// type, so note callouts are recognised by Quarto's note colour, or by the
// brand primary colour that replaces it when a brand is used. If Quarto
// changes its note colour, notes fall back to Quarto's own style.
//
// We wrap Quarto's callout() rather than copy it: Quarto's callout figure show
// rule takes its output apart and relies on its structure. This file is
// included before the body (not in the header) because brand-color is only
// defined after the header includes. Written against Quarto 1.11.

#let quarto-callout = callout
#let note-icon-colors = (rgb("#0758E5"), brand-color.at("primary", default: none))

#let callout(..args) = {
  if args.named().at("icon_color", default: none) in note-icon-colors {
    // The border and icon share icon_color
    quarto-callout(..args, background_color: luma(238), icon_color: luma(150))
  } else {
    quarto-callout(..args)
  }
}
