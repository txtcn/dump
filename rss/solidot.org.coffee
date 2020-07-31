#!/usr/bin/env coffee

module.exports = [
  "https://www.solidot.org/index.rss"
  trim : (txt)=>
    pos = txt.lastIndexOf(
      '<img src="https://img.solidot.org//0/446/liiLIZF8Uh6yM.jpg"'
    )
    if pos > 0
      txt = txt[...pos]
    txt
]

module.parent or require("@/txtcn/rss")(...module.exports)
