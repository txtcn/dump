#!/usr/bin/env coffee

Out = require '@/txtcn/out'
axios = require '@/lib/axios'
extract = require '@/lib/extract'
he = require 'he'
path = require 'path'
{PATH} = require '@/config'

fetch = (id)=>
  url = "https://www.solidot.org/story?sid=#{id}"
  try
    html = await axios.get url
  catch err
    # console.log err
    return
  ex = extract(html)
  json = ex.one("""<script type="application/ld+json">{}</script>""")
  json = json.split("\n")
  for i in json
    i = i.trim()
    if i.startsWith '"title":'
      title = i[10...-2]
    else if i.startsWith '"pubDate": '
      pubDate = i[12...-1]
  if not title
    return
  # {title,pubDate} = json
  time = (new Date(pubDate)/1000+8*3600)
  html = ex.one """<div class="p_mainnew">{}<img src="https://img.solidot.org//0/446/liiLIZF8Uh6yM.jpg"""
  [title,url,time,html]

module.exports = =>
  id = 1
  preday = undefined
  out = Out(path.join(PATH.DATA,"solidot.org"))
  while id < 65017
    r = await fetch(id++)
    if not r
      continue
    day = parseInt r[2]/86400
    if day != preday
      preday = day
      await out.done()
    console.log r[..1].join("\t")
    out.add(...r)
  await out.done()

if not module.parent then do =>
  await module.exports()
  process.exit()
