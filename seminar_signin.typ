#set page(
  paper: "us-letter",
  margin: 0.75in
)

#set document(title: "Sign-in Sheet")
#let checkbox = box(
  width: 12pt,
  height: 12pt,
  stroke: 0.5pt,
)

#text(18pt, align(center)[
  Sign-in Sheet  
])
#table(
  columns: (auto, 1fr, 1fr, 25%),
  inset: 5pt,
  stroke: 0.5pt,
  strong("#"), strong("Name"), strong("Department"), strong("Undergrad/Grad/Other"),
  
  // Data rows - empty rows for people to fill out
  align: (center, left, left, center),
  ..for i in range(59) {
    (
      str(i + 1), "", "", [#checkbox #checkbox #box(
        width: 1fr, height: 12pt, stroke: (thickness: 0.5pt, dash: "dotted")
      )]
    )
  }
)
