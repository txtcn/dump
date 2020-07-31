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
        r = await req.get(
          url
          {
            # headers
            cancelToken: source.token
            ...opt
          }
        )
      catch err
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
      finally
        clearTimeout timer
      if not r?.data
        console.log chalk.redBright(url), r
      return r.data
}

