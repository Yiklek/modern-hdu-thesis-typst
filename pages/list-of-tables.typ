#import "../deps.typ": outrageous, i-figured
#import "../utils/invisible-heading.typ": invisible-heading
#import "../utils/style.typ": font-size, font

// 表格目录生成
#let list-of-tables(
  // documentclass 传入参数
  twoside: false,
  fonts: (:),
  // 其他参数
  title: "表格目录",
  outlined: false,
  title-vspace: 32pt,
  title-text-args: auto,
  // caption 的 separator
  separator: "  ",
  // 字体与字号
  font: auto,
  size: font-size.fs4,
  // 垂直间距
  vspace: 14pt,
  // 是否显示点号
  fill: auto,
  ..args,
) = {
  // 1.  默认参数
  fonts = font + fonts
  if (title-text-args == auto) {
    title-text-args = (font: fonts.songti, size: font-size.FS3, weight: "bold")
  }
  // 字体与字号
  if (font == auto) {
    font = fonts.songti
  }

  // 2.  正式渲染
  pagebreak(weak: true, to: if twoside { "odd" })

  // 默认显示的字体
  set text(font: font, size: size)

  {
    set align(center)
    text(..title-text-args, title)
    // 标记一个不可见的标题用于目录生成
    invisible-heading(level: 1, outlined: outlined, title)
  }

  v(title-vspace)

  show outline.entry: outrageous.show-entry.with(
    // 保留 Typst 基础样式
    ..outrageous.presets.typst,
    body-transform: (level, it) => {
      // 因为好像没找到 separator 的参数，所以这里就手动寻找替换了
      if (it.has("children") and it.children.at(3, default: none) == [#": "]) {
        it.children.slice(0, 3).sum() + separator + it.children.slice(4).sum()
      } else {
        it
      }
    },
    vspace: (vspace,),
    fill: (fill,),
  )

  // 显示目录
  i-figured.outline(target-kind: table, title: none)

  // 手动分页
  if (twoside) {
    pagebreak() + " "
  }
}
