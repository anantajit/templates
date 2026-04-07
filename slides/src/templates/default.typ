/*
* Default presentation layout
* Interfaces to be implemented by all presentations
*/

#import "@preview/polylux:0.4.0": *

#let title(
  headline, 
  subtitle: [],
  project: [],
  date: datetime.today().display(),
  presenter: [Anantajit Subrahmanya],
  graphic: none,
) = {
  set text(font: "Adwaita Sans")

  slide(
    // Placeholder template
    if graphic != none {
      // With a graphic
      image(graphic)
    } else {
      align(left + horizon)[
        #text(headline, size: 48pt)
        #linebreak()
        #text(subtitle, size: 24pt)
        #linebreak()
        #date
      ]
    }
  )
}
