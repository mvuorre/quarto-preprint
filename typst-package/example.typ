#import "lib.typ": preprint, appendix

#show: preprint.with(
  theme: "jou",
  title: [Test Document],
  subtitle: [Standalone Typst Package Test],
  authors: (
    (
      name: [Test Author],
      affiliation: [1],
      orcid: "https://orcid.org/0000-0000-0000-0000",
      email: [test\@example.com],
      corresponding: true
    ),
  ),
  affiliations: (
    (id: "1", name: "Test University", department: "Test Department"),
  ),
  abstract: [This is a test of the standalone Typst preprint package.],
  categories: [test, typst, package],
  wordcount: true,
  toc: true,
)

= Introduction

This is a test document to verify the standalone Typst package works correctly.

== Subsection

Some content here.

= Main Content

More content with @fig-test.

#figure(
  rect(width: 80%, height: 60pt, fill: gray),
  caption: [A test figure.]
) <fig-test>

#show: appendix.with()

= Appendix A

Appendix content here.