#let color_light = rgb("#e0f0ed")
#let color_medium = rgb("#a7dad5")
#let color_dark = rgb("#47be9b")

#let badge = link("https://poolc.org/")[
  #box(outset: .2em, fill: color_light, radius: .2em)[
    #set text(weight: "regular", font: "D2Coding")
    #box(image("../assets/poolc.icon.transparent.png", height: .75em))
    #h(-.2em)
    PoolC
  ]
]
