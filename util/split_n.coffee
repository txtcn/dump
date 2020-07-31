module.exports = (str, split, n)->
  r = []
  n = n - 1
  while r.length < n
    pos = str.indexOf(split)
    if pos < 0
        break
    key = str.slice(0, pos)
    str = str.slice(pos+1)
    r.push(key)
  r.push(str)
  r

