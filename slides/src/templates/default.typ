/*
* Default presentation layout
* Interfaces to be implemented by all presentations
*/

#import "@preview/polylux:0.4.0": *

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
 * Agenda slide used to show deck structure and progress.
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
 * - note: Optional short note/callout near the body.
 * - footnote: Optional footer note for caveats/definitions.
 */
#let prose(
  headline,
  body,
  note: [],
  footnote: [],
) = {}

/*
 * Bullet slide for concise findings, claims, or action points.
 * Args:
 * - headline: Action title for the slide.
 * - items: Ordered or unordered bullet items.
 * - callout: Optional emphasized takeaway line.
 */
#let bullets(
  headline,
  items: (),
  callout: [],
) = {}

/*
 * Two-column slide for comparison or parallel arguments.
 * Args:
 * - headline: Action title for the slide.
 * - left: Content for the left column.
 * - right: Content for the right column.
 * - left_label: Optional header for the left column.
 * - right_label: Optional header for the right column.
 * - note: Optional shared note beneath the columns.
 */
#let split(
  headline,
  left,
  right,
  left_label: [],
  right_label: [],
  note: [],
) = {}

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
  media,
  caption: [],
  body: [],
  label: [],
  source: [],
) = {}

/*
 * Exhibit slide for data-first content (charts/tables).
 * Args:
 * - headline: Action title for the slide.
 * - content: Main exhibit content (chart/table).
 * - annotations: Optional callouts layered over the exhibit.
 * - notes: Optional interpretation/method notes.
 * - source: Source line for data provenance.
 */
#let exhibit(
  headline,
  content,
  annotations: (),
  notes: [],
  source: [],
) = {}

/*
 * Full-bleed visual slide for high-impact single-image communication.
 * Args:
 * - media: Full-bleed visual asset.
 * - caption: Optional short caption.
 * - label: Optional small top/bottom label.
 * - credit: Optional photographer/asset credit.
 */
#let visual(
  media,
  caption: [],
  label: [],
  credit: [],
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
  subline: [],
  attribution: [],
) = {}

/*
 * Framework canvas for structured reasoning models.
 * Args:
 * - headline: Action title for the slide.
 * - content: Framework body (2x2, process, tree, roadmap, etc.).
 * - legend: Optional legend for symbols/colors.
 * - notes: Optional explanatory notes.
 */
#let canvas(
  headline,
  content,
  legend: [],
  notes: [],
) = {}

/*
 * Summary/next-steps slide for section or deck close.
 * Args:
 * - headline: Closing title.
 * - tiles: 3-5 summary/action tiles.
 * - owner: Optional owner/accountable person.
 * - due: Optional due date or timing marker.
 * - note: Optional closing note.
 */
#let summary(
  headline,
  tiles: (),
  owner: [],
  due: [],
  note: [],
) = {}
