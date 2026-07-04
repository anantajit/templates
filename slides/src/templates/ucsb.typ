/*
 * UCSB Branded Template
 */

#import "@preview/polylux:0.4.0": *
#import "../core.typ" as core
#import "@preview/one-liner:0.3.0" as oneliner

#let numbered-state = state("ucsb-numbered", true)
#let title-state = state("ucsb-title", none)
#let presenter-state = state("ucsb-presenter", none)
#let affiliation-state = state("ucsb-affiliation", none)
#let presenter-set-state = state("ucsb-presenter-set", false)
#let affiliation-set-state = state("ucsb-affiliation-set", false)
#let sections-state = state("ucsb-sections", ())

#let get-numbered() = context {
  numbered-state.get()
}

#let get-title() = context {
  title-state.get()
}

#let get-presenter() = context {
  presenter-state.get()
}

#let get-affiliation() = context {
  affiliation-state.get()
}

#let get-sections() = context {
  sections-state.get()
}

#let pause = [#metadata("ucsb-pause")]

#let is-pause-marker(it) = (
  type(it) == content and (
    it.func() == metadata and it.fields().at("value", default: none) == "ucsb-pause"
    or it.has("children") and it.children.any(is-pause-marker)
  )
)

#let apply-pauses(body) = {
  let children = if type(body) == content and body.has("children") { body.children } else { (body,) }
  let chunks = ()
  let current = []
  let paused = false
  for child in children {
    if is-pause-marker(child) {
      if current != [] { chunks.push((paused, current)) }
      current = []
      paused = true
    } else {
      current += child
    }
  }
  if current != [] { chunks.push((paused, current)) }
  for (paused, body) in chunks { if paused { later(body) } else { body } }
}

#let footer() = {
  let is-numbered = numbered-state.get()
  let presenter = presenter-state.get()

  set text(size: 14pt)

  []
  h(1fr)
  if is-numbered {
    [#counter(page).display("1") of #counter(page).final().at(0)]
  }

  align(center + bottom, box(
    inset: 0.25em,
    text(12pt)[
      #sym.copyright
      #if presenter != none {
        presenter
      }
      #datetime.today().year(). All Rights Reserved.
    ],
  ))
}

#let colors = (
  deep_ocean: (color: rgb(0, 54, 96), contrast: rgb(255, 255, 255)),
  sun_gold: (color: rgb(254, 188, 17), contrast: rgb(61, 73, 82)),
  charcoal: (color: rgb(17, 21, 23), contrast: rgb(255, 255, 255)),
  cloud_gray: (color: rgb(220, 225, 229), contrast: rgb(61, 73, 82)),
  pale_cloud: (color: rgb(238, 240, 242), contrast: rgb(61, 73, 82)),
  pure_white: (color: rgb(255, 255, 255), contrast: rgb(61, 73, 82)),
  sea_green: (color: rgb(9, 132, 122), contrast: rgb(255, 255, 255)),
  marine_teal: (color: rgb(4, 124, 145), contrast: rgb(255, 255, 255)),
  olive_moss: (color: rgb(109, 125, 51), contrast: rgb(255, 255, 255)),
  coral_bloom: (color: rgb(239, 86, 69), contrast: rgb(1, 21, 23)),
  rust_coral: (color: rgb(196, 52, 36), contrast: rgb(255, 255, 255)),
  warm_clay: (color: rgb(220, 214, 204), contrast: rgb(61, 73, 82)),
  light_clay: (color: rgb(241, 238, 234), contrast: rgb(61, 73, 82)),
  dune_sand: (color: rgb(201, 191, 157), contrast: rgb(61, 73, 82)),
  light_dune: (color: rgb(237, 234, 223), contrast: rgb(61, 73, 82)),
  sea_mist: (color: rgb(156, 190, 190), contrast: rgb(61, 73, 82)),
  light_mist: (color: rgb(218, 230, 230), contrast: rgb(61, 73, 82)),
)

#let init(doc, numbered: false, title: none, presenter: none, affiliation: none) = {
  show: doc => core.init(doc)

  set text(font: ("Avenir", "Apple SD Gothic Neo", "Roboto", "Noto Sans", "Arial"))

  numbered-state.update(numbered)
  title-state.update(title)
  presenter-state.update(presenter)
  affiliation-state.update(affiliation)
  presenter-set-state.update(presenter != none)
  affiliation-set-state.update(affiliation != none)

  set page(footer: {
    set text(fill: eastern)
    context {
      footer()
    }
  })

  doc
}

/*
 * Cover slide used to open a deck and establish context. By default, inherit from the document
 */
#let cover(
  headline: none,
  subtitle: none,
  presenter: none,
  affiliation: none,
  collaborators: none,
  venue: none,
  date: none,
  // Extra decoration
  separate-collaborators: false,
) = {
  let using-state-presenter = presenter == none
  let using-state-affiliation = affiliation == none

  let resolved-headline = if headline == none { get-title() } else { headline }
  let resolved-presenter = if using-state-presenter { get-presenter() } else { presenter }
  let resolved-affiliation = if using-state-affiliation { get-affiliation() } else { affiliation }

  // Footer disabled for only the title slide
  set page(fill: colors.deep_ocean.color, footer: none)
  set text(fill: colors.deep_ocean.contrast)

  slide({
    grid(rows: (1fr, auto))[
      #grid(
        rows: (20%, 20%, 45%),
      )[
        // Top section -- empty
        #box(width: 100%)
      ][
        // Middle
        #set align(left + top)
        #if venue != none {
          h(1pt)
          text(size: 18pt, upper(venue))
        }

        #v(-12pt)
        #text(weight: "bold", size: 36pt, resolved-headline)
        #linebreak()
        #h(2pt)
        #text(size: 24pt, subtitle)
      ][
        #set align(right + bottom)
        #context {
          let has-presenter = if using-state-presenter { presenter-set-state.get() } else { true }
          let has-affiliation = if using-state-affiliation { affiliation-set-state.get() } else { true }

          if has-presenter and has-affiliation {
            text(size: 16pt, [#resolved-presenter, #resolved-affiliation], weight: "bold", fill: colors.sun_gold.color)
          } else if has-presenter {
            text(size: 16pt, resolved-presenter, weight: "bold", fill: colors.sun_gold.color)
          } else if has-affiliation {
            text(size: 16pt, resolved-affiliation, weight: "bold", fill: colors.sun_gold.color)
          }
        }

        #if collaborators != none {
          if separate-collaborators {
            line(length: 50%, stroke: colors.deep_ocean.contrast)
          }
          for person in collaborators {
            let name = person.at("name", default: none)
            let person-affiliation = person.at("affiliation", default: none)
            if name != none and person-affiliation != none {
              text(size: 16pt, [#name, #person-affiliation])
            } else if name != none {
              text(size: 16pt, name)
            } else if person-affiliation != none {
              text(size: 16pt, person-affiliation)
            }
            linebreak()
          }
        }
      ]
    ][
      #grid(columns: (1fr, 1fr))[
        #if date != none {
          h(0.8em)
          text(size: 16pt, date)
        }
      ][
        #align(right + bottom)[
          #image("../assets/ucsb-wordmark.svg", width: 6.2cm)
        ]
      ]
    ]
  })
}

/*
 * Section divider slide used between major chapters. Automatically populates in
 * the agenda unless otherwise stated.
 */
#let section(
  headline,
  subheading: none,
  color: colors.pure_white,
  visible: true,
) = {
  let fill_color = color.color
  let text_color = color.contrast

  sections-state.update(sections => (
    sections
      + (
        (
          headline: headline,
          subheading: subheading,
          color: color,
          visible: visible,
        ),
      )
  ))

  if not visible {
    return
  }

  set page(fill: fill_color, footer: {
    set text(fill: text_color)
    context {
      footer()
    }
  })

  slide({
    set text(fill: text_color)
    align(center + horizon, oneliner.fit-to-width(text(weight: "extrabold", headline)))
    if subheading != none {
      align(center, subheading)
    }
  })
}

/*
 * Agenda slide used to show deck structure and progress. Inherits from section,
 * with a manual override option.
 * Args:
 * - headline: Agenda title.
 * - sections: Ordered list of section labels.
 * - current: Optional current section key/index for highlighting.
 */
#let agenda(
  headline: none,
  sections: none,
  current: none,
) = {
  let resolved-headline = if headline == none { [Agenda] } else { headline }

  let item-label(item) = {
    if type(item) == dictionary {
      item.at("headline", default: none)
    } else {
      item
    }
  }

  slide(
    grid(
      rows: (auto, 1fr),
      row-gutter: 1.5em,
      [
        = #text(fill: colors.deep_ocean.color)[#resolved-headline]
      ],
      [
        #context {
          let resolved-sections = if sections == none {
            sections-state.final()
          } else {
            sections
          }
          let highlight-index = if current == none {
            none
          } else if current == -1 {
            0
          } else {
            current
          }

          if resolved-sections == none or type(resolved-sections) != array or resolved-sections.len() == 0 {
            [No sections yet.]
          } else {
            set text(fill: colors.sun_gold.contrast)

            list(
              marker: none,
              spacing: 14pt,
              ..range(resolved-sections.len()).map(i => {
                let item = resolved-sections.at(i)
                let label = item-label(item)
                if label == none {
                  []
                } else if highlight-index != none and i == highlight-index {
                  text(weight: "bold", label)
                } else {
                  label
                }
              }),
            )
          }
        }
      ],
    ),
  )
}

/* Prose slide for narrative explanation where bullets are too lossy.
 * Args:
 * - headline: Action title for the slide.
 * - body: Main paragraph content.
 * - callout: Optional emphasized aside near the body.
 * - footnote: Optional footer note for caveats/definitions.
 */
#let prose(
  headline,
  body,
) = {
  slide[
    #grid(rows: (auto, 1fr), row-gutter: 1.5em)[
    = #text(fill: colors.deep_ocean.color)[#headline]
    ][
      #apply-pauses(body)
    ]
  ]
}

/*
 * Two-column slide for comparison or parallel arguments.
 * Args:
 * - headline: Action title for the slide.
 * - left: Content for the left column.
 * - right: Content for the right column.
 */
#let split(
  headline,
  left,
  right,
  columns: (auto, auto),
  footnote: [],
) = {
  slide()[
    #grid(
      rows: (auto, 1fr, auto),
      row-gutter: 0em,
      [= #text(fill: colors.deep_ocean.color)[#headline] #v(1em)],
      [
        #grid(
          columns: columns,
          column-gutter: 1em,
          [
            #left
          ],
          [
            #right
          ]
        )

      ],
      align(bottom + center)[
        #set text(12pt)
        #footnote
      ],
    )
  ]
}

/*
 * Figure slide for text + media storytelling.
 * Args:
 * - headline: Action title for the slide.
 * - media: Primary figure/image/diagram object.
 * - caption: Optional caption describing the media.
 * - body: Optional supporting narrative text.
 * - label: Optional exhibit label (e.g., "Figure 2").
 * - source: Optional source/credit line.
 */
#let figure(
  headline,
  figure,
  body: [],
  caption: [],
  source: [],
) = {}

/*
 * Callout slide to emphasize one key message.
 * Args:
 * - message: Main statement (large type).
 * - subline: Optional supporting sentence.
 * - attribution: Optional source/speaker attribution.
 */
#let callout(
  message,
  subline: none,
  colors: color,
  attribution: [],
) = {
  set page(fill: colors.color, footer: {
    set text(fill: colors.contrast)
    context {
      footer()
    }
  })

  slide({
    set text(fill: colors.contrast)
    align(center + horizon, oneliner.fit-to-width(text(weight: "extrabold", message)))
    align(center, subline)
  })
}

/**
 * UC Santa Barbara closing slide
 */
#let splash() = {}

/**
 * Bibliography (may span multiple slides); use for manual entry
 */
#let bibliography() = {}
