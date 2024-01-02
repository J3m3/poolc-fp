#let default_font = "Pretendard"
#let font_big = 30pt
#let font_medium = 25pt
#let font_small = 20pt
#let font_extrasmall = 16pt
#let font_copyright = 6pt

#let (margin_x, margin_y) = (1.1cm, 1.1cm)

// ======= CHANGABLE THINGS =======
#let color_light = rgb("#e0f0ed")
#let color_medium = rgb("#a7dad5")
#let color_dark = rgb("#47be9b")
#let date = datetime(year: 2024, month: 1, day: 20)
// ================================

#let copyright(date: date) = [
  ⓒ #date.year(). Je Sung Yang all rights reserved.
]
