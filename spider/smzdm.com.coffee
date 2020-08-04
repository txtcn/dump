#!/usr/bin/env coffee

Out = require '@/txtcn/out'
req = require '@/lib/req'
path = require 'path'
chalk = require 'chalk'
{PATH} = require '@/config'
DIRPATH = path.join(PATH.DATA,path.basename(__filename[..-8]))
out = Out(DIRPATH)

dump = (title, url, time)=>
  ex = await req.ex url
  html = ex.one('<article {}</article>')
  console.log chalk.gray((new Date(time*1000).toISOString())[..9]), title, chalk.gray(url)
  pos = html.indexOf('</div>') + 6
  pos_end = html.lastIndexOf('<div class="interests_statement">')
  if pos_end < 0
    pos_end = html.indexOf '<input type="hidden"'
  html = html[pos...pos_end].trim()
  if html.startsWith '<blockquote'
    pos = html.indexOf('</blockquote>')
    html = html[pos+13..]
  if html
    return out.add(title,url,time,html)

module.exports = =>
  page = 0
  while true
    url = "https://post.smzdm.com/json_more/?tab_id=zuixin&filterUrl=zuixin&p=#{++page}"
    {data} = await req.get(url)
    todo = []
    preday = 0
    if data.length
      for {title,time_sort,article_url} in data
        todo.push dump title,article_url,time_sort
        day = parseInt time_sort/86400
      for i in await Promise.all todo
        if i == true
          return
      if day != preday
        await out.done()
        preday = day
      # global.gc()
      # console.log("内存占用",chalk.green((process.memoryUsage().heapUsed/1024/1024).toFixed(2)))
    else
      break

if not module.parent then do =>
  await module.exports()
  await out.done()
  process.exit()

