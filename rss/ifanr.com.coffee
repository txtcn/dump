#!/usr/bin/env coffee

module.exports = [
  "https://www.ifanr.com/feed"
  trim : (txt)=>
    pos = txt.lastIndexOf(
      '<p>#欢迎关注爱范儿官方微信公众号'
    )
    if pos > 0
      txt = txt[...pos]
    txt
]

module.parent or do =>
  [dir, o] = await require("@/txtcn/rss")(...module.exports)
  console.log "1. [#{o.title}](//#{o.link.split("://")[1]}) 👉 [语料库](//github.com/txtcn/data/tree/master/#{dir.split("/").pop()})"
