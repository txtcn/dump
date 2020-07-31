#!/usr/bin/env coffee

module.exports = [
  "https://feeds.appinn.com/appinns/"
  dir:"小众软件"
  trim : (txt)=>
    pos = txt.lastIndexOf(
      '<hr /><h2>相关阅读</h2>'
    )
    if pos > 0
      txt = txt[...pos]
    txt

]

module.parent or do =>
  [dir, o] = await require("@/txtcn/rss")(...module.exports)
  console.log "1. [#{o.title}](//#{o.link.split("://")[1]}) 👉 [语料库](//github.com/txtcn/data/tree/master/#{dir.split("/").pop()})"
