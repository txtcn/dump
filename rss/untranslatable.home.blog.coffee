#!/usr/bin/env coffee

module.exports = [
  "https://untranslatable.home.blog/feed/"
]

module.parent or require("@/txtcn/rss")(...module.exports)
