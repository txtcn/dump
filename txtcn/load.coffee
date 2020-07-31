#!/usr/bin/env coffee

split_n = require '@/util/split_n'

module.exports = (day,txt)=>
  day = parseInt(day)
  r = []
  for i in (txt+"\n").split("➜")[1..]
    li = split_n(i,"\n",3)
    [link, time] = li[1].split("\t")
    time = day*86400 + parseInt(time)
    r.push [
      li[0]
      link
      time
      li[2][...-1] # 删除正文结尾的回车
    ]
  r
