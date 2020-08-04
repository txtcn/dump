#!/usr/bin/env coffee

Out = require '@/txtcn/out'
req = require '@/lib/req'
path = require 'path'
chalk = require 'chalk'
{PATH} = require '@/config'
DIRPATH = path.join(PATH.DATA,path.basename(__filename[..-8]))
out = Out(DIRPATH)

dump_post = (id, data) =>
  post_url = "http://dwnews.com/-/"+id
  {title, publishTime,publishUrl} = data
  console.log title, post_url
  ex = await req.ex(encodeURI publishUrl)
  html = ex.one("<article {}</article>")
  if html
    pos = html.indexOf(">")+1
    html = html[pos..]
    pos = html.indexOf('href="/tag')
    if pos > 0
      pos2 = html.lastIndexOf("</div>", pos)
      while 1
        html = html[...pos]
        pos = html.lastIndexOf("<div", pos)
        if pos2 >= pos
          break
    html = html.replace(/<div class\=\"view-tracker\"><\/div>/g,'')
    html = html.replace(/<span class\=\"view\-tracker\-inline\"><\/span>/g,'')
    html = html.replace(/<a[^>]+class\=\"[^"]*\bhbsase\b[^"]*\".*<\/a>/g,'')
    html = html.replace(/ class\=\"[^"]*\"/g,'')
    html = html.replace(/ style\=\"[^"]*\"/g,'')
    html = html.replace(/ style\=\"[^"]*\"/g,'')
    return out.add(title,post_url,publishTime,html)


dump = ({nextOffset,items})=>
  todo = []
  for {id,type,data} in items
    if type==1
      todo.push await dump_post(id, data)

  for i in await Promise.all(todo)
    if true == i
      return

  await out.done()

  return nextOffset

zone = (id)=>
  _url = "https://prod-site-api.dwnews.com/v2/feed/zone/"+id
  offset = ""
  while 1
    url = _url + offset
    console.log chalk.gray(url)
    try
      r = await req.get url
    catch err
      console.log err
      continue
    offset = await dump(r)
    if offset
      # offset = "?limit=9999&offset="+offset
      offset = "?offset="+offset
    else
      break

module.exports = =>
  for id in [10000117,10000118,10000119,10000120,10000123]
    await zone(id)
  await out.done()

if not module.parent then do =>
  await module.exports()
  process.exit()

