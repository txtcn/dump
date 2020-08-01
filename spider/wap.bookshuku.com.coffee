#!/usr/bin/env coffee
fs = require 'fs-extra'
req = require '@/lib/req'
path = require 'path'
yml_db = require '@/lib/yml_db'
{PATH} = require '@/config'

DIRPATH = path.join(PATH.DATA,path.basename(__filename[..-8]))

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
        console.err err
    li = ex.li '<a href="http://wap.bookshuku.com/bookinfo/{}.html">'
    for i in li
      fs.appendFileSync(
        DIRPATH+".txt"
        "http://txt.bookshuku.com/home/down/txt/id/"+i+"\n"
      )

    DB.set(end, page)

if not module.parent then do =>
  await module.exports()
  process.exit()
