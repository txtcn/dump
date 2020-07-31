#!/usr/bin/env coffee
fs = require 'fs-extra'
req = require '@/lib/req'
path = require 'path'
https = "https:"
yml_db = require '@/lib/yml_db'
dump = require('./mt.sohu.com/dump')
spawn = require('await-spawn')
chalk = require 'chalk'
{PATH} = require '@/config'

DIRPATH = path.join(PATH.DATA,path.basename(__filename[..-8]))

MAIL2ID = yml_db DIRPATH

class FetchSite
  constructor: ->
    @exist = new Set()

  get:(site_id, text)->
    if @exist.has site_id
      return
    @exist.add site_id
    if fs.existsSync(path.join(DIRPATH,text))
      await dump(...arguments)
    else
      await spawn('./mt.sohu.com/dump.coffee', Array.from(arguments))
    console.log chalk.greenBright(text)
    #dump(...arguments)
    # console.log to_fetch
    # console.log text
    # db.set(id, title, publicTime)

    # console.log kind,text
    # console.log r

FETCH_SITE = new FetchSite()
fetch_site = FETCH_SITE.get.bind(FETCH_SITE)

fetch = (el,limit=1)=>
  url = https+el.href
  kind = el.text
  page = 0
  while page++ < limit
    page_url = url+"?p="+page
    $ = await req.jq page_url
    console.log chalk.yellowBright(kind),chalk.gray(page_url)
    for i from $("#main-news .news-box .other .name a")
      {href,text} = i
      mail = Buffer.from(href[31..],'base64').toString('utf-8')
      if text
        r = MAIL2ID.get mail
        if not r
          ex = await req.ex(href)
          id = parseInt ex.one('author_id : "{}"')
          if id
            r = [id,text]
            MAIL2ID.set mail, r
            # console.log text+" "+href+"\n"
      if r
        await fetch_site(...r)


module.exports = =>
  $ = await req.jq https+"//mt.sohu.com"
  todo = []
  for i from $("#channel-list a")
    todo.push fetch(i)
    #todo.push fetch(i, 999)
  await Promise.all(todo)

if not module.parent then do =>
  await module.exports()
  process.exit()

