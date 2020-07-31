#!/usr/bin/env coffee

cheerio = require('cheerio')
get_outer_html = require 'dom-serializer'

$ = (html)=>
  cheerio.load html

get = (obj, prop) ->
  if not obj
    return
  switch prop
    when "text"
      obj.children[0]?.data
    when "html"
      get_outer_html obj.children
    else
      obj.attribs[prop]

handler = {
  get
}

iter = ->
  for i in @
    yield new Proxy(i, handler)

jq = ($)=>
  ->
    li = $(...arguments)
    new Proxy(
      li
      {
        get:(obj, key, receiver)->
          if key == Symbol.iterator
            iter.bind(obj)
          else
            get(obj[0], key)
            # Reflect.get(obj, key, receiver)
      }
    )
    # proxy['[Symbol.iterator]'] =

module.exports = (html)=>
  jq($ html)

