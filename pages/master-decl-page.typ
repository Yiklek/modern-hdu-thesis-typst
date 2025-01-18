#import "../utils/indent.typ": indent
#import "../utils/style.typ": font-size, font

// 研究生声明页
#let master-decl-page(
  anonymous: false,
  twoside: false,
  fonts: (:),
) = {
  // 0. 如果需要匿名则短路返回
  if anonymous {
    return
  }
  
  // 1.  默认参数
  fonts = font + fonts
  
  // 2.  正式渲染
  pagebreak(weak: true, to: if twoside { "odd" })
  
  v(25pt)
  
  align(center, text(font: fonts.songti, size: font-size.FS3, weight: "bold")[
    杭州电子科技大学 \
    学位论文原创性声明和使用授权说明 \
    // #linebreak()
  ])
  v(30pt)
  align(center, text(font: fonts.songti, size: font-size.FS4, weight: "bold")[
    原创性声明
  ])
  
  v(10pt)
  
  block[
    #set text(font: fonts.songti, size: font-size.fs4)
    #set par(justify: true, first-line-indent: 2em, leading: 1em)
    
    #indent 本人郑重声明：
    所呈交的学位论文，是本人在导师的指导下，独立进行研究工作所取得的成果。除文中已经注明引用的内容外，本论文不含任何其他个人或集体已经发表或撰写过的作品或成果。对本文的研究做出重要贡献的个人和集体，均已在文中以明确方式标明。\
    #indent 申请学位论文与资料若有不实之处，本人承担一切相关责任。\
    #linebreak()
  ]
  
  align(left)[
    #set text(font: fonts.songti, size: font-size.fs4)
    // #set text(font: fonts.黑体, size: font-size.fs4)
     
    论文作者签名: #h(8em)
    日期：#h(2.5em) 年 #h(2em) 月 #h(2em) 日
  ]
  
   
  v(40pt)
  
  align(center, text(font: fonts.songti, size: font-size.FS4, weight: "bold")[
    学位论文使用授权说明
  ])
  text(font: fonts.songti, size: font-size.fs5, weight: "bold", linebreak())
  
  
  block[
    #set text(font: fonts.songti, size: font-size.fs4)
    #set par(justify: true, first-line-indent: 2em, leading: 1em)
    
    #indent 本人完全了解杭州电子科技大学关于保留和使用学位论文的规定，即：研究生在校攻读学位期间论文工作的知识产权单位属杭州电子科技大学。本人保证毕业离校后，发表论文或使用论文工作成果时署名单位仍然为杭州电子科技大学。学校有权保留送交论文的复印件，允许查阅和借阅论文；学校可以公布论文的全部或部分内容，可以允许采用影印、缩印或其它复制手段保存论文。（保密论文在解密后遵守此规定）\
    #(linebreak() * 4)
  ]
  
  align(left)[
    #set text(font: fonts.songti, size: font-size.fs4)
     
    论文作者签名: #h(8em)
    日期：#h(2.5em) 年 #h(2em) 月 #h(2em) 日
    
    #linebreak()
    #linebreak()
    
    指导老师签名: #h(8em)
    日期：#h(2.5em) 年 #h(2em) 月 #h(2em) 日
  ]
}
