#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#let today(fmt: "[month repr:long] [day], [year]") = datetime.today().display(fmt)
#let date(month, day, year: 2026, fmt: "[month repr:short] [day]") = datetime(month: month, day: day, year: year).display(fmt)

#let infty = math.infinity
#let int = math.integral

#let hw(title: "", class: "", doc) = {
  set par(first-line-indent: 0.7em)
  show link: it => underline(text(fill: blue)[#it])
  set document(title: "Grant Yang - " + title, author: "Grant Yang")

  show raw.where(block: false): it => box(
    fill: rgb("#e9eef8"),
    outset: (y: 0.25em),
    inset: (x: 0.25em, y: 0em),
    text(fill: rgb("#4e4f52"), it)
  )

  show raw.where(block: true): it => block(
    width: 100%,
    fill: rgb("#e9eef8"),
    outset: (y: 0.25em),
    inset: (x: 0.5em, y: 0.5em),
    text(fill: rgb("#4e4f52"), it)
  )

  set enum(indent: 1em, numbering: "1.a.")
  let prep = if class == "" { "" } else [#class: ]
 
  [
    #set align(center)
    #[
      #set text(12.5pt)
      *#prep#title*
    ]
    
    #today() \
    Grant Yang - _2561095_
  ]
  
  doc
}

#let problem = {
  set align(center)
  set text(8pt)
  counter("problem").step()
  set heading(numbering: "1")

  show heading: it => {
    if it.supplement == [Problem] {
      context [_Problem #(counter("problem").display())_]
    } else {
      it
    }
  }
  
  context [
    #v(0.5em)
    #heading([], supplement: [Problem])
    #label("problem" + counter("problem").display())
    #v(-0.5em)
  ]
}

#let compose(a, b) = (..args) => a(b(..args))

#let bmat = math.mat.with(delim: "[")
#let bdmat = compose(math.display, bmat)
#let amat = bmat.with(augment: (vline: -1, stroke: (dash: "dotted")))
#let admat = compose(math.display, amat)
#let imat = math.mat.with(delim: none)
#let idmat = compose(math.display, imat)

#let theorem(num) = [*Theorem #num*]

#let fbox(content) = box(content, stroke: 0.5pt + black, outset: (y: 0.25em), inset: (x: 0.25em))
#let boxed(v) = $#box(v, outset: (y: 0.3em), inset: (x: 0.2em), stroke: 0.5pt + black)$

#let vec = compose(math.arrow, math.bold)
#let span = $serif("span")$
#let newpage = pagebreak
#let implies = math.arrow.r.double.long
#let to = math.arrow
#let wedge = math.and
#let otimes = math.times.o
#let circ = math.compose

#let definitions = state("defs", ())
#let theorems = state("theorems", ())


#let def(num, bod) = {
  definitions.update(x => {
    x.push((num, bod))
    x
  })

  [/ Def #num: #bod]
}

#let deftheorem(num, bod) = {
  theorems.update(x => {
    x.push((num, bod))
    x
  })

  [/ Theorem #num: #bod]
}
