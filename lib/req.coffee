#!/usr/bin/env coffee
fs = require 'fs-extra'
axios = require './axios'
jq = require './jq'
sleep = require 'await-sleep'
https = "https:"
chalk = require 'chalk'
extract = require './extract'

class Req
  constructor : (@max=10, @interval=100)->
    @n = 0
    @todo = []
    @pre = 0

  ex : ->
    extract await @get ...arguments

  jq : ->
    jq await @get ...arguments

  _lock : (func)->
    now = new Date() - 0
    diff = @interval - (now - @pre)
    @pre = now + Math.max(diff,0)
    if diff > 0
      await sleep diff
    if @n < @max
      ++ @n
      try
        return await func()
      finally
        @_next()
    else
      new Promise (resolve)=>
        @todo.push [resolve, func]

  get : -> @_lock =>
    axios.get(...arguments)

  wget: (url, filepath)-> @_lock =>
    r = await axios.get {
      url
      responseType: "stream"
    }
    new Promise(
      (resolve,reject)=>
        writer = fs.createWriteStream(filepath)
        writer.on('error',reject)
        writer.on('close',resolve)
        r.pipe writer
    )


  _next : ->
    --@n
    if @todo.length
      [resolve, func] = @todo.shift()
      @_lock => resolve await func()


module.exports = exports = {
  Req
}

do =>
  req = new Req()
  for i in Object.getOwnPropertyNames(Req::)
    if i!='constructor' and not i.startsWith '_'
      exports[i]=req[i].bind(req)

