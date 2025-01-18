#import "../deps.typ": i-figured
#import "../utils/style.typ": font-size, font
#import "../utils/custom-numbering.typ": custom-numbering
#import "../utils/custom-heading.typ": heading-display, active-heading, current-heading
#import "../utils/indent.typ": fake-par
#import "../utils/unpairs.typ": unpairs

#let mainmatter(
  // documentclass 传入参数
  twoside: false,
  fonts: (:),
  // 其他参数
  leading: font-size.fs4,
  spacing: (below: 1em),
  justify: true,
  first-line-indent: 2em,
  numbering: custom-numbering.with(first-level: "第1章 ", depth: 4, "1.1 "),
  // 正文字体与字号参数
  text-args: auto,
  // 标题字体与字号
  heading-font: auto,
  heading-size: (font-size.FS3, font-size.fs3, font-size.FS4, font-size.fs4),
  heading-weight: ("medium", "medium", "medium", "medium"),
  heading-top-vspace: (1.5em, 0pt, 0pt, 0pt),
  heading-bottom-vspace: (1em, 0.5em, 0.5em, 0pt),
  heading-pagebreak: (true, false, false, false),
  heading-align: (center, auto),
  // caption 的 separator
  separator: "  ",
  // figure 计数
  show-figure: i-figured.show-figure.with(extra-prefixes: ("algorithm": "algo:")),
  // equation 计数
  show-equation: i-figured.show-equation,
  ..args,
  it,
) = {
  // 0.  标志前言结束
  // fence()
  // 1.  默认参数
  fonts = font + fonts
  if (text-args == auto) {
    text-args = (font: fonts.songti, size: font-size.fs4)
  }
  // 1.1 字体与字号
  if (heading-font == auto) {
    heading-font = (fonts.黑体,)
  }
  // 1.2 处理 heading- 开头的其他参数
  let heading-text-args-lists = args.named().pairs()
    .filter((pair) => pair.at(0).starts-with("heading-"))
    .map((pair) => (pair.at(0).slice("heading-".len()), pair.at(1)))

  // 2.  辅助函数
  let array-at(arr, pos) = {
    arr.at(calc.min(pos, arr.len()) - 1)
  }

  // 3.  设置基本样式
  let page_numbering = "1"
  set page(numbering: page_numbering, footer: context [
    #set text(font: font.songti, size: font-size.fs5, weight: "regular")
    #set align(center)
    #counter(page).display(page_numbering)
  ], 
  header-ascent: 20%
  )
  counter(page).update(1)

  // 3.1 文本和段落样式
  set text(..text-args)
  set par(
    leading: leading,
    justify: justify,
    first-line-indent: first-line-indent,
    spacing: 1em,
  )

  set block(below: spacing.below, breakable: true)
  // 3.2 脚注样式
  show footnote.entry: set text(font: fonts.songti, size: font-size.FS5)
  // 3.3 设置 figure 的编号
  show heading: i-figured.reset-counters.with(extra-kinds:("algorithm",))
  show figure: show-figure
  // 3.4 设置 equation 的编号
  show math.equation.where(block: true): show-equation
  // 3.5 表格表头置顶 + 不用冒号用空格分割
  show figure.where(
    kind: table
  ): set figure.caption(position: top)
  
  let empty = v(0.5em) + fake-par
  show figure: it =>  {
    show figure.caption: set text(font-size.FS5)
    it
    empty
  }

  set figure.caption(separator: separator)
  // 3.6 优化列表显示
  //     术语列表 terms 不应该缩进
  show terms: set par(first-line-indent: 0pt)

  show table: set text(size: 10pt)

  // 4.  处理标题
  // 4.1 设置标题的 Numbering
  set heading(numbering: numbering)
  // 4.2 设置字体字号并加入假段落模拟首行缩进
  show heading: it => {
    set text(
      font: array-at(heading-font, it.level),
      size: array-at(heading-size, it.level),
      weight: array-at(heading-weight, it.level),
      ..unpairs(heading-text-args-lists
        .map((pair) => (pair.at(0), array-at(pair.at(1), it.level))))
    )
    v(array-at(heading-top-vspace, it.level))
    it 
    v(array-at(heading-bottom-vspace, it.level))
    fake-par
  }
  // 4.3 标题居中与自动换页
  show heading: it => {
    if (array-at(heading-pagebreak, it.level)) {
      // 如果打上了 no-auto-pagebreak 标签，则不自动换页
      if ("label" not in it.fields() or str(it.label) != "no-auto-pagebreak") {
        pagebreak(weak: true)
      }
    }
    if (array-at(heading-align, it.level) != auto) {
      set align(array-at(heading-align, it.level))
      it
    } else {
      it
    }
  }

  it
}
