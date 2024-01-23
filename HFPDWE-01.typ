#import "@preview/fletcher:0.3.0" as fletcher: node, edge
#import "@preview/pinit:0.1.3": *
#import "@preview/sourcerer:0.2.1": code
#import "@preview/xarrow:0.3.0": xarrow
#import "lib/index.typ": *

#show: conf

// 1
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

// 2
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

// 3 ~ 4
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

// 5
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

// 6 ~ 7
#absolute-center-slide(title: "Overall Structure", header: "함수형 프로그래밍 Intro")[
  #set enum(number-align: start + top)
  #let contents = (
    ("Purity", 
    "Side Effect", "Referential Transparency", "Significance of ..."),
    ("Immutability", 
    "Recursion (feat. Tail Call Optimization)", "C vs Haskell in File IO"),
    ("First Class Function",
    "Currying", "Linked List"),
  )
  #grid(
    columns: (1fr, 1fr),
    tbc(contents),
    only(2)[#text(font: "MesloLGS NF", size: 55pt)[_\<Let's\ code!\>_]]
  )
]

// 8
#top-left-slide(title: "Historical Review (CS + Math)", header: "함수형 프로그래밍 Intro")[
  #set enum(number-align: top + start, indent: 1em)
  == Lambda Calculus

  + Very Basics
  + Boolean in Action

  == Category Theory

  + Very Basics
  + Functor in Action
]

// 9 ~ 16
#relative-top-center-slide(title: "Lambda Calculus", header: "함수형 프로그래밍 Intro")[
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

  #let lambda_ex_length = 6
  #only((beginning: 2, until: lambda_ex_length))[
    #set text(size: 60pt)
    $ #pin(1)lambda#pin(2)#pin(3)x#pin(4)". "#pin(5)f x#pin(6) $
  ]

  #only((beginning: 3, until: lambda_ex_length))[
    #pinit-line(
      stroke: 2pt,
      start-dx: -5pt,
      end-dx: 5pt,
      start-dy: 25pt,
      end-dy: 25pt,
      1, 6
    )
    #pinit-place(dx: -7.2em, dy: 1.5em, 1)[
      #align(center)[Lambda Abstraction \
      #v(-.5em)
      #set box(radius: .1em, outset: .1em)
      `Py ver. `#alternatives-match((
        "3": box[`lambda`],
        "4-": box(fill: rgb(255, 0, 0, 50))[`lambda`]
      ))
      #alternatives-match((
        "3-4": box[`x`],
        "5-": box(fill: rgb(0, 255, 0, 50))[`x`]
      ))`:`
      #alternatives-match((
        "3-5": box[`f(x)`],
        "6-": box(fill: rgb(0, 0, 255, 50))[`f(x)`]
      ))
      ` | `
      `JS ver. (`#alternatives-match((
        "3-4": box[`x`],
        "5-": box(fill: rgb(0, 255, 0, 50))[`x`]
      ))`)`
      #alternatives-match((
        "3": box[`=>`],
        "4-": box(fill: rgb(255, 0, 0, 50))[`=>`]
      ))
      #alternatives-match((
        "3-5": box[`f(x)`],
        "6-": box(fill: rgb(0, 0, 255, 50))[`f(x)`]
      ))]
    ]
  ]

  #only((beginning: 4, until: lambda_ex_length))[
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

  #only((beginning: 5, until: lambda_ex_length))[
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

  #only((beginning: 6, until: lambda_ex_length))[
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

  #only(7)[
    #let e = "expression"
    #let v = "variable"
    $ #e ::&= #v && italic("    identifier") \
      &| #e #e && italic("    application") \
      &| lambda " " v_1 v_2 dots.h.c " " . #e && italic("    abstraction") \
      &| "( " #e" )" && italic("    grouping") $
  ]

  #only(8)[
    #set text(size: 35pt, font: "MesloLGS NF")
    #v(1.5em)
    #text(baseline: -5pt)[ex) Church Encoding: Boolean]
    #box(image(width: 1.1em, height: auto, alt: "JS logo", "./assets/js.svg"))
  ]
]

// 17 ~ 18
#absolute-center-slide(title: "Category Theory", header: "함수형 프로그래밍 Intro")[
  #uncover(2)[#text(size: fontsize_big)[_Abstraction!_]]

  "Mathematics is the art of giving \
  the _same name_ to _different things_"
  
  #text(style: "italic", font: "Linux Libertine")[Henri Poincaré]

]

// 19 ~ 20
#absolute-center-slide(title: "Category Theory", header: "함수형 프로그래밍 Intro")[
  #table(
    columns: (1.35fr, 2em, 1fr),
    align: center,
    gutter: 1.2em,
    stroke: none,
    uncover(2)[*Abstraction of *_composition_], uncover(2)[->], uncover(2)[*Category Theory*],
    [Abstraction of numbers], [->], [Elementry Algebra],
    [Abstraction of relationships], [->], [Graph Theory],
    [Abstraction of vectors and\ their linear relationships], [->], [Linear Algebra]
  )
]

// 21 ~ 22
#absolute-center-slide(title: "Category Theory", header: "함수형 프로그래밍 Intro")[
  A _category_ is a collection of...

  #alternatives-cases((1, 2), case => [
    #let _left = [
      #table(
        columns: 1,
        inset: (x: 1em, y: .6em), 
        align: center + horizon,
        [*Components*],
        [Objects],
        block[Morphisms (a.k.a. Arrows)],
        block[Composition of morphisms],
      )
    ]
    #let _right = if case == 0 {
      set text(size: fontsize_small)
      move(dx: 3em, dy: .45em)[#block(stroke: 1pt, outset: .1em, radius: .5em)[
        #place(
          top + left,
          dx: .2em,
          dy: .2em,
          $italic(bold("Category"))$
        )
        #fletcher.diagram({
          let (a, b, c) = ((0, 1), (2, 1), (2, 0))
          node(a, $O_1$)
          node(b, $O_2$)
          node(c, $O_3$)
          edge(a, b, text(size: fontsize_small)[$m_1$], "->")
          edge(b, c, text(size: fontsize_small)[$m_2$], "->", label-side: left)
          edge(a, c, text(size: fontsize_small)[$m_2 compose m_1$], "->", label-side: right)
          edge((-0.2, 1), (0, 0.8), "->", bend: -130deg, label-sep: -1.5pt, label: text(size: fontsize_small)[$id_O_1$])
          edge((2, 1.2), (2.2, 1), "->", bend: +130deg, label-sep: -1.5pt, label: text(size: fontsize_small)[$id_O_2$])
          edge(c, c, "->", bend: +130deg, label: text(size: fontsize_small)[$id_O_3$])
        })
      ]]
     } else { 
      table(
        columns: 1,
        inset: (x: 1em, y: .6em),
        align: center + horizon,
        [*For example...*],
        [ $QQ," "PP = RR - QQ," "i RR = CC - RR$ ],
        [ $f: QQ -> PP," "g: PP -> i RR$ ],
        [ $g compose f: QQ -> i RR$ ]
      )
    }

    #grid(
      columns: 2,
      _left, _right
    )
  ])
]

// 23 ~ 24
#absolute-center-slide(title: "Category Theory", header: "함수형 프로그래밍 Intro")[
  #h(1.2em)
  #let _left = block(stroke: 1pt, outset: .1em, radius: .5em)[
    #place(
      top + left,
      dy: -1.2em,
      $bold(C)$
    )
    #fletcher.diagram({
      let (q, p, iR) = ((0, 1), (2, 1), (2, 0))
      node(q, $QQ$)
      node(p, $PP$)
      node(iR, $i RR$)
      edge(q, p, text(size: fontsize_small)[$f(x) = x + pi$], "->")
      edge(p, iR, text(size: fontsize_small)[$g(x) = x i$], "->", label-side: left)
      edge(q, iR, text(size: fontsize_small)[$g compose f$], "->", label-side: right)
      edge((-0.2, 1), (0, 0.8), "->", bend: -130deg, label-sep: -1.5pt, label: text(size: fontsize_small)[$id_QQ$])
      edge((2, 1.2), (2.2, 1), "->", bend: +130deg, label-sep: -1.5pt, label: text(size: fontsize_small)[$id_PP$])
      edge(iR, iR, "->", bend: +130deg, label: text(size: fontsize_small)[$attach(id, br: #text[$i RR$])$])
    })
  ]
  #let _right = block(stroke: 1pt, outset: .1em, radius: .5em, width: 200pt)[
    #place(
      top + left,
      dy: -1.2em,
      [$bold(D = F(C))$]
    )
    #fletcher.diagram({
      let (a, b) = ((0, 1), (0, 0))
      node(a, $A$)
      node(b, $B$)
      edge(a, b, text(size: fontsize_small)[$h$], "->", label-side: left)
      edge(a, a, "->", bend: -130deg, label: text(size: fontsize_small)[$id_A$])
      edge(b, b, "->", bend: +130deg, label: text(size: fontsize_small)[$id_B$])
    })
  ]

  #grid(
    columns: 3,
    column-gutter: .5em,
    _left, 
    uncover(2)[#xarrow(width: 5em)[#text(size: fontsize_medium)[$bold(F)"unctor"$]]],
    uncover(2)[#_right]
  )
]

// 25
#absolute-center-slide(title: "Category Theory", header: "함수형 프로그래밍 Intro")[
  #h(1.2em)
  #let _left = block(stroke: 1pt, outset: .1em, radius: .5em)[
    #place(
      top + left,
      dy: -1.2em,
      $bold(C)$
    )
    #fletcher.diagram({
      let (q, p, iR) = ((0, 1), (2, 1), (2, 0))
      node(q, $QQ$)
      node(p, $PP$)
      node(iR, $i RR$)
      edge(q, p, text(size: fontsize_small)[$f(x) = x + pi$], "->")
      edge(p, iR, text(size: fontsize_small)[$g(x) = x i$], "->", label-side: left)
      edge(q, iR, text(size: fontsize_small)[$g compose f$], "->", label-side: right)
      edge((-0.2, 1), (0, 0.8), "->", bend: -130deg, label-sep: -1.5pt, label: text(size: fontsize_small)[$id_QQ$])
      edge((2, 1.2), (2.2, 1), "->", bend: +130deg, label-sep: -1.5pt, label: text(size: fontsize_small)[$id_PP$])
      edge(iR, iR, "->", bend: +130deg, label: text(size: fontsize_small)[$attach(id, br: #text[$i RR$])$])
    })
  ]
  #let _right = block(stroke: 1pt, outset: .1em, radius: .5em)[
    #place(
      top + left,
      dy: -1.2em,
      $bold(F(C))$
    )
    #set text(size: fontsize_small)
    #fletcher.diagram({
      let (q, p, iR) = ((0, 1), (2, 1), (2, 0))
      node(q, $F(QQ)$)
      node(p, $F(PP)$)
      node(iR, $F(i RR)$)
      edge(q, p, text(size: fontsize_small)[$F(f)$], "->")
      edge(p, iR, text(size: fontsize_small)[$F(g)$], "->", label-side: left)
      edge(q, iR, text(size: fontsize_small)[$F(g compose f)$], "->", label-side: right)
      edge(q, q, "->", bend: -125deg, label: text(size: fontsize_small)[$F(id_QQ)$])
      edge(p, p, "->", bend: -125deg, label: text(size: fontsize_small)[$F(id_PP)$])
      edge(iR, iR, "->", bend: +125deg, label: text(size: fontsize_small)[$attach(id, br: #text[$i RR$])$])
    })
  ]

  #grid(
    columns: 3,
    column-gutter: .5em,
    _left, 
    xarrow(width: 5em)[#text(size: fontsize_medium)[$bold(F)"unctor"$]],
    _right
  )
]

// 26 ~ 27
#absolute-center-slide(title: "Category Theory", header: "함수형 프로그래밍 Intro")[
  #show "F": name => box[
    #set text(fill: color_dark)
    #name
  ]
  #show "fmap": name => box[
    #set text(fill: color_dark)
    f
  ]
  #show math.equation: set text(font: "MesloLGS NF")
  #set text(font: "MesloLGS NF")
  #h(1.2em)
  #let _left = block(stroke: 1pt, outset: .1em, radius: .5em)[
    #place(
      top + left,
      dy: -1.2em,
      "Type"
    )
    #place(
      bottom + center,
      dy: .9em,
      text(size: fontsize_extrasmall, font: "Pretendard")[... let's ignore undefined situations]
    )
    #fletcher.diagram({
      let (Int, Ints, Bool) = ((0, 1), (2, 1), (2, 0))
      node(Int, "Int")
      node(Ints, "Int[]")
      node(Bool, "Bool")
      edge(Int, Ints, text(size: fontsize_small)[length], "<-")
      edge(Int, (1.7, 0.1), text(size: fontsize_small)[odd], "->", bend: +10deg, label-side: left)
      edge(Int, Bool, text(size: fontsize_small)[even], "->", bend: -10deg, label-side: right)
      edge(Int, Int, "->", bend: -130deg, label: text(size: fontsize_small)[sqrt])
      edge(Ints, Ints, "->", bend: -125deg, label: text(size: fontsize_small)[tail])
      edge(Bool, Bool, "->", bend: +130deg, label: text(size: fontsize_small)[not])
    })
  ]
  #let _right = block(stroke: 1pt, outset: .1em, radius: .5em)[
    #place(
      top + left,
      dy: -1.2em,
      "F(Type)"
    )
    #set text(size: fontsize_small)
    #fletcher.diagram({
      let (Int, Ints, Bool) = ((0, 1), (2, 1), (2, 0))
      node(Int, "F(Int)")
      node(Ints, "F(Int[])")
      node(Bool, "F(Bool)")
      edge(Int, Ints, text(size: fontsize_extrasmall)[fmap(length)], "<-")
      edge(Int, (1.58, 0.1), text(size: fontsize_extrasmall)[fmap(odd)], "->", bend: +10deg, label-side: left)
      edge(Int, Bool, text(size: fontsize_extrasmall)[fmap(even)], "->", bend: -10deg, label-side: right)
      edge(Int, Int, "->", bend: -130deg, label: text(size: fontsize_extrasmall)[fmap(sqrt)])
      edge(Ints, Ints, "->", bend: -125deg, label: text(size: fontsize_extrasmall)[fmap(tail)])
      edge(Bool, Bool, "->", bend: +130deg, label: text(size: fontsize_extrasmall)[fmap(not)])
    })
  ]

  #grid(
    columns: 3,
    column-gutter: .5em,
    _left, 
    uncover(2)[#xarrow(width: 5em)[#text(size: fontsize_medium)[$"Functor"$]]],
    uncover(2)[#_right]
  )
]

// 28
#absolute-center-slide(title: "Category Theory", header: "함수형 프로그래밍 Intro")[
  #show "[']": name => box[
    #set text(fill: color_dark)
    []
  ]
  #show "F": name => box[
    #set text(fill: color_dark)
    fmap
  ]
  #show math.equation: set text(font: "MesloLGS NF")
  #set text(font: "MesloLGS NF")
  #h(1.2em)
  #let _left = block(stroke: 1pt, outset: .1em, radius: .5em)[
    #place(
      top + left,
      dy: -1.2em,
      "Type"
    )
    #place(
      bottom + center,
      dy: .9em,
      text(size: fontsize_extrasmall, font: "Pretendard")[... let's ignore undefined situations]
    )
    #fletcher.diagram({
      let (Int, Ints, Bool) = ((0, 1), (2, 1), (2, 0))
      node(Int, "Int")
      node(Ints, "Int[]")
      node(Bool, "Bool")
      edge(Int, Ints, text(size: fontsize_small)[length], "<-")
      edge(Int, (1.7, 0.1), text(size: fontsize_small)[odd], "->", bend: +10deg, label-side: left)
      edge(Int, Bool, text(size: fontsize_small)[even], "->", bend: -10deg, label-side: right)
      edge(Int, Int, "->", bend: -130deg, label: text(size: fontsize_small)[sqrt])
      edge(Ints, Ints, "->", bend: -125deg, label: text(size: fontsize_small)[tail])
      edge(Bool, Bool, "->", bend: +130deg, label: text(size: fontsize_small)[not])
    })
  ]
  #let _right = block(stroke: 1pt, outset: .1em, radius: .5em)[
    #place(
      top + left,
      dy: -1.2em,
      "Type[']"
    )
    #set text(size: fontsize_small)
    #fletcher.diagram({
      let (Int, Ints, Bool) = ((0, 1), (2, 1), (2, 0))
      node(Int, "Int[']")
      node(Ints, "Int[][']")
      node(Bool, "Bool[']")
      edge(Int, Ints, text(size: fontsize_extrasmall)[F(length)], "<-")
      edge(Int, (1.61, 0.1), text(size: fontsize_extrasmall)[F(odd)], "->", bend: +10deg, label-side: left)
      edge(Int, Bool, text(size: fontsize_extrasmall)[F(even)], "->", bend: -10deg, label-side: right)
      edge(Int, Int, "->", bend: -130deg, label: text(size: fontsize_extrasmall)[F(sqrt)])
      edge(Ints, Ints, "->", bend: -125deg, label: text(size: fontsize_extrasmall)[F(tail)])
      edge(Bool, Bool, "->", bend: +130deg, label: text(size: fontsize_extrasmall)[F(not)])
    })
  ]

  #grid(
    columns: 3,
    column-gutter: .5em,
    _left, 
    xarrow(width: 5em)[#text(size: fontsize_medium)[$"[']"$]],
    _right
  )
]
