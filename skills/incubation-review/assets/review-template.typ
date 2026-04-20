// OpenRail Incubation Review — Typst template
// Used via: pandoc report.md --pdf-engine=typst --template=this-file.typ -o report.pdf

// ── Colour palette ──────────────────────────────────────────────────────────
#let navy = rgb("#0D2137")
#let midnavy = rgb("#1A3A5C")
#let accent = rgb("#2E6DA4")
#let accentlt = rgb("#EEF4FB")
#let passbg = rgb("#EAF4EE")
#let passgreen = rgb("#1A6B35")
#let warncolor = rgb("#8B6914")
#let warnbg = rgb("#FDF6E3")
#let rulegray = rgb("#CCCCCC")
#let bodygray = rgb("#444444")
#let dimgray = rgb("#888888")

#let conf(
  title: none,
  subtitle: none,
  date: none,
  abstract: none,
  lang: "en",
  region: "US",
  margin: (x: 2cm, y: 2cm),
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
        set text(8pt, fill: dimgray, weight: "light")
        title
        h(1fr)
        [OpenRail Incubation Review]
        v(-4pt)
        line(length: 100%, stroke: 0.4pt + rulegray)
      }
    },
    footer: context {
      if counter(page).get().first() > 1 {
        set text(8pt, fill: dimgray, weight: "light")
        h(1fr)
        counter(page).display("1 / 1", both: true)
      }
    },
  )

  // ── Typography ──────────────────────────────────────────────────────────
  set text(font: "Helvetica Neue", size: 10pt, fill: bodygray, lang: lang, region: region)
  show raw: set text(font: "Menlo", size: 8pt)
  set par(leading: 0.6em, justify: true)

  // ── Headings ────────────────────────────────────────────────────────────
  let chapter-count = counter("chapters")
  show heading.where(level: 2): it => {
    chapter-count.step()
    context {
      if chapter-count.get().first() > 1 {
        pagebreak(weak: true)
      }
    }
    set text(15pt, weight: "bold", fill: midnavy)
    v(4pt)
    it
    v(2pt)
    line(length: 100%, stroke: 0.4pt + rulegray)
    v(4pt)
  }
  show heading.where(level: 3): it => {
    set text(12pt, weight: "bold", fill: midnavy)
    v(10pt)
    it
    v(3pt)
  }
  show heading.where(level: 4): it => {
    set text(10.5pt, weight: "bold", fill: navy)
    v(6pt)
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
    stroke: none,
    align: left,
    fill: (_, y) => if y == 0 { accentlt } else if calc.even(y) { rgb("#F6F8FC") } else { none },
  )
  show table.cell: set text(size: 9.5pt)
  show table.cell.where(y: 0): set text(weight: "bold", size: 9pt, fill: midnavy)
  show table: it => {
    set align(center)
    v(12pt)
    {
      set align(left)
      it
    }
    v(12pt)
  }

  // ── Code blocks ─────────────────────────────────────────────────────────
  show raw.where(block: true): it => {
    set text(size: 7.5pt)
    block(
      fill: rgb("#F6F8FC"),
      inset: 8pt,
      radius: 3pt,
      width: 100%,
      stroke: 0.5pt + rulegray,
      it,
    )
  }

  // ── Lists ───────────────────────────────────────────────────────────────
  set list(indent: 1em, body-indent: 0.4em)
  set enum(indent: 1em, body-indent: 0.4em)

  // ── Page breaks before appendices: handled via raw typst blocks in markdown ──

  // ── Highlight "Overall assessment" section ──────────────────────────────
  // (handled via pandoc div or manually in the body)

  // ── Title page ──────────────────────────────────────────────────────────
  if title != none {
    v(2cm)
    line(length: 100%, stroke: 1.5pt + accent)
    v(8pt)
    text(10pt, fill: dimgray, weight: "light", tracking: 0.15em)[OPENRAIL INCUBATION REVIEW]
    v(6pt)
    text(28pt, weight: "bold", fill: navy)[#title]
    v(6pt)
    if subtitle != none {
      text(11pt, fill: bodygray)[#subtitle]
      v(6pt)
    }
    if date != none {
      text(11pt, fill: dimgray, weight: "light")[Report date: #date]
    }
    v(8pt)
    line(length: 100%, stroke: 1.5pt + accent)
    v(0.8cm)

    // Table of contents
    text(12pt, weight: "bold", fill: midnavy)[Contents]
    v(4pt)
    line(length: 100%, stroke: 0.4pt + rulegray)
    v(4pt)
    {
      set text(size: 9.5pt, fill: bodygray)
      outline(title: none, indent: 1.2em, depth: 2)
    }

    v(0.5cm)
    line(length: 100%, stroke: 0.4pt + rulegray)
    v(0.5cm)
  }

  doc
}

// ── Pandoc template glue ──────────────────────────────────────────────────

#let horizontalrule = {
  v(6pt)
  line(start: (25%, 0%), end: (75%, 0%), stroke: 0.4pt + rgb("#CCCCCC"))
  v(6pt)
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
$if(subtitle)$
  subtitle: [$subtitle$],
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
