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
$if(lang)$
  lang: "$lang$",
$endif$
$if(region)$
  region: "$region$",
$endif$
$if(abstract)$
  abstract: [$abstract$],
$endif$
$if(margin)$
  margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
$endif$
$if(papersize)$
  paper: "$papersize$",
$endif$
$if(mainfont)$
  font: ("$mainfont$",),
$elseif(brand.typography.base.family)$
  font: $brand.typography.base.family$,
$endif$
$if(fontsize)$
  fontsize: $fontsize$,
$elseif(brand.typography.base.size)$
  fontsize: $brand.typography.base.size$,
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
// Use categories or keywords
$if(categories)$
  categories: [$for(categories)$$it$$sep$, $endfor$],
$elseif(keywords)$
  categories: [$for(keywords)$$it$$sep$, $endfor$],
$endif$
$if(wordcount)$
  wordcount: [$wordcount$],
$endif$
$if(col-gutter)$
  col-gutter: $col-gutter$,
$endif$
$if(bibliographystyle)$
  bibliographystyle: [$bibliographystyle$],
$endif$
$if(bibliography-title)$
  bibliography-title: [$bibliography-title$],
$endif$
  cols: $if(columns)$$columns$$else$1$endif$,
  doc,
)
