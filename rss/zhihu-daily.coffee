#!/usr/bin/env coffee

module.exports = [
  "http://feeds.feedburner.com/zhihu-daily"
  {
    dir:'知乎日报'
  }
]

module.parent or require("@/txtcn/rss")(...module.exports)
