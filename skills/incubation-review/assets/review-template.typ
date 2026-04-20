// OpenRail Incubation Review — Typst template
// Ported from the WWCND report design language (XeLaTeX)
// Used via: pandoc report.md --pdf-engine=typst --template=this-file.typ -o report.pdf

// ── Colour palette ──────────────────────────────────────────────────────────
#let navy = rgb("#0D2137")
#let midnavy = rgb("#1A3A5C")
#let accent = rgb("#2E6DA4")
#let accentlt = rgb("#EEF4FB")
#let passgreen = rgb("#1A6B35")
#let passbg = rgb("#EAF4EE")
#let failred = rgb("#AA2222")
#let failbg = rgb("#FAEEEE")
#let warncolor = rgb("#8B6914")
#let warnbg = rgb("#FDF6E3")
#let rulegray = rgb("#CCCCCC")
#let bodygray = rgb("#444444")
#let dimgray = rgb("#888888")
#let rowalt = rgb("#F6F8FC")

#let conf(
  title: none,
  date: none,
  abstract: none,
  lang: "en",
  region: "US",
  margin: (x: 2.8cm, y: 2.4cm),
  papersize: "a4",
  cols: 1,
  doc,
) = {
  set document(title: title)
  set page(
    paper: papersize,
    margin: margin,
    header: context {
      if counter(page).get().first() > 1 {
        set text(8pt, fill: dimgray, font: "Helvetica Neue", weight: "light")
        title
        h(1fr)
        [OpenRail Incubation Review]
        v(-4pt)
        line(length: 100%, stroke: 0.4pt + rulegray)
      }
    },
    footer: context {
      set text(8pt, fill: dimgray, font: "Helvetica Neue", weight: "light")
      h(1fr)
      counter(page).display("1 / 1", both: true)
    },
  )

  // ── Typography ──────────────────────────────────────────────────────────
  set text(font: "Helvetica Neue", size: 10.5pt, fill: bodygray, lang: lang, region: region)
  show raw: set text(font: "Menlo", size: 8.5pt)
  set par(leading: 0.65em, justify: true)

  // ── Headings ────────────────────────────────────────────────────────────
  show heading.where(level: 1): it => {
    set text(16pt, weight: "bold", fill: midnavy, font: "Georgia")
    v(12pt)
    it
    v(2pt)
    line(length: 100%, stroke: 0.4pt + rulegray)
    v(6pt)
  }
  show heading.where(level: 2): it => {
    set text(13pt, weight: "bold", fill: midnavy, font: "Georgia")
    v(10pt)
    it
    v(4pt)
  }
  show heading.where(level: 3): it => {
    set text(11pt, weight: "bold", fill: navy)
    v(8pt)
    it
    v(2pt)
  }

  // ── Links ───────────────────────────────────────────────────────────────
  show link: it => {
    set text(fill: accent)
    underline(it)
  }

  // ── Tables ──────────────────────────────────────────────────────────────
  set table(
    inset: (x: 8pt, y: 5pt),
    stroke: (x: none, y: 0.5pt + rulegray),
  )
  show table.cell.where(y: 0): set text(weight: "bold", size: 9.5pt, fill: midnavy)

  // ── Code blocks ─────────────────────────────────────────────────────────
  show raw.where(block: true): it => {
    set text(size: 8pt)
    block(
      fill: rgb("#F6F8FC"),
      inset: 10pt,
      radius: 3pt,
      width: 100%,
      stroke: 0.5pt + rulegray,
      it,
    )
  }

  // ── Lists ───────────────────────────────────────────────────────────────
  set list(indent: 1.2em, body-indent: 0.5em)
  set enum(indent: 1.2em, body-indent: 0.5em)

  // ── Title block ─────────────────────────────────────────────────────────
  if title != none {
    v(1cm)
    text(24pt, weight: "bold", fill: navy, font: "Georgia")[#title]
    v(4pt)
    if date != none {
      text(11pt, fill: dimgray, weight: "light")[#date]
    }
    v(8pt)
    line(length: 100%, stroke: 1pt + accent)
    v(12pt)
  }

  doc
}

// ── Pandoc template glue ──────────────────────────────────────────────────

#let horizontalrule = {
  v(8pt)
  line(start: (25%, 0%), end: (75%, 0%), stroke: 0.4pt + rgb("#CCCCCC"))
  v(8pt)
}

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
