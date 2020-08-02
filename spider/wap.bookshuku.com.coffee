#!/usr/bin/env coffee
fs = require 'fs-extra'
stream = require('stream')
chalk = require 'chalk'
{promisify} = require('util')
req = require '@/lib/req'
path = require 'path'
yml_db = require '@/lib/yml_db'
{PATH} = require '@/config'


DIRPATH = path.join(PATH.BOOK,path.basename(__filename[..-8]))

DB = yml_db DIRPATH

module.exports = =>
  end = 'end'
  end_page = DB.get(end) or 2846
  for page in [end_page...0]
    console.log page
    url = "http://wap.bookshuku.com/txt/0_0_0_0_default_0_#{page}.html"
    while 1
      try
        ex = await req.ex url
        break
      catch err
        console.error err
    li = ex.li '<a href="http://wap.bookshuku.com/bookinfo/{}</a>'
    todo = []
    for i in li
      [id, name] = i.split('.html">')
      [kind, name] = name.split("<b>")
      [name, author] = name.split("</b>")
      author = author.split(">").pop()
      kind = kind.split("[").pop().split("]")[0]
      url = "http://txt.bookshuku.com/home/down/txt/id/"+id
      output = path.join(
        DIRPATH
        kind
      )
      await fs.mkdirs(output)
      output = path.join(
        output
        id+"_"+name.replace(":","：")+"_"+author+".txt"
      )
      console.log url
      console.log output
      try
        await req.wget(url, output)
      catch err
        console.error chalk.redBright err.response.status + " " + err.response.statusText

    DB.set(end, page)

if not module.parent then do =>
  await module.exports()
  process.exit()
