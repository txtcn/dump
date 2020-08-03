#!/usr/bin/env coffee

Out = require '@/txtcn/out'
req = require '@/lib/req'
path = require 'path'
{PATH} = require '@/config'
DIRPATH = path.join(PATH.DATA,path.basename(__filename[..-8]))
out = Out(DIRPATH)

fetch = (now)=>
  url = "https://www.gelonghui.com/api/channels/web_home_page/articles/v4?timestamp=#{now}&loaded=0"
  {result} = await req.get url
  if result.length
    for i in result
      {timestamp,title,link} = i.contents
      console.log title,link
      ex = await req.ex(link)
      html = ex.one('<article class="article-with-html"{}</article>')
      if html
        pos = html.indexOf(">")+1
        html = html[pos..]
        out.add(title,link,timestamp,html)
    return result.pop().contents.timestamp


module.exports = =>
  now = parseInt(new Date()/1000)
  while 1
    try
      t = await fetch(now)
    catch err
      console.log err
      continue
    if not t or t >= now
      break
    now = t - 1

if not module.parent then do =>
  await module.exports()
  process.exit()

