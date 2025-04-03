#show: doc => preprint(
$if(title)$
  title: [$title$],
$endif$
$if(running-head)$
  running-head: [$running-head$],
$endif$
$if(by-author)$
  authors: (
  $for(by-author)$
      (
        name: [$it.name.literal$],
        affiliation: [$for(it.affiliations)$$it.id$$sep$, $endfor$],
        $if(it.attributes.corresponding)$corresponding: $it.attributes.corresponding$,$endif$
        $if(it.attributes.equal-contributor)$equal-contributor: $it.attributes.equal-contributor$,$endif$
        $if(it.orcid)$orcid: "https://orcid.org/$it.orcid$",$endif$
        $if(it.email)$email: [$it.email$]$endif$
      ),
  $endfor$
  ),
$endif$
$if(affiliations)$
  affiliations: (
    $for(affiliations)$(
      id: "$it.id$",
      name: "$it.name$",
      $if(it.department)$department: "$it.department$"$endif$
    ),
    $endfor$
  ),
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(branding)$
  branding: "$branding$",
$endif$
$if(leading)$
  leading: $leading$,
$endif$
$if(spacing)$
  spacing: $spacing$,
$endif$
$if(first-line-indent)$
  first-line-indent: $first-line-indent$,
$endif$
$if(all)$
  all: $all$,
$endif$
$if(linkcolor)$
  linkcolor: $linkcolor$,
$endif$
$if(citation)$
  citation: (
    type: "$citation.type$",
    container-title: "$citation.container-title$",
    doi: "$citation.doi$",
    url: "$citation.url$"
  ),
$endif$
$if(authornote)$
  authornote: [$authornote$],
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
$if(region)$
  region: "$region$",
$endif$
$if(abstract)$
  abstract: [$abstract$],
$endif$
$if(categories)$
  categories: [$for(categories)$$it$$sep$, $endfor$],
$endif$
$if(wordcount)$
  wordcount: [$wordcount$],
$endif$
$if(margin)$
  margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
$endif$
$if(papersize)$
  paper: "$papersize$",
$endif$
$if(mainfont)$
  font: ("$mainfont$",),
$endif$
$if(fontsize)$
  fontsize: $fontsize$,
$endif$
$if(section-numbering)$
  section-numbering: "$section-numbering$",
$endif$
$if(toc)$
  toc: $toc$,
$endif$
$if(toc-depth)$
  toc-depth: $toc-depth$,
$endif$
$if(toc-title)$
  toc-title: "$toc-title$",
$endif$
$if(toc-indent)$
  toc-indent: "$toc-indent$",
$endif$
$if(cols)$
  cols: $cols$,
$endif$
$if(col-gutter)$
  col-gutter: $col-gutter$,
$endif$
$if(bibliography-style)$
  bibliography-style: [$bibliography-style$],
$endif$
$if(bibliography-title)$
  bibliography-title: [$bibliography-title$],
$endif$
  doc,
)
