#import "@preview/fletcher:0.3.0"
#import "@preview/funarray:0.3.0": *
#import "@preview/sourcerer:0.2.1": code
#import "lib/index.typ": *

#show: conf

#title-slide(title: "How FP Deals With Effects")[

  #line(length: 65%, stroke: 2pt + color_medium)

  #poolc_badge #h(.3em) 양제성

  #v(.5em)
  #set text(size: fontsize_small)
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
      size: fontsize_extrasmall, 
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

#absolute-center-slide(title: "Overall Structure", header: "함수형 프로그래밍 Intro")[
  FP is all about _composing pure functions_.#pin(1)

  #let fp = ```
  f(g(h(..)))
  ```
  #let pp = ```c
  int main(void) {
    f(); g(); h(); ..
  }
  ```
  #v(.5em)
  #table(
    columns: (1fr, auto, 1fr),
    align: center + horizon,
    row-gutter: 1em,
    stroke: none,
    pp, [VS], fp,
    text(size: fontsize_small)[\[Procedural Promramming\]], 
    [],
    text(size: fontsize_small)[\[Functional Programming\]]
  )

  #only(2)[#pinit-point-to(
    pin-dx: 0pt,
    pin-dy: -25pt,
    body-dx: 10pt,
    body-dy: -10pt,
    offset-dx: 45pt,
    offset-dy: -55pt,
    1,
    thickness: 2pt
  )[How?]]
]

#absolute-center-slide(title: "Overall Structure", header: "함수형 프로그래밍 Intro")[
  _Sum all._ [`stdin <- "5\n1 2 3 4 5"`]

  #set text(size: fontsize_small)
  #let haskell = code(lang: "Haskell (declarative)", ```hs
  main =
    interact
      (show . sum . 
        map read . drop 1 . words)
  ```)
  #let python = code(lang: "Python3 (declarative)", ```py

  from sys import stdin
  
  print(sum(map(
    int, stdin.read().split()[1:]
  )))
  ```)
  #let fp = table(stroke: none, haskell, python)
  #let cpp = code(lang: "C++ (imperative)", ```cpp
  int main() {
    int n, result;
    std::cin >> n;
    for (size_t i = 0; i < n; ++i) {
      int a;
      std::cin >> a;
      result += a;
    }
    std::cout << result << '\n';
    return 0;
  }
  ```)
  #table(
    columns: (1fr, 1fr),
    align: center + horizon,
    column-gutter: 1em,
    row-gutter: 1em,
    stroke: none,
    cpp, fp,
    text(size: fontsize_small)[\[Procedural Promramming\]], 
    text(size: fontsize_small)[\[Functional Programming\]]
  )
]

#absolute-center-slide(title: "Overall Structure", header: "함수형 프로그래밍 Intro")[
  #set enum(number-align: start + top)
  #let contents = (
    ("Purity", 
    "Side Effect", "Referential Transparency", "Significance of ..."),
    ("Immutability", 
    "Recursion (feat. Tail Call Optimization)", "C vs Haskell in file IO"),
    ("First Class Function",
    "Currying", "Linked List"),
  )
  #grid(
    columns: (1fr, 1fr),
    tbc(contents),
    text(font: "MesloLGS NF", size: 55pt)[_\<Let's\ code!\>_]
  )
]

#top-left-slide(title: "Historical Review (CS + Math)", header: "함수형 프로그래밍 Intro")[
  #set enum(number-align: top + start, indent: 1em)
  == Lambda Calculus

  + Very Basics
  + Boolean in Action

  == Category Theory

  + Very Basics
  + Functor in Action
]

#absolute-top-center-slide(title: "Lambda Calculus", header: "함수형 프로그래밍 Intro")[
  #set enum(number-align: top + start)

  #let _left = block(fill: color_light, outset: .5em, radius: .5em)[
    #align(center)[*Function Encoding*]
    + Variables (Immutable)
    + Functions (Curried)
    + Application
  ]
  #let _right = text(font: "MesloLGS NF")[Turing Machine]
  
  #block(width: 750pt)[
    #table(
    columns: (1fr, 0em, 1fr),
    stroke: none,
    align(left)[#_left], align(horizon)[<=>], align(horizon)[#_right]
    )
  ]

  #v(.5em)
  #only("2-7")[
    #set text(size: 60pt)
    $ #pin(1)lambda#pin(2)#pin(3)x#pin(4)". "#pin(5)f x#pin(6) $

    #set text(size: fontsize_medium)
    #only("3-")[#pinit-line(
      stroke: 2pt,
      start-dx: -5pt,
      end-dx: 5pt,
      start-dy: 25pt,
      end-dy: 25pt,
      1, 6
    )
    #pinit-place(dx: -1.3em, dy: 1.5em, 1)[
      Lambda Abstraction \
      #v(-.5em)
      #only("4-")[#align(center)[_`JS ver. (x) => f(x)`_]]
    ]]
    #only("5-")[
      #pinit-highlight(extended-height: 1.8em, fill: rgb(255, 0, 0, 50), 1, 2)
      #pinit-point-to(
        pin-dx: -15pt,
        offset-dx: -55pt,
        body-dx: -205pt,
        pin-dy: 0pt,
        offset-dy: 0pt,
        body-dy: -10pt,
        1
      )[Function Signifier]
    ]
    #only("6-")[
      #pinit-highlight(extended-height: 1.8em, fill: rgb(0, 255, 0, 50), 3, 4)
      #pinit-point-to(
        pin-dx: -16pt,
        offset-dx: -16pt,
        body-dx: -96pt,
        pin-dy: -30pt,
        offset-dy: -60pt,
        body-dy: -25pt,
        4
      )[Parameter Variable]
    ]
    #only("7-")[
      #pinit-highlight(extended-height: 1.8em, fill: rgb(0, 0, 255, 50), 5, 6)
      #pinit-point-to(
        pin-dx: 10pt,
        offset-dx: 50pt,
        body-dx: 15pt,
        pin-dy: 0pt,
        offset-dy: 0pt,
        body-dy: -10pt,
        6
      )[Return #underline("Expression")]
    ]
  ]
  
  #only(8)[
    #let e = "expression"
    #let v = "variable"
    $ #e ::&= #v && italic("    identifier") \
      &| #e #e && italic("    application") \
      &| lambda " " v_1 v_2 dots.h.c " " . #e && italic("    abstraction") \
      &| "( " #e" )" && italic("    grouping") $
  ]

  #only(9)[
    #set text(size: 35pt, font: "MesloLGS NF")
    #v(1.5em)
    #text(baseline: -5pt)[ex) Church Encoding: Boolean]
    #box(image(width: 1.1em, height: auto, alt: "JS logo", "./assets/js.svg"))
  ]
]
