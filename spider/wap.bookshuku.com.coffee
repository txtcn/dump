#!/usr/bin/env coffee
fs = require 'fs-extra'
req = require '@/lib/req'
path = require 'path'
yml_db = require '@/lib/yml_db'
{PATH} = require '@/config'
wget = require('node-wget-promise')

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
    for i in li
      [id, name] = i.split('.html">')
      [kind, name] = name.split("<b>")
      [name, author] = name.split("</b>")
      author = author.split(">").pop()
      kind = kind.split("[").pop().split("]")[0]
      url = "http://txt.bookshuku.com/home/down/txt/id/"+i
      await wget(
        url
        output:path.join(
          DIRPATH
          kind
          name.replace(":","：")+"_"+author
        )
      )
      console.log kind, name, author
      # fs.appendFileSync(
      #   DIRPATH+".txt"
      # )
      #
    DB.set(end, page)

if not module.parent then do =>
  await module.exports()
  process.exit()
