#!/usr/bin/env coffee

chalk = require 'chalk'
path = require 'path'
klaw = require('klaw-sync')
Out = require './txtcn/out'

ignore = (item)=>
  basename = path.basename(item.path)
  return basename == '.' || basename[0] != '.'


module.exports = =>
  li = klaw(path.join(__dirname,'data'), {nodir:true, filter:ignore})
  for i in li
    fname = path.basename(i.path)
    if /\d+/.test(fname)
      dirname = path.dirname(i.path)
      out = Out(dirname)
      out.load(fname)
      out.done()

      global.gc()
      console.log("内存占用",chalk.green((process.memoryUsage().heapUsed/1024/1024).toFixed(2)))
      console.log dirname, fname

if not module.parent then do =>
  await module.exports()
  process.exit()

# module.exports = {

# }

