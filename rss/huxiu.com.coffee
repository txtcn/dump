#!/usr/bin/env coffee

module.exports = [
  "https://www.huxiu.com/rss/0.xml"
  trim : (txt)=>
    pos = txt.lastIndexOf(
      '<p><a href="http://huxiu.link/ulxE"><strong>下载虎嗅APP</strong></a>'
    )
    if pos > 0
      txt = txt[...pos]
    txt
]

module.parent or require("@/txtcn/rss")(...module.exports)
