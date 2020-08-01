class Extract
  constructor: (@html) ->
  li:(tpl)->
    html = @html
    [begin,end] = tpl.split("{}",2)
    r = []
    pre = 0
    while 1
      bp = html.indexOf(begin, pre)
      if bp >= 0
        ep = html.indexOf(end,bp+begin.length)
        if ep >= 0
          r.push html[bp+begin.length...ep].trim()
          pre = ep+1
          continue
      break
    return r

  one:(tpl)->
    html = @html
    [begin,end] = tpl.split("{}",2)
    bp = html.indexOf(begin)
    if bp >= 0
      ep = html.indexOf(end,bp+begin.length)
      if ep >= 0
        return html[bp+begin.length...ep].trim()
    return ''

  one_txt:(tpl)->
    he.decode @one(tpl)

  json:(tpl)->
    r = @one(tpl)
    if r
      JSON.parse r


module.exports = -> new Extract(...arguments)
