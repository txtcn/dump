#!/usr/bin/env coffee

{PATH} = require '@/config'
he = require('he')
yml_db = require '@/lib/yml_db'
chalk = require 'chalk'
trim_line = require '@/util/trim_line'
Out = require '@/txtcn/out'
path = require 'path'
req = require '@/lib/req'


DIRPATH = path.join(PATH.DATA,path.basename(path.dirname(__filename)))

module.exports = (site_id, text)=>
  dirpath = path.join(DIRPATH, text)
  out = Out(dirpath)
  db = yml_db path.join(dirpath, "meta")
  update = 'update'
  last = db.get update
  page = 1

  to_fetch = []

  `loop: //`
  while 1
    url = "http://v2.sohu.com/author-page-api/author-articles/pc/#{site_id}?pNo=#{page++}"
    console.log url
    r = await req.get(url)
    {pcArticleVOS} = r.data
    if not pcArticleVOS.length
      break
    for {publicTime,id,title} in pcArticleVOS
      to_fetch.push [publicTime,id,he.decode title]
      if publicTime <= last
        `break loop`
    # `break loop`

  to_fetch.sort (a,b)=>a[0]-b[0]
  for [time, id, title] in to_fetch
    u = "http://www.sohu.com/a/#{id}_#{site_id}"
    ex = await req.ex u
    # html = $("#mp-editor").html
    html = ex.one('<article class="article" id="mp-editor">{}</article>')
    if html
      pos = html.indexOf 'href="//www.sohu.com/?strategyid='
      if pos > 0
        html = html[..pos-4]+"</p>"
      pos = html.indexOf 'data-role="original-title"'
      if pos > 0
        pos = html.indexOf '</p>', pos
        html = html[pos+4..]
      pos = html.indexOf '<p>声明：转载此文'
      if pos > 0
        html = html[...pos]
      html = trim_line html
    if html
      out.add(title, u, parseInt(time/1000), html)
  await out.done()
  db.set update, time

not module.parent and do =>
  await module.exports(...process.argv[-2..])

