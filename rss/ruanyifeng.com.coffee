#!/usr/bin/env coffee

module.exports = [
  "http://www.ruanyifeng.com/blog/atom.xml"
  trim : (txt)=>
    pos = txt.lastIndexOf(
      '<p>（完）</p>'
    )
    if pos > 0
      txt = txt[...pos]
    txt
]

module.parent or require("@/txtcn/rss")(...module.exports)
