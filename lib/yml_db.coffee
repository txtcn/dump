fs = require 'fs-extra'
yaml = require 'js-yaml'

class YamlDb
  constructor:(@file)->
    if fs.existsSync @file
      @dict = yaml.load(fs.readFileSync @file) or {}
    else
      @dict = {}

  get:(key)->
    @dict[key]

  set:(key, val)->
    exist = key of @dict
    if exist
      old = @dict[key]
      if old != val
        write = true
    else
      write = true
    if write
      @dict[key] = val
      fs.outputFileSync @file, yaml.dump(@dict)
    return false

module.exports = (file)->
  new YamlDb(file+".yml")
