#!/usr/bin/env coffee

klaw = require 'klaw'
rss = require("@/txtcn/rss")

module.exports = =>
  todo = []
  for await {path} from klaw(__dirname+"/rss")
    if path.endsWith(".coffee")
      [url, option] = require(path)
      todo.push rss(url, option)
  await Promise.all(todo)

if not module.parent then do =>
  await module.exports()
  process.exit()

