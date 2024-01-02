#import "@preview/octique:0.1.0": octique-inline
#import "@preview/polylux:0.3.1": *
#import "@preview/nth:1.0.0": *
#import "poolc.typ"

#let default_font = "Pretendard"
#let font_big = 30pt
#let font_medium = 25pt
#let font_small = 20pt
#let font_extrasmall = 16pt

#let haskell_color = rgb("#5e5086")

#let github_hypericon = link("https://github.com/J3m3/poolc-fp")[
  #octique-inline("mark-github")
]

#let conf(doc) = {
  show heading.where(level: 1): it => [
    #set text(weight: "semibold")
    #it.body
  ]
  show heading.where(level: 2): it => [
    #set text(weight: "medium")
    #it.body
  ]
  set page(paper: "presentation-16-9", margin: (x: 1.1cm, y: 1.1cm))
  set text(size: font_medium, font: (default_font), lang: "ko", weight: "light")
  doc
}

#let vtext(txt) = stack(
    dir: ttb,
    ..txt.clusters().map(c => rotate(90deg)[#text[#c]])
)

#let center_content(content) = align(center + horizon)[#content]

#let tbc(title: none, items) = [
  #if title != none [== #title \ ]
  #for (top, ..rest) in items [
    + #align(start)[#top]
      #set list(marker: [-])
      #set text(size: font_extrasmall)
      #for bottom in rest { align(start)[- #bottom] }

  ]
]

#let slide-title(title: none, line_color: poolc.color_medium) = [
  = #title
  #v(-.5em)
  #line(length: 65%, stroke: 2pt + line_color)
]

#let center-slide(content) = polylux-slide[
  #center_content[#content]
]

#let slide(title: none, content) = polylux-slide[
  #if title != none { slide-title(title: title) }
  #content
]
