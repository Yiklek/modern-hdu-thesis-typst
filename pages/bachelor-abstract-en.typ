#import "../deps.typ": t4t
#import "../utils/style.typ": font-size, font
#import "../utils/indent.typ": fake-par
#import "../utils/double-underline.typ": double-underline
#import "../utils/invisible-heading.typ": invisible-heading

// 本科生英文摘要页
#let bachelor-abstract-en(
  // documentclass 传入的参数
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  keywords: (),
  outline-title: "ABSTRACT",
  outlined: true,
  anonymous-info-keys: ("author-en", "supervisor-en", "supervisor-ii-en"),
  leading: 1.28em,
  spacing: 1.28em,
  body,
) = {
  // 1.  默认参数
  fonts = font + fonts
  info = (
    title-en: "NJU Thesis Template for Typst",
    author-en: "Zhang San",
    department-en: "XX Department",
    major-en: "XX Major",
    supervisor-en: "Professor Li Si",
  ) + info

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if (is.str(info.title-en)) {
    info.title-en = info.title-en.split("\n")
  }

  // 3.  内置辅助函数
  let info-value(key, body) = {
    if (not anonymous or (key not in anonymous-info-keys)) {
      body
    }
  }

  // 4.  正式渲染
  [
    #pagebreak(weak: true, to: if twoside { "odd" })

    #set text(font: fonts.楷体, size: font-size.fs4)
    #set par(leading: leading, justify: true)
    #show par: set block(spacing: spacing)

    // 标记一个不可见的标题用于目录生成
    #invisible-heading(level: 1, outlined: outlined, outline-title)

    #align(center)[
      #set text(size: font-size.fs2, weight: "bold")

      #double-underline[南京大学本科生毕业论文（设计、作品）英文摘要]
    ]

    #v(6pt)

    THESIS: #info-value("title-en", (("",)+ info.title-en).sum())

    DEPARTMENT: #info-value("department-en", info.department-en)

    SPECIALIZATION: #info-value("major-en", info.major-en)

    UNDERGRADUATE: #info-value("author-en", info.author-en)

    MENTOR: #info-value("supervisor-en", info.supervisor-en) #(if info.supervisor-ii-en != "" [#h(1em) #info-value("supervisor-ii-en", info.supervisor-ii-en)])

    ABSTRACT:

    #[
      #set par(first-line-indent: 2em)

      #fake-par
      
      #body
    ]

    #v(1em)

    KEYWORDS: #(("",)+ keywords.intersperse("; ")).sum()
  ]
}