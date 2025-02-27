#import "../deps.typ": outrageous
#import "../utils/invisible-heading.typ": invisible-heading
#import "../utils/style.typ": font-size, font

// 本科生目录生成
#let bachelor-outline-page(
  // documentclass 传入参数
  twoside: false,
  fonts: (:),
  // 其他参数
  depth: 4,
  title: "目录",
  outlined: true,
  title-vspace: 1em,
  title-text-args: auto,
  // 引用页数的字体，这里用于显示 Times New Roman
  reference-font: auto,
  reference-size: font-size.fs4,
  // 字体与font-size
  font: auto,
  size: (font-size.fs4, font-size.fs4),
  // 垂直间距
  vspace: (8pt, 8pt),
  indent: (0pt, 18pt, 28pt, 38pt),
  // 一级标题不显示点号
  fill: (auto, auto),
  ..args,
) = {
  // 1.  默认参数
  fonts = font + fonts
  if (title-text-args == auto) {
    title-text-args = (font: fonts.黑体, size: font-size.FS3, weight: "bold")
  }
  // 引用页数的字体，这里用于显示 Times New Roman
  if (reference-font == auto) {
    reference-font = fonts.songti
  }
  // 字体与字号
  if (font == auto) {
    font = (fonts.songti, fonts.songti)
  }

  // 2.  正式渲染
  pagebreak(weak: true, to: if twoside { "odd" })

  // 默认显示的字体
  set text(font: reference-font, size: reference-size)
  v(font-size.FS3 * 2)
  {
    set align(center)
    text(..title-text-args, title)
    // 标记一个不可见的标题用于目录生成
    invisible-heading(level: 1, outlined: outlined, title)
  }
  v(font-size.FS3)

  v(title-vspace)

  show outline.entry: outrageous.show-entry.with(
    // 保留 Typst 基础样式
    ..outrageous.presets.typst,
    body-transform: (level, it) => {
      // 设置字体和字号
      set text(
        font: font.at(calc.min(level, font.len()) - 1),
        size: size.at(calc.min(level, size.len()) - 1),
      )
      // 计算缩进
      let indent-list = indent + range(level - indent.len()).map((it) => indent.last())
      let indent-length = indent-list.slice(0, count: level).sum()
      h(indent-length) + it
    },
    vspace: vspace,
    fill: fill,
    ..args,
  )

  // 显示目录
  outline(title: none, depth: depth)

}