#!/usr/bin/env coffee

module.exports = [
  "https://www.qdaily.com/feed.xml"
  trim : (txt)=>
    txt = txt.replace("<p><img src='http://img.qdaily.com/uploads/20160725026790Msgaji5TilWhj7z4.jpg-w600' alt=''></p>","")
    pos = txt.lastIndexOf(
      '<p>我们还有另一个应用，会在上面更新文章'
    )
    if pos > 0
      txt = txt[...pos]
    txt
]

module.parent or require("@/txtcn/rss")(...module.exports)
