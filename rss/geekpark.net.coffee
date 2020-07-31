#!/usr/bin/env coffee

module.exports = [
  "http://www.geekpark.net/rss"
]

module.parent or do =>
  [dir, o] = await require("@/txtcn/rss")(...module.exports)
  console.log "1. [#{o.title}](//#{o.link.split("://")[1]}) 👉 [语料库](//github.com/txtcn/data/tree/master/#{dir.split("/").pop()})"
