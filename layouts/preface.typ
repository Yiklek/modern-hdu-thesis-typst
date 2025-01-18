#import "../utils/style.typ": font-size, font
#import "../utils/custom-numbering.typ": custom-numbering
#import "../utils/custom-heading.typ": heading-display, active-heading, current-heading
#import "../utils/style.typ": font-size, font
// 前言，重置页面计数器
#let preface(
  // documentclass 传入的参数
  twoside: false,
  // 其他参数
  numbering: ("I", "1", "I"),
  header: auto,
  ..args,
  it,
) = {
  // 分页
  if (twoside) {
    pagebreak() + " "
  }
  counter(page).update(0)
  let h = context {
      
      // let cur-heading = current-heading(level: 1, loc)
      set text(font: font.songti, size: font-size.FS5, weight: "regular")
      set align(center)
      stack(
          [杭州电子科技大学硕士学位论文],
          v(0.25em),
          line(length: 100%, stroke: 0.5pt + black),
      )
    }

  let preface_numbering = "I"
  set page(
    numbering: preface_numbering,
    header: if header == auto { h } else {none}, 
    footer: context [
    #set text(font: font.songti, size: font-size.fs5, weight: "regular")
    #set align(center)
    #counter(page).display(preface_numbering)
  ])
  it
}
