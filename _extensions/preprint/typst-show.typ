#show: doc => preprint(
// Default Quarto template variables
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(running-head)$
  running-head: [$running-head$],
$endif$
$if(by-author)$
  authors: (
  $for(by-author)$
      (
        name: [$it.name.literal$],
        affiliation: [$for(it.affiliations)$$it.id$$sep$,$endfor$],
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
$if(lang)$
  lang: "$lang$",
$endif$
$if(region)$
  region: "$region$",
$endif$
$if(abstract)$
  abstract: [$abstract$],
$endif$
$if(papersize)$
  paper: "$papersize$",
$endif$
$if(mainfont)$
  font: ("$mainfont$",),
$elseif(brand.typography.base.family)$
  font: $brand.typography.base.family$,
$endif$
$if(monofont)$
  monofont: "$monofont$",
$endif$
$if(number-sections)$
  sectionnumbering: "1.1.1.1.",
$endif$
$if(section-numbering)$
  sectionnumbering: "$section-numbering$",
$endif$
  pagenumbering: $if(page-numbering)$"$page-numbering$"$else$none$endif$,
  linenumbering: $if(line-number)$"1"$else$none$endif$,
$if(toc)$
  toc: $toc$,
$endif$
$if(toc-title)$
  toc_title: [$toc-title$],
$endif$
$if(toc-indent)$
  toc_indent: $toc-indent$,
$endif$
$if(toc-depth)$
  toc_depth: $toc-depth$,
$endif$
// Additional Typst variables
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
$if(fontcolor)$
  fontcolor: $fontcolor$,
$endif$
$if(backgroundcolor)$
  backgroundcolor: $backgroundcolor$,
$endif$
$if(monobackgroundcolor)$
  monobackgroundcolor: $monobackgroundcolor$,
$endif$
$if(headingcolor)$
  headingcolor: $headingcolor$,
$endif$
$if(strongcolor)$
  strongcolor: $strongcolor$,
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
$if(corresponding-text)$
  corresponding-text: [$corresponding-text$],
$endif$
// Use categories or keywords
$if(categories)$
  categories: [$for(categories)$$it$$sep$, $endfor$],
$elseif(keywords)$
  categories: [$for(keywords)$$it$$sep$, $endfor$],
$endif$
$if(wordcount)$
  wordcount: $wordcount$,
$endif$
$if(col-gutter)$
  col-gutter: $col-gutter$,
$endif$
$if(bibliographystyle)$
  bibliographystyle: "$bibliographystyle$",
$endif$
$if(bibliography-title)$
  bibliography-title: [$bibliography-title$],
$endif$
// Theme system (unified for standalone and Quarto)
$if(theme)$
  theme: "$theme$",
$elseif(theme-jou)$
  theme: "jou",
$endif$
// Explicit overrides (optional)
$if(margin)$
  margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
$endif$
$if(fontsize)$
  fontsize: $fontsize$,
$elseif(brand.typography.base.size)$
  fontsize: $brand.typography.base.size$,
$endif$
$if(columns)$
  cols: $columns$,
$endif$
  doc,
)
