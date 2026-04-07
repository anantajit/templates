#import "templates/default.typ" as template

// Initialize the template
#show: doc => template.init(doc)

#template.cover(
  [Title Slide],
  subtitle: [Subtitle],
  project: [Project Title],
  // graphic: "/assets/image.jpg"
)

#template.prose[Sample Slide][
  Hello World
]
