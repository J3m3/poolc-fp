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
  #let date = datetime(year: date.year(), month: date.month() + 1, day: 7).display(
    "[year]/[month]/[day] ([weekday repr:short])"
  )

  Source: #github_hypericon #h(1em) #date
]

// 2
#slide(title: "목차")[
  #set enum(number-align: start)
  #let left = {
    set text(fill: rgb(0, 0, 0, 50%))
    tbc(title: "1st Session", (
      (
        "함수형 프로그래밍 Intro", 
        "Overall Structure", "Historical Review (CS + Math)"
      ),
      (
        "함수형 패러다임", 
        "Core of Functional Thinking", "FP Fact-Checking"
      ),
      (
        "FP는 정말 순수한가?",
        "Optimizing with Purity", "Effect Handling Basics"
      )
    ))
  }
  #let right = {
    tbc(title: "2nd Session", (
      (
        "Lazy Evaluation", 
        "How Lazy Evaluation Works", "Infinite Data Structure", "Laziness & Purity"
      ),
      (
        "From Functor to Monad",
        "Functor in PL", "Monad in PL"
      ),
      (
        "Impurity in Pure World?",
        "Side Effect in Pure World", "Uniqueness Typing", "IO Monad"
      )
    ))
  }

  #align(center)[#grid(
    columns: (1fr, 1em, 1fr),
    left,
    [],
    right
  )]
]

// 3 ~ 4
#absolute-center-slide(title: "How Lazy Evaluation Works", header: "Lazy Evaluation")[
  #{[
    #set text(size: fontsize_big)
    _"Evaluation on demand"_
  ]}

  #only(2)[#text(font: "MesloLGS NF", size: 45pt)[_\<Let's code!\>_]]
]

// 5
#absolute-center-slide( title: "How Lazy Evaluation Works", header: "Lazy Evaluation")[
    #{[
    #set text(size: fontsize_big)
    _Thunk_: "A delayed computation"
  ]}
]

// 6
#relative-center-slide(title: "How Lazy Evaluation Works", header: "Lazy Evaluation")[
  #box(width: 90%)[#code(lang: "Haskell", line-spacing: 9pt, ```hs
  xs = [1 .. 10] ++ undefined -- Thunk
  ys = take 3 xs -- Thunk
  main = print ys -- Force evaluation lazily
  {-
    print (take 3 xs)
    print (take 3 ([1 .. 10] ++ undefined))
    print (1 : take 2 ([2 .. 10] ++ undefined))
    print (1 : 2 : take 1 ([3 .. 10] ++ undefined))
    print (1 : 2 : 3 : take 0 ([4 .. 10] ++ undefined))
    print (1 : 2 : 3 : [])
    print [1, 2, 3]
  -}
  ```)]
]

// 7 ~ 8
#absolute-center-slide(title: "Infinite Data Structure", header: "Lazy Evaluation")[
  #set text(size: 45pt)
  ```hs
  ones :: [Int]
  ones = 1 : ones
  ```
  #only(2)[#set text(size: fontsize_big)
  ```hs
  ones = 1 : ones
  ones = 1 : 1 : ones
  ones = 1 : 1 : 1 : ones
  ```]
]

// 9
#relative-center-slide(title: "Infinite Data Structure", header: "Lazy Evaluation")[
  #box(width: 90%)[#code(lang: "Haskell", line-spacing: 9pt, ```hs
  ones = 1 : ones -- Infinite list
  main = print (take 3 ones)
  {-
    print (take 3 ones)
    print (1 : take 2 ones)
    print (1 : 1 : take 1 ones)
    print (1 : 1 : 1 : take 0 ones)
    print (1 : 1 : 1 : [])
    print [1, 1, 1]
  -}
  ```)]
]

// 10
#absolute-center-slide(title: "Infinite Data Structure", header: "Lazy Evaluation")[
  #text(font: "MesloLGS NF", size: 45pt)[_\<Let's code!\>_]
  #v(-1em)

  #{[
    #set text(size: fontsize_big)
    Let's see more interesting examples...
  ]}
]

// 11
#absolute-center-slide(title: "Laziness & Purity", header: "Lazy Evaluation")[
  #{[
    #set text(size: fontsize_big)
    _"Laziness (generally) needs purity"_
  ]}
]

// 12
#absolute-center-slide(title: "Laziness & Purity", header: "Lazy Evaluation")[
  _Scenario: file pointer-based sequential read_ \
  Assume that we are reading a config file structured like below.

  #box(stroke: 1pt)[
    #set text(font: "MesloLGS NF")
    #let header = box(fill: rgb(255, 0, 0, 30), inset: .5em)[header]
    #let basic = box(fill: rgb(0, 255, 0, 30), width: 45%, inset: .5em)[basic]
    #let extended = box(fill: rgb(0, 0, 255, 30), inset: .5em)[extended]
    #header#basic#extended
  ]
]

// 12 ~ 18
#absolute-center-slide(title: "Laziness & Purity", header: "Lazy Evaluation")[
  #only("1-3")[#align(left)[
    Expected:
    #set text(size: fontsize_small, baseline: -2.5pt)
    `readHeader` -> `readBasicConfig` -> `readExtendedConfig`
  ]]
  #only("4-6")[#align(left)[
    Lazy case:
    #set text(size: fontsize_small, baseline: -2.5pt)
    `readBasicConfig` -> `readHeader` -> `readExtendedConfig`
  ]]
  #v(1em)

  #box(stroke: 1pt)[
    #set text(font: "MesloLGS NF")
    #let header = box(fill: rgb(255, 0, 0, 30), inset: .5em)[header#pin("1")]
    #let basic = box(fill: rgb(0, 255, 0, 30), width: 45%, inset: .5em)[basic#pin("2")]
    #let extended = box(fill: rgb(0, 0, 255, 30), inset: .5em)[extended#pin("3")]
    #header#basic#extended

    #set text(size: fontsize_small)
    #only(1)[#pinit-point-from(
      pin-dx: 13pt,
      body-dx: -45pt,
      offset-dx: -45pt,
      pin-dy: -30pt,
      body-dy: -10pt,
      offset-dy: -50pt,
      "1"
    )[ptr]]

    #only(2)[#pinit-point-from(
      pin-dx: 139pt,
      body-dx: -45pt,
      offset-dx: 81pt,
      pin-dy: -30pt,
      body-dy: -10pt,
      offset-dy: -50pt,
      "2"
    )[ptr]]

    #only(3)[#pinit-point-from(
      pin-dx: 13pt,
      body-dx: -45pt,
      offset-dx: -45pt,
      pin-dy: -30pt,
      body-dy: -10pt,
      offset-dy: -50pt,
      "3"
    )[ptr]]

    #only(4)[#pinit-point-from(
      pin-dx: 238pt,
      body-dx: -45pt,
      offset-dx: 180pt,
      pin-dy: -30pt,
      body-dy: -10pt,
      offset-dy: -50pt,
      "1"
    )[ptr]]

    #only(5)[#pinit-point-from(
      pin-dx: 139pt,
      body-dx: -45pt,
      offset-dx: 81pt,
      pin-dy: -30pt,
      body-dy: -10pt,
      offset-dy: -50pt,
      "2"
    )[ptr]]

    #only(6)[#pinit-point-from(
      pin-dx: 13pt,
      body-dx: -45pt,
      offset-dx: -45pt,
      pin-dy: -30pt,
      body-dy: -10pt,
      offset-dy: -50pt,
      "3"
    )[ptr]]
  ]

  #box(width: 95%)[#code(line-spacing: 9pt, ```hs
  getConfig :: File -> Config
  getConfig f =
    let
      header = readHeader f
      basic = readBasicConfig f
      extended = readExtendedConfig (headerVersion header) f
    in Config basic extended
  ```)]
]

// 19
#absolute-center-slide(title: "Functor in PL", header: "From Functor to Monad")[
  #set text(size: fontsize_big)

  #let F = text(fill: blue)[F]

  A #text(fill: color_dark)[type #pin("1")constructor] #F is a Functor if

  #pinit-point-from(
    pin-dx: 35pt,
    body-dx: 10pt,
    offset-dx: 65pt,
    pin-dy: -30pt,
    body-dy: -10pt,
    offset-dy: -50pt,
    thickness: 2pt,
    "1"
  )[
    #set text(size: fontsize_small)
    `i.e. List, Maybe(Optional, Option)`
  ]

  #text(font: "MesloLGS NF", size: fontsize_medium)[
    fmap :: (T -> U) -> (#F\<T\> -> #F\<U\>) #text(fill: gray)[(= lift)]
  ]

  is given. (for arbitrary types T, U)
]

// 20
#absolute-center-slide(title: "Functor in PL", header: "From Functor to Monad")[
  #v(-1em)
  #set text(size: fontsize_big)
  #set enum(number-align: start + top)

  #text(size: 35pt)[_Functor laws_]

    + #align(left)[`fmap (id) ≡ id (where id x = x)`]

    + #align(left)[
      `fmap (f ∘ g) ≡ (fmap f) ∘ (fmap g)` \
      #set text(size: fontsize_small)
      Haskell ver. ` fmap (f . g) ≡ (fmap f) . (fmap g)`
    ]
]

// 21
#absolute-center-slide(title: "Functor in PL", header: "From Functor to Monad")[
  #v(-1em)
  #set text(size: fontsize_big)
  How can we implement `fmap` for _`Maybe`_?
]

// 22 ~ 28
#relative-center-slide(title: "Functor in PL", header: "From Functor to Monad")[
  #v(1em)
  #set text(size: fontsize_big)
  
  #let Maybe = text(fill: blue)[Maybe]

  #only("1-4")[#text(font: "MesloLGS NF", size: fontsize_medium)[
    fmap :: #box(fill: color_light, outset: 7pt, radius: .2em)[(T -> U)]#pin("1")
    -> #box(fill: color_light, outset: 7pt, radius: .2em)[
      (#Maybe\<T\> -> #Maybe\<U\>)
    ]#pin("2")

    #pinit-place(
      dx: -67pt,
      dy: -55pt,
      "1"
    )[f]
    #pinit-place(
      dx: -210pt,
      dy: -55pt,
      "2"
    )[fmap f]
  ]]

  #only(2)[#code(line-spacing: 12pt, ```rs
  fn fmap_f<T, U>(opt_t: Maybe<T>) -> Maybe<U> {
    if (opt_t.is_nothing())
      return Maybe<U>();
    else
      return Maybe<U>(f(opt_t.value()));
  }
  ```)]

  #only(3)[
    #set text(size: fontsize_medium - 1pt)
    #code(line-spacing: 12pt, ```rs
    fn fmap<T, U>(f: T -> U) -> (Maybe<T> -> Maybe<U>) {
      fn fmap_f<T, U>(opt_t: Maybe<T>) -> Maybe<U> {
        if (opt_t.is_nothing())
          return Maybe<U>();
        else
          return Maybe<U>(f(opt_t.value()));
      }
      return fmap_f;
    }
    ```)
  ]

  #only(4)[
    #text(font: "MesloLGS NF", size: fontsize_medium, fill: haskell_color)[
      fmap :: (a -> b) -> Maybe a -> Maybe b
    ]
  ]

  #only("5-6")[
    #v(-1em)
    ```hs data Maybe a = Nothing | Just a```

  ]

  #only(6)[
    #block[
      #align(left)[#text[
        ```hs fmap :: (a -> b) -> Maybe a -> Maybe b``` \
        ```hs fmap f (Just x) = Just (f x)``` \
        ```hs fmap _ Nothing  = Nothing```
      ]]
    ]
  ]

  #only(7)[
    ```hs
    type Functor :: (* -> *) -> Constraint
    class Functor f where
      fmap :: (a -> b) -> f a -> f b
      (<$) :: a -> f b -> f a
      {-# MINIMAL fmap #-}
    ```
  ]
]

// 29 ~ 30
#absolute-center-slide(title: "Monad in PL", header: "From Functor to Monad")[
  #set text(size: fontsize_big)

  #let M = text(fill: blue)[M]

  #block[
    A Functor #M is a Monad if

    #align(left)[
      #text(font: "MesloLGS NF", size: fontsize_medium)[
        #only(1)[
          #text(fill: gray)[fmap :: (T -> U) -> #M\<T\> -> #M\<U\> (= lift)] \
          return :: T -> #M\<T\> #text(fill: gray)[
            #text(size: 25pt)[`               `] (= unit)
          ] \
          join :: #M\<#M\<T\>\> -> #M\<T\> #text(fill: gray)[
            #text(size: 25pt)[`          `] (= flat)
          ]
        ]
        #only(2)[
          #text(fill: gray)[
            fmap :: (T -> U) -> #M\<T\> -> #M\<U\>
            #text(size: 20pt)[`   `] (= lift)
          ] \
          return :: T -> #M\<T\> #text(fill: gray)[
            #text(size: 26pt)[`                  `] (= unit)
          ] \
          bind :: #M\<T\> -> ((T -> #M\<U\>) -> #M\<U\>) #text(fill: gray)[
            (≡ flatMap)
          ]
          #set text(size: fontsize_small)
          #text(font: "Pretendard")[Haskell ver.]` ` (>>=) :: #M a -> (a -> #M b) -> #M b
        ]
      ]
    ]

    is given. (for arbitrary types T, U)
  ]
]

// 31
#relative-center-slide(title: "Monad in PL", header: "From Functor to Monad")[
  #v(-1em)
  #set text(size: fontsize_big)
  #set enum(number-align: start + top)

  #text(size: 35pt)[_Monad laws_]

  + #align(left)[
    `bind m return ≡ m` \
    #set text(size: fontsize_small)
    Haskell ver. ` m >>= return ≡ m`
  ]

  + #align(left)[
    `bind (return x) f ≡ f x` \
    #set text(size: fontsize_small)
    Haskell ver. ` return x >>= f ≡ f x`
  ]

  + #align(left)[
    `bind (bind m f) g ≡ bind m (\x -> f x >>= g)` \
    #set text(size: fontsize_small)
    Haskell ver. ` (m >>= f) >>= g ≡ m >>= (\x -> f x >>= g)`
  ]
]

// 32 ~ 36
#relative-center-slide(title: "Monad in PL", header: "From Functor to Monad")[
  #v(-1em)
  #set text(size: fontsize_big)
  #set enum(number-align: start + top)

  #text(size: 35pt)[_Semantic of Monad_]

  #let moand_in_math = "A monoid in the category of endofunctors"

  #block[#align(left)[
    #only(1)["#moand_in_math"]
    #only(2)[#strike["#moand_in_math"]]
    #only(3)[
      #set text(size: fontsize_medium)
      #set list(marker: ("•", "∘"), indent: .5em)
      If M is a Monad, M\u{003C}T\u{003E} is an _extension of T_, where
      - operations on T can also be extended
      - the same extension on itself(i.e. M\<M\<T\>\>) is
        - meaningless, or
        - logically equial to the original, or
        - can be seen as the original in some aspect
    ]
    #only(4)[
      #set text(size: fontsize_medium)
      - Maybe \<T\>: T or Nothing
      - Maybe \<Maybe \<T\>\>: T or Nothing or Nothing
        \ `                     `= Maybe \<T\>
      _Meaning is preserved!_ (but type changed)
      - return :: T -> Maybe \<T\>
      - join :: Maybe \<Maybe \<T\>\> -> Maybe \<T\>
    ]
    #only(5)[
      #set text(size: fontsize_medium)
      - List \<T\>: bunch of Ts
      - List \<List \<T\>\>: bunch of bunches of Ts
        \ `               `≃ List \<T\>
      _Meaning is preserved!_ (but type changed)
      - return :: T -> List \<T\>
      - join :: List \<List \<T\>\> -> List \<T\>
    ]
  ]]
]

// 37
#absolute-center-slide(title: "Monad in PL", header: "From Functor to Monad")[
  #v(-1em)
  #set text(size: fontsize_big)
  How can we implement `return` for _`Maybe`_?
]

// 38 ~ 39
#absolute-center-slide(title: "Monad in PL", header: "From Functor to Monad")[
  #v(1em)
  #set text(size: fontsize_big)
  #set enum(number-align: start + top)
  
  #let Maybe = text(fill: blue)[Maybe]

  #only("1-")[#text(font: "MesloLGS NF", size: fontsize_medium)[
    return :: T -> #Maybe\<T\>
  ]]

  #only(2)[#code(line-spacing: 12pt, ```rs
  fn returnM<T>(t: T) -> Maybe<T> {
    return Maybe<T>(t);
  }
  ```)]
]

// 40
#absolute-center-slide(title: "Monad in PL", header: "From Functor to Monad")[
  #v(-1em)
  #set text(size: fontsize_big)
  How can we implement `bind` for _`Maybe`_?
]

// 41 ~ 44
#absolute-center-slide(title: "Monad in PL", header: "From Functor to Monad")[
  #v(1em)
  #set text(size: fontsize_big)
  #set enum(number-align: start + top)
  
  #let Maybe = text(fill: blue)[Maybe]

  #only(("1", "4-"))[#text(font: "MesloLGS NF", size: fontsize_medium)[
    bind :: #Maybe\<T\> -> ((T -> #Maybe\<U\>) -> #Maybe\<U\>)
  ]]

  #only("2-3")[#text(font: "MesloLGS NF", size: fontsize_medium)[
    bind :: (#Maybe\<T\>, (T -> #Maybe\<U\>)) -> #Maybe\<U\>
  ]]

  #only(3)[
    #set text(size: fontsize_medium)

    #code(line-spacing: 12pt, ```rs
    fn bind<T, U>(m: Maybe<T>, f: T -> Maybe<U>) -> Maybe<U> {
      if (m.is_nothing())
        return Maybe<U>();
      else
        return f(m.value());
    }
    ```)
  ]

  #only(4)[
    #set text(size: fontsize_medium)

    #code(line-spacing: 12pt, ```rs
    fn bind<T, U>(m: Maybe<T>) -> ((T -> Maybe<U>) -> Maybe<U>) {
      fn bind_f(f: T -> Maybe<U>) {
        if (m.is_nothing())
          return Maybe<U>();
        else
          return f(m.value());
      }
      return bind_f;
    }
    ```)
  ]
]

// 45
#absolute-center-slide(title: "Monad in PL", header: "From Functor to Monad")[
  #set text(size: fontsize_big)

  #let Maybe = text(fill: blue)[Maybe]

  #block[#align(left)[
    #set text(font: "MesloLGS NF", size: fontsize_medium)
    return :: T -> #Maybe\<T\> \
    #text(font: "MesloLGS NF", size: fontsize_medium, fill: haskell_color)[
      return :: a -> #Maybe a
    ]

    bind :: #Maybe\<T\> -> ((T -> #Maybe\<U\>) -> #Maybe\<U\>) \
    #text(font: "MesloLGS NF", size: fontsize_medium, fill: haskell_color)[
      (>>=) :: #Maybe a -> (a -> #Maybe b) -> #Maybe b
    ]
  ]]
]

// 46 ~ 47
#absolute-center-slide(title: "Monad in PL", header: "From Functor to Monad")[
  #set text(size: fontsize_big)

  ```hs data Maybe a = Nothing | Just a```

  #only(1)[#block[
    #align(left)[#text[
      ```hs return :: a -> Maybe a``` \
      ```hs return x = Just x```
    ]]
  ]]

  #only(2)[#block[
    #align(left)[#text[
      ```hs
      (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
      (Just x) >>= f = f x
      Nothing  >>= _ = Nothing
      ```
    ]]
  ]]
]

// 48
#absolute-center-slide(title: "Monad in PL", header: "From Functor to Monad")[
  #set text(size: fontsize_big)
  ```hs
  type Monad :: (* -> *) -> Constraint
  class Applicative m => Monad m where
    (>>=) :: m a -> (a -> m b) -> m b
    (>>) :: m a -> m b -> m b
    return :: a -> m a
    {-# MINIMAL (>>=) #-}
  ```
]

// 49 ~ 51
#absolute-center-slide(title: "Monad in PL", header: "From Functor to Monad")[
  #set text(size: fontsize_big)

  Any use cases of _Monad_ and _`bind`_? \
  #set text(size: fontsize_medium)
  #only("2-")[Scenario: Multiple HTTP requests dependent on each other]
  
  #only(3)[#text(font: "MesloLGS NF", size: 45pt)[_\<Let's code!\>_]]
]

// 52
#absolute-center-slide(title: "Monad in PL", header: "From Functor to Monad")[
  #set text(font: "MesloLGS NF")
  f :: a -> #box(outset: .3em, radius: .2em, fill: color_light)[Maybe b] \
  g :: #box(outset: .3em, radius: .2em, fill: color_light)[b] -> Maybe c \
  #block[
    #align(left)[#text[

      (>>=) :: Maybe b -> (b -> Maybe c) -> Maybe c \
      f x >>= g :: Maybe c
    ]]
  ]
]

// 53
#absolute-center-slide(title: "Side Effect in Pure World", header: "Impurity in Pure World?")[
  #block(width: 90%)[
    #code(lang: "Haskell", line-spacing: 12pt, ```hs
    whatIsYourName :: IO ()
    whatIsYourName = do
      putStr "What is your name? "
      firstName <- getLine  -- same input!
      lastName <- getLine   -- same input!
      putStrLn ("Hello, " ++ firstName ++ " " ++ lastName)
    ```)
  ]
]

// 54
#absolute-center-slide(title: "Side Effect in Pure World", header: "Impurity in Pure World?")[
  #set enum(number-align: start + top)

  #block(width: 70%)[
    + #align(start)[What is IO in the type signature?]
    
    + #align(start)[How can we perform side effects in a language where side effects are not allowed?]
  ]
]

// 55
#absolute-center-slide(title: "Uniqueness Typing", header: "Impurity in Pure World?")[
  #block(width: 80%)[#align(left)[
    "A value with a _unique type_ is _guaranteed to have at most one reference to it at run-time_, which means that it can safely be updated in-place, reducing the need for memory allocation and garbage collection."
  ]]
    $italic("The Idris Tutorial")$
]

// 56
#absolute-center-slide(title: "Uniqueness Typing", header: "Impurity in Pure World?")[
  #block(width: 90%)[
    #code(lang: "Clean", line-spacing: 12pt, ```ocaml
    module hello
    import StdEnv

    Start :: *World -> *World
    Start world
      # (console, world) = stdio world
      # console = fwrites "Hello, World!\n" console
      # (ok, world) = fclose console world
      | not ok = abort "ERROR: cannot close console\n"
      | otherwise = world
    ```)
  ]
]

// 57
#absolute-center-slide(title: "IO Monad", header: "Impurity in Pure World?")[
  #set text(size: fontsize_big)
  Let's _hide "World"_ from users!
]

// 58 ~ 59
#absolute-center-slide(title: "IO Monad", header: "Impurity in Pure World?")[
  #v(1.5em)

  #set text(size: fontsize_medium - 1pt)
  #block(width: 90%)[
    #code(lang: "Haskell", line-spacing: 13pt, ```hs
    type WorldT a = World -> (a, World)

    readStrT :: WorldT String
    readStrT = readStr

    printStrT :: String -> WorldT ()
    printStrT str world = ((), printStr str world)

    (>>>=) :: WorldT a           -- World -> (a, World)
            -> (a -> WorldT b)   -- a -> World -> (b, World)
            -> WorldT b          -- World -> (b, World)
    m >>>= f = uncurry f . m
    whatIsYourPureNameT :: WorldT ()
    whatIsYourPureNameT =
      printStrT "What is your name?" >>>= \_ ->
      readStrT                       >>>= \firstName ->
      readStrT                       >>>= \lastName ->
      printStrT ("Hello, " ++ firstName ++ " " ++ lastName)
    ```)
  ]
]