// OpenRail Incubation Review — Typst template
// Used via: pandoc report.md --pdf-engine=typst --template=this-file.typ -o report.pdf

#let conf(
  title: none,
  date: none,
  abstract: none,
  lang: "en",
  region: "US",
  margin: (x: 2.5cm, y: 2.5cm),
  papersize: "a4",
  cols: 1,
  doc,
) = {
  set document(title: title)
  set page(
    paper: papersize,
    margin: margin,
    header: context {
      if counter(page).get().first() > 1 [
        #set text(8pt, fill: luma(120))
        #title
        #h(1fr)
        OpenRail Incubation Review
      ]
    },
    footer: context {
      set text(8pt, fill: luma(120))
      h(1fr)
      counter(page).display("1 / 1", both: true)
    },
  )

  set text(font: "Helvetica Neue", size: 10pt, lang: lang, region: region)
  show raw: set text(font: "Menlo", size: 8.5pt)

  set heading(numbering: none)
  show heading.where(level: 1): it => {
    set text(16pt, weight: "bold")
    v(0.3em)
    it
    v(0.2em)
  }
  show heading.where(level: 2): it => {
    set text(13pt, weight: "bold")
    v(0.3em)
    it
    v(0.1em)
  }
  show heading.where(level: 3): it => {
    set text(11pt, weight: "bold")
    v(0.2em)
    it
    v(0.1em)
  }

  show link: it => {
    set text(fill: rgb("#1a5fb4"))
    underline(it)
  }

  set table(
    inset: 6pt,
    stroke: 0.5pt + luma(180),
  )
  show table.cell.where(y: 0): set text(weight: "bold", size: 9pt)

  show raw.where(block: true): it => {
    set text(size: 8pt)
    block(
      fill: luma(245),
      inset: 8pt,
      radius: 3pt,
      width: 100%,
      it,
    )
  }

  set par(leading: 0.65em, justify: true)

  // Title block
  if title != none {
    align(left)[
      #text(20pt, weight: "bold")[#title]
      #if date != none {
        v(-0.3em)
        text(10pt, fill: luma(100))[#date]
      }
    ]
    v(0.5em)
    line(length: 100%, stroke: 0.5pt + luma(180))
    v(0.5em)
  }

  doc
}

// Pandoc template glue below

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

#show figure.where(
  kind: table
): set figure.caption(position: top)

#show figure.where(
  kind: image
): set figure.caption(position: bottom)

$if(smart)$
$else$
#set smartquote(enabled: false)

$endif$
$for(header-includes)$
$header-includes$

$endfor$
#show: doc => conf(
$if(title)$
  title: [$title$],
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
  papersize: "$papersize$",
$endif$
$if(columns)$
  cols: $columns$,
$endif$
  doc,
)

$for(include-before)$
$include-before$

$endfor$
$body$

$for(include-after)$
$include-after$

$endfor$
