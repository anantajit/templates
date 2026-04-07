#import "core.typ": *
#import "templates/default.typ" as template

// Place code for slides here 
#show: doc => slides(doc)

#template.cover(
  [Title Slide],
  subtitle: [Subtitle],
  project: [Project Title],
  // graphic: "/assets/image.jpg"
)

