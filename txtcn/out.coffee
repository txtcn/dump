#!/usr/bin/env coffee

path = require 'path'
fs = require 'fs-extra'
load = require './load'
{t2s} = require 'chinese-s2t'

# { DictSource, Converter } = require('wasm-opencc')
# dictSource = new DictSource('t2s.json')
# opencc = undefined
# dictSource.get().then (args)=>
#   opencc = new Converter(...args)


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

format = (i)=>
  i.trim().replace(/\t/g,' ').replace(RE_ARROW, ARROW2)

class _Out
  constructor: (@dirpath)->
    @_reset()

  load:(day)->
    if not (day of @day)
      @day[day] = []
      for i in load_path(@_path day)
        @add(...i)

  add:(title, url, time, text)->
    day = parseInt(time/86400)
    @load(day)
    url = format url.trim().replace(/\n/g," ").replace(/ /g,'+')
    is_exist =  url of @exist
    t = [
      title.replace(/\n/g," ")
      text
    ]
    for i,_ in t
      t[_] = i.trim().replace(/\t/g,' ').replace(RE_ARROW, ARROW2)
    t.push time
    @exist[url] = t
    if not is_exist
      @day[day].push url
    return is_exist

  _path:(day)->
    path.join(@dirpath, ""+day)

  done:->
    exist = @exist
    for day,li of @day
      post_li = []
      for url in li
        post_li.push [url].concat(exist[url])

      post_li.sort (a,b)=>a[3]-b[3]
      txt = []
      day_sec = 86400*day
      for [url,title,text,time] in post_li
        txt.push ARROW+(t2s(title))
        txt.push [url,time-day_sec].join("\t")
        if text
          text = t2s(text)
          t = []
          for i in text.split("\n")
            i = i.trim()
            if i
              t.push i
          txt.push(t.join("\n"))
      fs.outputFileSync @_path(day),txt.join('\n')
    @_reset()

  _reset:->
    @day = {}
    @exist = {}

module.exports = -> new _Out(...arguments)

