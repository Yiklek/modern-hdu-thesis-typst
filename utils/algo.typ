#import "../deps.typ": *

#let number-in-chapter = (kind, kind-numbering) => {
  context {
    let start = query(figure.where(kind: kind)
      .before(query(heading.where(level: 1).before(here())).last().location())
      )
    let end = query(figure.where(kind: kind).before(here()))
    numbering(kind-numbering, ..(counter(heading).at(here()).at(0), end.len() - start.len()))
  }
}

#let algo-title = (title, supplement: "算法", kind: "algorithm", title-numbering: "1.1", sep: ": ") => {
  let numbers = number-in-chapter(kind, title-numbering)
  strong[#supplement#numbers#sep#title]
}

#let algorithm = (title, body) => {
  figure(kind: "algorithm", supplement: "算法",
    lovelace.pseudocode-list(
      booktabs: true, stroke: none, 
      title: algo-title(title), 
      line-gap: .5em,
      indentation: .5em,
      body, 
      )
  )
}