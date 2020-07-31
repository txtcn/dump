#!/usr/bin/env coffee

fs = require 'fs-extra'
yaml = require 'js-yaml'
FeedMe = require 'feedme'
Out = require './out'
axios = require '@/lib/axios'
path = require 'path'
{PATH} = require '@/config'

parse = (xml)=>
  f = new FeedMe(true)
  f.write(xml)
  f.done()

INFO = "title link description".split(" ")

module.exports = (rss, option)->
  {dir,trim} = option or {}

  if not dir
    dir = require('url').parse(rss).host
    if dir.startsWith("www.")
      dir = dir[4..]

  dir = path.join(PATH.DATA, dir)
  out = Out(dir)

  {items} = o = parse(await axios.get(rss))

  info = {rss}
  for i in INFO
    if i of o
      info[i] = o[i]

  await fs.outputFile path.join(dir,"rss.yml"), yaml.dump(info)

  for item in items
    html = item['content:encoded']

    {pubdate, published, link, title, text, description, content} = item
    time = Math.round(new Date(pubdate or published)/1000)
    if link.href
      link = link.href

    html = html or content?.text or text?.trim() or description
    if trim
      html = await trim(html, item)

    out.add(
      title
      link
      time
      html
    )
  await out.done()
  [
    dir
    o
  ]
