#import "@preview/funarray:0.3.0": *
#import "@preview/pinit:0.1.3": *
#import "lib/index.typ": *

#show: conf

#center-slide(title: "How FP Deals With Effects")[

  #line(length: 65%, stroke: 2pt + color_medium)

  #poolc_badge #h(.3em) 양제성

  #v(.5em)
  #set text(size: font_small)
  #let date = date.display(
    "[year]/[month]/[day] ([weekday repr:short])"
  )

  Source: #github_hypericon #h(1em) #date
]

#slide(title: "목차")[
  #set enum(number-align: start)
  #let left = tbc(title: "1st Session", (
    (
      "함수형 프로그래밍 Intro", 
      "Overall Structure", "Historical Review (CS + Math)"
    ),
    (
      "SW 엔지니어링의 목표", 
      "SW Maintainability", "FP vs OOP vs PP"
    ),
    (
      "FP는 정말 순수한가?",
      "Purity of Functions", "File I/O Scenario"
    )
  ))
  #let right = {
    set text(fill: rgb(0, 0, 0, 50%))
    tbc(title: "2nd Session", (
      (
        "함수 합성을 위한 도구들", 
        "Partial Application", "Kleisli Composition"
      ),
      (
        "...중 하나인 모나드",
        "Functor to Monad", "IO Monad"
      ),
      (
        "부수 효과의 관리",
        "Action / Calculation / Data", "Preventing Action Propagation"
      )
    ))
  }
  #let centre = [
    #set align(horizon)
    #set text(
      size: font_extrasmall, 
      weight: "semibold", 
      font: "MesloLGS NF", 
      style: "oblique", 
      fill: haskell_color
    )
    #vtext("Basic Haskell Knowledge")
  ]

  #v(.6em)
  #align(center)[#grid(
    columns: (1fr, 1em, 1fr),
    left,
    centre,
    right
  )]
]

#slide(title: "Overall Structure", header: "함수형 프로그래밍 Intro")[
  #center_content[
    
  ]
]
