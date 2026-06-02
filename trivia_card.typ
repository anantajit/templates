#let cols = 2
#let rows = 2
#let questions-per-card = 16
#let max-team-size = 10

#set page(
  paper: "us-letter",
  margin: 0.5in,
)

#let option-list = ("T", "F", "A", "B", "C", "D")

#let answer-options() = [
  #align(center + horizon)[
    #for i in range(0, option-list.len()) [
      #h(1fr) #option-list.at(i) #h(1fr)
    ]
  ]
]

#let card-front(card-no) = [
  #align(top + center)[*Trivia Response Card*]
  #v(0.5em)
  #align(left)[Team Name: #box(height: 12pt, align(bottom)[#line(length: 60%)])]
  #v(0.5em)
  #align(left)[Score: #box(height: 12pt, align(bottom)[#line(length: 20%)])]
  #v(0.5em)

  #let rows-per-side = calc.ceil(questions-per-card / 2)
  #align(center + horizon)[
    #table(
      columns: (auto, 1fr, auto, 1fr),
      align: (center, left, center, left),
      stroke: 0.5pt + black,
      inset: 5pt,
      ..range(0, rows-per-side)
        .map(row => (
          [#(row + 1)],
          [#answer-options()],
          if row + rows-per-side + 1 <= questions-per-card { [#(row + rows-per-side + 1)] } else { [] },
          if row + rows-per-side + 1 <= questions-per-card { [#answer-options()] } else { [] },
        ))
        .flatten(),
    )
  ]

  #align(center + bottom)[
    Circle your answers!
  ]
  
]

#let card-back() = [
  #align(center + horizon)[
    #align(center)[
      *Team Information*
    ]
    #text(size: 11pt)[
      #table(
        columns: (auto, 1fr),
        align: (center, left),
        stroke: 0.5pt + black,
        inset: 0.75em,
        ..range(0, max-team-size)
          .map(row => (
          [#(row + 1)],
          [Name/Email: ],
        ))
        .flatten()
      )
    ]
  ]
]

#let card-box(content) = box(
  width: 100%,
  height: 100%,
  inset: 0.2in,
  stroke: 0.6pt + gray,
  content,
)

#let front-page() = grid(
  columns: (1fr,) * cols,
  rows: (1fr,) * rows,
  gutter: 0pt,
  ..range(0, cols * rows).map(i => card-box(card-front(i + 1))),
)

#let back-page() = {
  // Mirror columns so backs align when duplex printing (flip on long edge).
  let row = (card-box(card-back()), card-box(card-back()))
  grid(
    columns: (1fr,) * cols,
    rows: (1fr,) * rows,
    gutter: 0pt,
    row.at(1), row.at(0),
    row.at(1), row.at(0),
  )
}

#front-page()
#pagebreak()
#back-page()
