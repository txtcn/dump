readline = require('readline')

rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
})

module.exports = (msg='')=>
  new Promise (resolve)=>
    rl.question msg, resolve

