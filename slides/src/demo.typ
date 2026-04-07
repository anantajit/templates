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
    fill: red,
    footer: black
  ),
)

#template.prose[Sample Slide][
  Hello World
]

#template.callout([asdf])
