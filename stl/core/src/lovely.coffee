#
# The top function, handles async modules loading/definition
#
# Basic Usage:
#
#    Lovely(['module1', 'module2'], function(module1, module2) {
#      // do stuff
#    });
#
# Modules Definition:
#
#    Lovely('module-name', ['dep1', 'dep2'], function(dep1, dep2) {
#      return { module: 'definition' };
#    });
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Lovely = ->
  args     = A(arguments)
  current  = if isString(args[0])   then args.shift() else null
  options  = if isObject(args[0])   then args.shift() else {}
  modules  = if isArray(args[0])    then args.shift() else []
  callback = if isFunction(args[0]) then args.shift() else ->
  header   = document.getElementsByTagName('head')[0]
  deadline = new Date() # the hang up time

  # setting up the options
  'hostUrl'     of options || (options.hostUrl     = Lovely.hostUrl || find_host_url())
  'baseUrl'     of options || (options.baseUrl     = Lovely.baseUrl || options.hostUrl)
  'waitSeconds' of options || (options.waitSeconds = Lovely.waitSeconds)

  options.hostUrl[options.hostUrl.length - 1] is '/' || (options.hostUrl += '/')
  options.baseUrl[options.baseUrl.length - 1] is '/' || (options.baseUrl += '/')

  deadline.setTime(deadline.getTime() + options.waitSeconds * 1000)

  # inserting the actual scripts on the page
  for module, i in modules
    url = (
      if module[0] is '.' then options.baseUrl else options.hostUrl
    ) + module + ".js"

    # stripping out the '../' and './' things to get the clean module name
    module = modules[i] = modules[i].replace(/^[\.\/]+/, '')

    if !(module of Lovely.modules or module of Lovely.loading)
      script = document.createElement('script')

      script.src   = url.replace(/\/\//g, '/')
      script.async = true
      script.type  = "text/javascript"

      header.appendChild(script)

      Lovely.loading[module] = script

  # waiting for the modules to load
  do ->
    packages=[]

    for module in modules
      if module of Lovely.modules
        packages.push(Lovely.modules[module])
      else if new Date() < deadline
        return setTimeout(arguments.callee, 50)
      else
        return undefined # giving up on unreachable module

    # making the call
    result = callback.apply(global, packages)

    # registering the current module if needed
    if result && current
      Lovely.modules[current] = result
      delete(Lovely.loading[current])

    return; # nothing

  return; # nothing


#
# Searches for the Lovely hosting url from the scripts 'src' attribute
#
# @return {String} location
#
find_host_url = ->
  scripts = document.getElementsByTagName('script')
  re = /(.*?(^|\/))(lovely.io(:\d{4})?\/core\.js)/

  for script in scripts
    if match = (script.getAttribute('src') || '').match(re)
      return match[0].replace(/core\.js$/, '')

  Lovely.hostUrl
