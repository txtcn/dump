#!/usr/bin/env coffee

Out = require '@/txtcn/out'
req = require '@/lib/req'
path = require 'path'
chalk = require 'chalk'
{PATH} = require '@/config'
DIRPATH = path.join(PATH.DATA,path.basename(__filename[..-8]))
out = Out(DIRPATH)

fetch = (now)=>
  console.log url
  {nextOffset,items} = await req.get url
  for {id,type,data} in items
    if type==1
        post_url = "http://dwnews.com/-/"+id
        {title} = data
        console.log title, post_url

  return nextOffset
#   day = parseInt(now/86400)
#   if result.length
#     todo = []
#     for i in result
#       {timestamp,title,link} = i.contents
#       todo.push do =>
#         # console.log title,chalk.gray(link)
#         ex = await req.ex(link)
#         html = ex.one('<article class="article-with-html"{}</article>')
#         if html
#           pos = html.indexOf(">")+1
#           html = html[pos..]
#           return out.add(title,link,timestamp,html)
#     for i in await Promise.all(todo)
#       if i == true
#         await out.done()
#         process.exit()
#     {timestamp} = result.pop().contents
#     if day != parseInt timestamp/86400
#       await out.done()
#       # global.gc()
#       console.log new Date(timestamp*1000)
#       console.log("内存占用",chalk.green((process.memoryUsage().heapUsed/1024/1024).toFixed(2)))
#     return timestamp
#

module.exports = =>
  _url = "https://prod-site-api.dwnews.com/v2/feed/zone/0"
  offset = ""
  while 1
    url = _url + offset
    try
      offset = await fetch(url)
    catch err
      console.log err
      continue
    offset = "?offset="+offset
  await out.done()

if not module.parent then do =>
  await module.exports()
  process.exit()

