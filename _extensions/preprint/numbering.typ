// Numbering for figures, equations, callouts, and subfloats, with appendix
// support: after `#show: appendix`, numbers carry the appendix letter (A1, B2).
//
// Overrides Quarto's numbering.typ partial (Quarto 1.11), which is meant to be
// overridden "by extensions for appendix support". It must be this partial:
// Quarto's subfloat code (definitions.typ) captures subfloat-numbering when it
// is defined, so later redefinitions would not reach it.

// True from the point where appendix() is applied onwards
#let preprint-appendix = state("preprint-appendix", false)

// The number at `loc`, prefixed with the appendix letter in appendices.
// Without an appendix heading yet, there is no letter to prefix.
#let appendix-number(loc, pattern, ..nums) = {
  let appendix = counter(heading).at(loc).at(0, default: 0)
  let letter = if preprint-appendix.at(loc) and appendix > 0 { numbering("A", appendix) } else { "" }
  letter + numbering(pattern, ..nums)
}

// Numbering functions run at the numbered element, also when a reference
// elsewhere displays the number, so here() is the element's location.
#let figure-numbering(..nums) = appendix-number(here(), "1", ..nums)
#let equation-numbering(..nums) = "(" + figure-numbering(..nums) + ")"
#let callout-numbering = figure-numbering
#let subfloat-numbering(n-super, subfloat-idx) = appendix-number(here(), "1a", n-super, subfloat-idx)

// Quarto's theorem defaults, unchanged
#let theorem-inherited-levels = 0
#let theorem-numbering(loc) = "1.1"
#let theorem-render(prefix: none, title: "", full-title: auto, body) = {
  if full-title != "" and full-title != auto and full-title != none {
    strong[#full-title.]
    h(0.5em)
  }
  body
}
