/*
* Default presentation layout
* Interfaces to be implemented by all presentations
*/

#import "@preview/polylux:0.4.0": *
#import "../core.typ" as core
#import "@preview/one-liner:0.3.0" as oneliner

#let presenter-state = state("presenter", "")

#let default_footer() = {
    set text(size: 14pt)

    []
    h(1fr)
    [#counter(page).display("1") of #counter(page).final().at(0)]

    align(center + bottom, 
      box(
        inset: 0.25em,
        text(12pt)[#sym.copyright #presenter-state.get() #datetime.today().year(). All Rights Reserved.]
      )
    )
}

#let init(doc, numbered: false, footer: none, presenter: none) = {
  show: doc => core.init(doc)

  set text(font: ("Apple SD Gothic Neo", "Noto Sans", "Arial"))

  if presenter != none {
    presenter-state.update(presenter)
  }

  set page(
    footer: if (footer == none) {
      set text(fill: eastern)
      context{
        default_footer()
      }
    } else {
      footer
    }
  )
  
  doc
}

/*
 * Cover slide used to open a deck and establish context.
 * Args:
 * - headline: Primary deck title (takeaway or topic).
 * - subtitle: Optional secondary title line.
 * - project: Optional project/client/program label.
 * - date: Display date for versioning/context.
 * - presenter: Author/presenter name or affiliation.
 * - graphic: Optional hero image or visual accent.
 */
#let cover(
  headline, 
  subtitle: [],
  project: [],
  date: datetime.today().display("[weekday], [month repr:long] [day padding:none], [year]"),
  presenter: [Anantajit Subrahmanya],
  graphic: none,
) = {
  // Footer disabled for only the title slide
  set page(footer: none)

  let faded-rainbow = gradient.conic(
    ..color.map.rainbow.map(c => c.transparentize(50%))
  )

  slide(
    // Placeholder template
    {
      align(horizon, {grid(
        columns: (auto, auto),
        align(left + horizon)[
          #text(headline, size: 48pt)
          #linebreak()
          #h(8pt)
          #text(subtitle, size: 24pt)
          #linebreak()
          #h(8pt)
          #text(size: 16pt, date)
          #line(length: 100%)
          #v(-0.5em)
          #h(8pt)
          #text(presenter, size: 20pt)
        ], if (graphic != none) {
          box(
            box(
              image(graphic, width: 256pt),
              inset: 0.5em,
              radius: 1em,
              stroke: (
              paint: faded-rainbow,
              thickness: 3pt),
              clip: true,
            ),
            inset: 1em
          )
        }
      )
      }
    )
    }
  )
}

/*
 * Section divider slide used between major chapters. Automatically populates in 
 * the agenda unless otherwise stated.
 * Args:
 * - headline: Section title.
 * - promise: Optional one-line section promise (what this section delivers).
 */
#let section(
  headline,
  promise: [],
) = {}

/*
 * Agenda slide used to show deck structure and progress. Inherits from section,
 * with a manual override option.
 * Args:
 * - headline: Agenda title.
 * - sections: Ordered list of section labels.
 * - current: Optional current section key/index for highlighting.
 */
#let agenda(
  headline,
  sections: (),
  current: none,
) = {}

/*
 * Prose slide for narrative explanation where bullets are too lossy.
 * Args:
 * - headline: Action title for the slide.
 * - body: Main paragraph content.
 * - callout: Optional emphasized aside near the body.
 * - footnote: Optional footer note for caveats/definitions.
 */
#let prose(
  headline,
  body,
  footnote: none,
) = {
  grid(
    rows: (auto, 1fr),
    row-gutter: 1.5em,
    [= #headline],
    [#body]
  )
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
      rows: (auto, 1fr),
      row-gutter: 1em,
      [= #headline],
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

        ]
        )

        #align(bottom + center)[
          #set text(12pt)
          #footnote
        ]
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
  label: [],
  source: [],
) = {

}

/*
 * Exhibit slide for data-first content (charts/tables).
 * Args:
 * - headline: Action title for the slide.
 * - content: Main exhibit content (chart/table).
 * - annotations: Optional callouts layered over the exhibit.
 * - callout: Optional short interpretation note near the exhibit.
 * - footnote: Optional footer note for caveats/definitions.
 * - source: Source line for data provenance.
 */
#let exhibit(
  headline,
  content,
  annotations: (),
  callout: [],
  footnote: [],
  source: [],
) = {}

/*
 * Full-bleed visual slide for high-impact single-image communication.
 * Args:
 * - media: Full-bleed visual asset.
 * - caption: Optional short caption.
 * - label: Optional small top/bottom label.
 * - source: Optional photographer/asset credit line.
 */
#let visual(
  media,
  caption: [],
  label: [],
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
  colors: (
    fill: white,
    body: black,
    footer: eastern
  ),
  attribution: [],
) = {
  set page(fill: colors.fill, footer: {
    set text(fill: colors.footer)
    context {
      default_footer()
    }
  })

  slide({
      set text(fill: colors.body)
      align(center + horizon,
        oneliner.fit-to-width(text(weight: "extrabold", message))
      )
      align(center, subline)
    }
  )
}

/*
 * Framework canvas for structured reasoning models.
 * Args:
 * - headline: Action title for the slide.
 * - content: Framework body (2x2, process, tree, roadmap, etc.).
 * - legend: Optional legend for symbols/colors.
 * - callout: Optional interpretation note near the framework.
 * - footnote: Optional footer note for caveats/definitions.
 */
#let canvas(
  headline,
  content,
  legend: [],
  callout: [],
  footnote: [],
) = {}

/*
 * Summary/next-steps slide for section or deck close.
 * Args:
 * - headline: Closing title.
 * - tiles: 3-5 summary/action tiles.
 * - owner: Optional owner/accountable person.
 * - due: Optional due date or timing marker.
 * - callout: Optional closing takeaway line.
 * - footnote: Optional footer note for caveats/definitions.
 */
#let summary(
  headline,
  tiles: (),
  owner: [],
  due: [],
  callout: [],
  footnote: [],
) = {}
