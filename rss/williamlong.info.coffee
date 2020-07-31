#!/usr/bin/env coffee

module.exports = [
  "https://www.williamlong.info/rss.xml"
]

module.parent or require("@/txtcn/rss")(...module.exports)
