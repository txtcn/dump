#!/usr/bin/env coffee

Out = require '@/txtcn/out'
req = require '@/lib/req'
path = require 'path'
chalk = require 'chalk'
{PATH} = require '@/config'
DIRPATH = path.join(PATH.DATA,path.basename(__filename[..-8]))
out = Out(DIRPATH)

fetch = (now)=>
  url = "https://www.gelonghui.com/api/channels/web_home_page/articles/v4?timestamp=#{now}&loaded=0"
  {result} = await req.get url
  day = parseInt(now/86400)
  if result.length
    todo = []
    for i in result
      todo.push do =>
        {timestamp,title,link} = i.contents
        console.log title,chalk.gray(link)
        ex = await req.ex(link)
        html = ex.one('<article class="article-with-html"{}</article>')
        if html
          pos = html.indexOf(">")+1
          html = html[pos..]
          return out.add(title,link,timestamp,html)
    for i in await Promise.all(todo)
      if i == true
        await out.done()
        process.exit()
    {timestamp} = result.pop().contents
    if day != parseInt timestamp/86400
      await out.done()
    return timestamp


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
  await out.done()

if not module.parent then do =>
  await module.exports()
  process.exit()

