#import "@local/slides:0.1.0": default

// Initialize the template
#show: doc => default.init(doc)

#default.cover(
  [Title Slide],
  subtitle: [Subtitle],
  project: [Project Title],
  // graphic: "/assets/image.jpg"
)

#default.callout(
  [This is a big deal],
  subline: [You have 10 minutes.],
  colors: (
    fill: blue,
    body: white,
    footer: white
  ),
)

#default.prose[Sample Slide][
]

#default.callout([asdf])
