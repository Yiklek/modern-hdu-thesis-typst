#import "../utils/datetime-display.typ": datetime-display, datetime-en-display
#import "../utils/justify-text.typ": justify-text
#import "../utils/style.typ": font-size, font

// 硕士研究生封面
#let master-cover(
  // documentclass 传入的参数
  doctype: "master",
  degree: "academic",
  nl-cover: false,
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  stoke-width: 0.5pt,
  min-title-lines: 2,
  min-reviewer-lines: 5,
  info-inset: (x: 0pt, bottom: 0.5pt),
  info-key-width: 72pt,
  info-column-gutter: 1em,
  info-row-gutter: 12pt,
  anonymous-info-keys: (
    "student-id",
    "author",
    "author-en",
    "supervisor",
    "supervisor-en",
    "supervisor-ii",
    "supervisor-ii-en",
    "chairman",
    "reviewer",
  ),
  datetime-display: datetime-display,
  datetime-en-display: datetime-en-display,
) = {
  // 1.  默认参数
  fonts = font + fonts
  info = (
    title: ("基于 Typst 的", "杭州电子科技大学学位论文"),
    grade: "20XX",
    student-id: "1234567890",
    author: "张三",
    department: "某学院",
    major: "某专业",
    supervisor: ("李四", "教授"),
    submit-date: datetime.today(),
  ) + info
   
  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }
  if type(info.title-en) == str {
    info.title-en = info.title-en.split("\n")
  }
  // 2.2 根据 min-title-lines 和 min-reviewer-lines 填充标题和评阅人
  info.title = info.title + range(min-title-lines - info.title.len()).map((it) => "　")
  info.reviewer = info.reviewer + range(min-reviewer-lines - info.reviewer.len()).map((it) => " ")
  // 2.3 处理日期
  assert(type(info.submit-date) == datetime, message: "submit-date must be datetime.")
  if type(info.defend-date) == datetime {
    info.defend-date = datetime-display(info.defend-date)
  }
  if type(info.confer-date) == datetime {
    info.confer-date = datetime-display(info.confer-date)
  }
  if type(info.bottom-date) == datetime {
    info.bottom-date = datetime-display(info.bottom-date)
  }
  // 2.4 处理 degree
  if (info.degree == auto) {
    if (doctype == "doctor") {
      info.degree = "工程博士"
    } else {
      info.degree = "工程硕士"
    }
  }
   
  let make-key(
    font,
    fontsize,
    fontweight: "regular",
    info-inset: info-inset,
    with-tail: false,
    body,
  ) = {
    set text(font: font, size: fontsize, weight: fontweight)
    rect(
      width: 100%,
      inset: info-inset,
      stroke: none,
      justify-text(with-tail: with-tail, body),
    )
  }
  let make-value(
    font,
    fontsize,
    fontweight: "regular",
    info-inset: info-inset,
    no-stroke: false,
    text-align: center,
    body,
  ) = {
    set align(text-align)
    set text(
      font: font,
      size: fontsize,
      weight: fontweight,
      bottom-edge: "descender",
    )
    rect(
      width: 100%,
      inset: info-inset,
      stroke: if no-stroke { none } else { (bottom: stoke-width) },
      body,
    )
  }
   
  let title-key = make-key.with(fonts.songti, font-size.fs2, fontweight: "bold", with-tail: true, "题目")
  let title-value = make-value.with(fonts.楷体, font-size.fs2)

  let date-key = make-key.with(fonts.songti, font-size.FS4, fontweight: "bold", "完成日期")
   
  let date-value = make-value.with(fonts.楷体, font-size.FS4)
   
  let info-key = make-key.with(fonts.songti, font-size.FS3, fontweight: "bold")
   
  let make-info-value = make-value.with(fonts.楷体, font-size.FS3)
   
  let anonymous-text(key, body) = {
    if (anonymous and (key in anonymous-info-keys)) {
      "██████████"
    } else {
      body
    }
  }
  let info-value(key, body) = {
    make-info-value(anonymous-text(key, body))
  }
   
  // 4.  正式渲染
  pagebreak(weak: true, to: if twoside { "odd" })
   
  // 居中对齐
  set align(center)
   
  // 匿名化处理去掉封面标识
  v(6pt)
  if (anonymous) {
    v(106.5pt)
  } else {
    // 封面图标
    image("../assets/hdu-emblem.png", width: 14.95cm, height: 2.83cm)
  }
  v(25pt)
   
   
  // 将中文之间的空格间隙从 0.25 em 调整到 0.5 em

  text(
    size: font-size.FS2,
    font: fonts.songti,
    spacing: 200%,
    weight: "bold",
    (if type == "doctor" { "博士学位论文" } else { "硕士学位论文" })
    .codepoints().intersperse(" ").sum(),
  )
  

   
  v(50pt)
  block(width: 350pt, grid(
    columns: (info-key-width, 1fr),
    column-gutter: info-column-gutter,
    row-gutter: info-row-gutter,
    title-key(),
    ..info.title.map((s) => title-value(s)).intersperse(" "),
  ))
  
   
  v(70pt)
   
  block(width: 320pt, grid(
    columns: (info-key-width, 1fr),
    column-gutter: info-column-gutter,
    row-gutter: info-row-gutter,
    info-key("研究生"),
    info-value("author", info.author),
    ..(if degree == "professional" {
      ({
        set text(font: fonts.楷体, size: font-size.FS3, weight: "bold")
        move(dy: 0.3em, scale(x: 55%, box(width: 10em, "专业学位类别（领域）")))
      }, info-value("major", info.degree + "（" + info.major + "）"),)
    } else { (info-key("专业"), info-value("major", info.major),) }),
    info-key("指导教师"),
    info-value("supervisor", info.supervisor.intersperse(" ").sum()),
    ..(if info.supervisor-ii != () {
      (
        info-key(" "),
        info-value("supervisor-ii", info.supervisor-ii.intersperse(" ").sum()),
      )
    } else { () }),
  ))
   
  v(120pt)
   
  block(width: 320pt, grid(
    columns: (info-key-width, 1fr),
    column-gutter: info-column-gutter,
    row-gutter: info-row-gutter,
    date-key(),
    date-value(datetime-display(info.submit-date)),
  ))
   
   

  // 第三页中文封面
  pagebreak()
   
  set align(center)

  place(
    top + center, 
    dy: font-size.FS2 * 2,
    text(font: font.songti, size: font-size.FS2)[杭州电子科技大学硕士学位论文]
  )
  v(font-size.fs4 * 1.5 * 6)
  let make_title = {
    let title_font = font.heiti
    title_font.insert(0, "Times New Roman")
    for t in info.title {
      text(font: title_font, size: font-size.fs1, weight: "bold")[#t]
      linebreak()
      v(font-size.fs1 * 0.5)
    }
  }

  place(
    top + center, 
    dy: font-size.FS2 * 8,
    make_title
  )

  let title-page-key = make-key.with(fonts.songti, font-size.FS3, fontweight: "bold", with-tail: true)
  let make-title-page-value = make-value.with(fonts.楷体, font-size.FS3, no-stroke: true, text-align: left)
  let title-page-value(key, value) = {
    make-title-page-value(anonymous-text(key, value))
  }

  place(
    center + horizon, 
    dx: -30pt,
    dy: 100pt,
  block(width: 180pt, grid(
    columns: (info-key-width, 1fr),
    column-gutter: info-column-gutter,
    row-gutter: info-row-gutter,
    title-page-key("研究生"),
    title-page-value("author", info.author),
    title-page-key("指导教师"),
    title-page-value("supervisor", info.supervisor.intersperse(" ").sum()),
  ))
  )

  place(
    bottom + center, 
    text(font: fonts.楷体, size: font-size.FS4, datetime-display(info.submit-date))
  )
   
   
  // 第四页空白
  pagebreak()
  // 第五页英文封面页
   
  // v(40pt)
  set par(leading: font-size.FS2)
  place(
    top + center, 
    dy: 40pt,
    text(font: fonts.songti, size: font-size.FS2, weight: "bold")[
      Dissertation Submitted to Hangzhou Dianzi University
      for the Degree of Master
    ]
    )
  set par(leading: 1.2em)
  set text(font: fonts.songti, size: font-size.fs4)
  // v(5em)
  place(
    top + center, 
    dy: 160pt,
    text(
      font: fonts.songti,
      size: font-size.fs1,
      weight: "bold",
      info.title-en.intersperse("\n").sum(),
    )
  )
   
   
   
  set par(leading: 0.5em)
  set text(font: fonts.songti, size: font-size.fs4)
   
  place(
    center + horizon, 
    dy: 80pt, 
  block(width: 280pt, grid(
    columns: (info-key-width, 1fr),
    column-gutter: info-column-gutter,
    row-gutter: info-row-gutter,
    title-page-key("Candidate"),
    title-page-value("author", info.author-en),
    title-page-key("Supervisor"),
    title-page-value("supervisor", info.supervisor-en),
  ))
  )
   
  v(3em)
  place(
    bottom + center, 
    text(
      font: fonts.songti,
      size: font-size.FS4,
      weight: "bold",
      datetime-en-display(info.submit-date),
    )
  )
}
