chalk = require 'chalk'
axios = require 'axios'

axios.defaults.timeout = TIMEOUT
TIMEOUT = 30000

require('axios-retry')(
  axios
  retries: 3
)

# ERR_IGNORE = new Set(['ECONNRESET','ECONNABORTED'])

module.exports = {
  get : (url, opt)=>
    if typeof(url)=="string"
      opt = opt or {}
      opt.url = url
    else
      opt = url
    retry = 0
    while retry++ < 9

      source = axios.CancelToken.source()
      timer = setTimeout(
        => source.cancel('timeout')
        TIMEOUT
      )
      # headers = {}
      req = axios
      try
        r = await req(
          {
            # headers
            cancelToken: source.token
            ...opt
          }
        )
      catch err
        if err.response
          console.error [
            chalk.gray("第 #{retry} 次加载失败")
            chalk.red(err.response.status)
            chalk.redBright(err.response.statusText)
            chalk.blueBright(url)
          ].join ' '
          {code} = err

          if err.response.status == 404
            throw err
          # if ERR_IGNORE.has(code)
          #   msg = chalk.redBright(code)
          continue
        else
          console.error err
      finally
        clearTimeout timer
      if not r?.data
        console.log chalk.redBright(url), r
      return r.data
}

