#!/usr/bin/env coffee

path = require 'path'
fs = require 'fs-extra'
load = require '@/txtcn/load'
opencc = new (require('opencc'))('t2s.json')

DAY_SEC = 86400
ARROW = "➜"
ARROW2 = '➔'
RE_ARROW = new RegExp(ARROW,'g')

load_path = (fpath)=>
  if fs.existsSync fpath
    return load(
      path.basename(fpath)
      fs.readFileSync(fpath,'utf8')
    )
  return []

class _Out
  constructor: (@dirpath)->
    @_reset()

  add:(title, url, time, text)->
    if @exist.has(url)
      return
    @exist.add(url)
    t = [
      title.replace(/\n/g," ")
      text
      url.trim().replace(/\n/g," ").replace(/ /g,'+')
    ].map(
      (i)=>
        i.trim().replace(/\t/g,' ').replace(RE_ARROW, ARROW2)
    )
    t.push time
    day = parseInt(time/86400)
    @day[day] = li = @day[day] or []
    li.push t

  done:->
    for day,li of @day
      fpath = path.join(@dirpath, day)
      load_path(fpath).map((x)=>@add(...x))

      li.sort (a,b)=>a[3]-b[3]
      txt = []
      day_sec = 86400*day
      for [title,text,url,time] in li
        txt.push ARROW+(await opencc.convertPromise(title))
        txt.push [url,time-day_sec].join("\t")
        if text
          text = await opencc.convertPromise(text)
          t = []
          for i in text.split("\n")
            i = i.trim()
            if i
              t.push i
          txt.push(t.join("\n"))
      fs.outputFileSync fpath,txt.join('\n')
    @_reset()

  _reset:->
    @day = {}
    @exist = new Set()

module.exports = -> new _Out(...arguments)

