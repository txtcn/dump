#!/usr/bin/env coffee

module.exports = =>


if not module.parent then do =>
  console.log await module.exports()
  process.exit()

# module.exports = {

# }

