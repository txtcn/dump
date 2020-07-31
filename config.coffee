#!/usr/bin/env coffee

fs = require 'fs-extra'
yaml = require('js-yaml')
ROOT = __dirname
dirpath = ROOT + "/config/"
{join} = require 'path'
{merge} = require 'lodash'

module.exports = exports = {
  PATH:{
    ROOT
  }
}

for i in ["default","self"]
  filepath = dirpath+i+".yml"
  if fs.existsSync(filepath)
    o = yaml.safeLoad(fs.readFileSync(filepath, 'utf8'))
    {PATH} = o
    if PATH
      for k,v of PATH
        PATH[k] = join(ROOT, v)
    merge(exports, o)

