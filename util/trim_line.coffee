#!/usr/bin/env coffee

module.exports = (li)=>
  r = []
  for i in li.split("\n")
    s = i.trim()
    if s
      r.push s
  r.join "\n"

