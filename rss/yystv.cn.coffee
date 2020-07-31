#!/usr/bin/env coffee

module.exports = [
  "https://www.yystv.cn/rss/feed"
]

module.parent or require("@/txtcn/rss")(...module.exports)
