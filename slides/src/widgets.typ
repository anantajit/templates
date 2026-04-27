#let pane(
  body,
  inset: 0.8em,
  radius: 18pt,
  fill: white,
  stroke: none,
  clip: true,
  shadow: true,
  shadow_offset: (x: 1pt, y: 1pt),
  shadow_fill: luma(80%).transparentize(75%),
  shadow_layers: 4,
  shadow_spread: 2pt,
) = layout(size => {
  let frame = (x: 0pt, y: 0pt, w: size.width, h: size.height)
  let sx = shadow_offset.at("x")
  let sy = shadow_offset.at("y")

  box(width: size.width, height: size.height)[
    #if shadow {
      let layers = calc.max(1, shadow_layers)
      for layer in range(layers) {
        let step = layer + 1
        let ratio = step / layers
        let spread = shadow_spread * step
        let dx = frame.x + sx * ratio - spread / 2
        let dy = frame.y + sy * ratio - spread / 2
        place(top + left, dx: dx, dy: dy)[
          #box(
            width: frame.w + spread,
            height: frame.h + spread,
            radius: radius + spread / 2,
            fill: shadow_fill.transparentize(35% * ratio),
            clip: true,
          )[]
        ]
      }
    }

    #place(top + left)[
      #box(
        width: size.width,
        height: size.height,
        inset: inset,
        radius: radius,
        fill: fill,
        stroke: stroke,
        clip: clip,
      )[#body]
    ]
  ]
})

#let panes(
  divisions: 2,
  margin: 6pt,
  pane-fn: pane,
  fill: none,
  ..children,
) = {
  let bodies = children.pos()
  let n = calc.max(1, bodies.len())
  let d = calc.max(2, divisions)
  let m = calc.max(0pt, margin)
  let colors = if fill == none {
    none
  } else if type(fill) == array and fill.len() > 0 {
    fill
  } else {
    (fill,)
  }

  let pick-fill(i) = colors.at(calc.rem(i, colors.len()))

  let split(rem, vertical, parts-left) = if vertical {
    let a = (x: rem.x, y: rem.y, w: rem.w / parts-left, h: rem.h)
    let b = (x: rem.x + a.w, y: rem.y, w: rem.w - a.w, h: rem.h)
    (pane: a, rem: b)
  } else {
    let a = (x: rem.x, y: rem.y, w: rem.w, h: rem.h / parts-left)
    let b = (x: rem.x, y: rem.y + a.h, w: rem.w, h: rem.h - a.h)
    (pane: a, rem: b)
  }

  let step(vertical, streak) = {
    let next-streak = streak + 1
    if next-streak >= d - 1 {
      (vertical: not vertical, streak: 0)
    } else {
      (vertical: vertical, streak: next-streak)
    }
  }

  let inset(r) = (
    x: r.x + m,
    y: r.y + m,
    w: calc.max(0pt, r.w - m * 2),
    h: calc.max(0pt, r.h - m * 2),
  )

  layout(size => {
    let packed = range(n).fold(
      (
        rects: (),
        rem: (x: 0pt, y: 0pt, w: size.width, h: size.height),
        vertical: true,
        streak: 0,
      ),
      (acc, i) => {
        if i == n - 1 {
          (rects: acc.rects + (acc.rem,), rem: acc.rem, vertical: acc.vertical, streak: acc.streak)
        } else {
          let parts-left = calc.min(d - acc.streak, n - i)
          let next-split = split(acc.rem, acc.vertical, parts-left)
          let next = step(acc.vertical, acc.streak)
          (
            rects: acc.rects + (next-split.pane,),
            rem: next-split.rem,
            vertical: next.vertical,
            streak: next.streak,
          )
        }
      },
    )

    box(width: size.width, height: size.height)[
      #for i in range(n) {
        let r = inset(packed.rects.at(i))
        let body = if i < bodies.len() { bodies.at(i) } else { [] }
        let pane-body = if colors == none {
          pane-fn[#body]
        } else {
          pane-fn.with(fill: pick-fill(i))[#body]
        }
        place(top + left, dx: r.x, dy: r.y)[
          box(width: r.w, height: r.h)[#pane-body]
        ]
      }
    ]
  })
}
