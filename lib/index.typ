#import "style.typ": *
#import "@preview/pinit:0.1.3": *
#import "@preview/polylux:0.3.1": *

#let footer_descent_ratio = .9
#let footer_descent_amount = 1em * footer_descent_ratio

#let conf(doc) = {
  show heading.where(level: 1): set text(weight: "semibold")
  show heading.where(level: 2): set text(weight: "medium")
  show emph: it => text(fill: color_dark)[*#it.body*]
  set page(
    paper: "presentation-16-9", 
    margin: (x: margin_x, y: margin_y), 
    header-ascent: -.5em,
    footer: [
      #set align(center)
      #set text(size: fontsize_copyright)
      #copyright()
    ],
    footer-descent: footer_descent_amount
  )
  set text(size: fontsize_medium, font: (default_font), lang: "ko", weight: "light")
  doc
}

#let vtext(txt) = stack(
    dir: ttb,
    ..txt.clusters().map(c => rotate(90deg)[#c])
)

#let vhcenter_content(content) = align(center + horizon)[#content]
#let vcenter_content(content) = align(center)[#content]

#let tbc(title: none, items) = {
  if title != none [== #title \ ]
  for (top, ..rest) in items [
    + #align(start)[#top]
      #set list(marker: [-])
      #set text(size: fontsize_extrasmall)
      #for bottom in rest { align(start)[- #bottom] }

  ]
}

#let lined_title(title: none, line_color: color_medium) = [
  = #title
  #v(-.1em)
  #line(length: 65%, stroke: 2pt + line_color)
]

#let title-slide(title: none, content) = polylux-slide[
  #vhcenter_content[
    #if title != none [= #title]
    #content
  ]
]

#let slide(title: none, header: none, content) = {
  set page(header: [
    #set align(end)
    #set text(size: fontsize_extrasmall, weight: "regular", fill: rgb(0, 0, 0, 50%))
    #header
  ]) if header != none
  polylux-slide[
    #if title != none { lined_title(title: title) }
    #content
  ]
}

#let relative-center-slide(title: none, header: none, content) = {
  let footer_size = fontsize_copyright * (1 + footer_descent_ratio)
  slide(title: title, header: header)[
    #v(-footer_size)
    #vhcenter_content[#content]
  ]
}

#let absolute-center-slide(title: none, header: none, content) = {
  slide(title: title, header: header)[
    #locate(loc => {
      // maybe inefficient, but who cares?
      let current_heading = query(heading.where(level: 1), loc).find(h => {
        loc.page() == h.location().page()
      })
      v(-current_heading.location().position().y)
    })
    #vhcenter_content[#content]
  ]
}

#let absolute-top-center-slide(title: none, header: none, content) = {
  slide(title: title, header: header)[
    #vcenter_content[#content]
  ]
}

#let top-left-slide(title: none, header: none, content) = {
  slide(title: title, header: header)[
    #move(dx: 1em, dy: .5em, content)
  ]
}