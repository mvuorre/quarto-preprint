// Quarto callout overrides for academic boxes.
//
// Leave Quarto's callout() function intact for normal callouts. Cross-referenced
// note callouts are converted to boxes in the figure show rule below, where the
// semantic kind/supplement is available.

#show ref: it => {
  if it.supplement == [Note] {
    ref(it.target, supplement: [Box])
  } else {
    it
  }
}

// Use Quarto's callout cross-reference machinery, but label note callouts as
// boxes and let callout supplement labels win when authors use wrn/tip/etc.
#show figure: it => {
  if type(it.kind) != str {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  let label = if type(it.supplement) == str {
    it.supplement
  } else if it.supplement != none {
    content-to-string(it.supplement)
  } else {
    kind
  }
  label = if label == "Note" { "Box" } else { label }
  let is-box = label == "Box"

  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let children = old_title_block.body.body.children
  let old_title = if children.len() == 1 {
    children.at(0)
  } else {
    children.at(1)
  }

  let callout_num = it.counter.display(it.numbering)
  let new_title = if empty(old_title) {
    [#label #callout_num]
  } else {
    [#label #callout_num: #old_title]
  }
  let new_title_content = if children.len() == 1 {
    new_title
  } else {
    children.at(0) + new_title
  }

  let new_title_block = block_with_new_content(
    old_title_block,
    block_with_new_content(old_title_block.body, new_title_content),
  )

  if is-box {
    let box-title-block = block(
      fill: luma(238),
      width: 100%,
      inset: 8pt,
      new_title_content,
    )
    let box-body = block(inset: 1pt, width: 100%, below: 0pt, box-title-block)
    if old_callout.body.children.len() > 1 {
      box-body += old_callout.body.children.at(1)
    }
    align(left, block(
      breakable: false,
      fill: luma(248),
      stroke: (paint: luma(170), thickness: 0.5pt, cap: "round"),
      width: 100%,
      radius: 0pt,
      box-body,
    ))
  } else {
    align(left, block_with_new_content(
      old_callout,
      block(below: 0pt, new_title_block) + old_callout.body.children.at(1),
    ))
  }
}
