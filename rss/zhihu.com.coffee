#!/usr/bin/env coffee

module.exports = [
  "https://www.zhihu.com/rss"
  {
    dir:'知乎每日精选'
    trim : (txt)=>
      txt = txt.replace(
        /\=\"https:\/\/pic(\d+).zhimg.com/g,
        '="https://pic1.zhimg.com'
      )

      pos = txt.lastIndexOf(
        '<br><br>\n来源：知乎 www.zhihu.com<br>'
      )
      if pos > 0
        txt = txt[...pos]
      txt
  }
]

module.parent or do =>
  [dir, o] = await require("@/txtcn/rss")(...module.exports)
  console.log "1. [#{o.title}](//#{o.link.split("://")[1]}) 👉 [语料库](//github.com/txtcn/data/tree/master/#{dir.split("/").pop()})"
