#import "templates/default.typ" as template

// Initialize the template
#show: doc => template.init(doc)

#template.cover(
  [Title Slide],
  subtitle: [Subtitle],
  project: [Project Title],
  // graphic: "/assets/image.jpg"
)

#template.callout(
  [This is a big deal],
  subline: [You have 10 minutes.],
  colors: (
    fill: blue,
    body: white,
    footer: white
  ),
)

#template.prose[Sample Slide][
]

#template.callout([asdf])
