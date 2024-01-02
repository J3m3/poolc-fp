#import "style.typ": *
#import "@preview/polylux:0.3.1": *

#let conf(doc) = {
  show heading.where(level: 1): it => {
    set text(weight: "semibold")
    it.body
  }
  show heading.where(level: 2): it => {
    set text(weight: "medium")
    it.body
  }
  set page(
    paper: "presentation-16-9", 
    margin: (x: margin_x, y: margin_y), 
    header-ascent: -.5em,
    footer: [
      #set align(center)
      #set text(size: font_copyright)
      #copyright()
    ],
    footer-descent: .9em
  )
  set text(size: font_medium, font: (default_font), lang: "ko", weight: "light")
  doc
}

#let vtext(txt) = stack(
    dir: ttb,
    ..txt.clusters().map(c => rotate(90deg)[#c])
)

#let center_content(content) = align(center + horizon)[#content]

#let tbc(title: none, items) = {
  if title != none [== #title \ ]
  for (top, ..rest) in items [
    + #align(start)[#top]
      #set list(marker: [-])
      #set text(size: font_extrasmall)
      #for bottom in rest { align(start)[- #bottom] }

  ]
}

#let lined_title(title: none, line_color: color_medium) = [
  = #title
  #v(-.5em)
  #line(length: 65%, stroke: 2pt + line_color)
]

#let center-slide(title: none, content) = polylux-slide[
  #center_content[
    #if title != none [= #title]
    #content
  ]
]

#let slide(title: none, header: none, content) = {
  set page(header: [
    #set align(end)
    #set text(size: font_extrasmall, weight: "regular", fill: rgb(0, 0, 0, 50%))
    #header
  ]) if header != none
  polylux-slide[
    #if title != none { lined_title(title: title) }
    #content
  ]
}
