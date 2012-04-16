format = String::format = (args...) ->

  if args.length is 0
    return (args...) => @format args...

  idx = 0
  explicit = implicit = no
  error = 'cannot switch from {} to {} numbering'.format()

  @replace \
  /([{}])\1|[{](.*?)(?:!(.+?))?[}]/g,
  (match, literal, key, transformer) ->
    return literal if literal

    if key.length
      explicit = yes
      throw error('implicit', 'explicit') if implicit
      value = lookup(args, key) ? ''
    else
      implicit = yes
      throw error('explicit', 'implicit') if explicit
      value = args[idx++] ? ''

    value = value.toString()
    if fn = format.transformers[transformer] then fn.call(value) ? ''
    else value

lookup = (object, key) ->
  unless /^(\d+)([.]|$)/.test key
    key = '0.' + key
  while match = /(.+?)[.](.+)/.exec key
    object = object[match[1]]
    key = match[2]
  value = object[key]
  if typeof value is 'function' then value.call object else value

format.transformers = {}

format.version = '0.1.0'