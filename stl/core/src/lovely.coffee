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
  deadline = new Date() # the hang up time

  # setting up the options
  'hostUrl'     of options || (options.hostUrl     = Lovely.hostUrl || find_host_url())
  'baseUrl'     of options || (options.baseUrl     = Lovely.baseUrl || options.hostUrl)
  'waitSeconds' of options || (options.waitSeconds = Lovely.waitSeconds)

  options.hostUrl[options.hostUrl.length - 1] is '/' || (options.hostUrl += '/')
  options.baseUrl[options.baseUrl.length - 1] is '/' || (options.baseUrl += '/')

  deadline.setTime(deadline.getTime() + options.waitSeconds * 1000)

  check_modules_load = modules_load_listener_for(modules, callback, current)

  unless check_modules_load() # checking maybe they are already loaded
    modules_load_listeners.push(check_modules_load)
    header = document.getElementsByTagName('head')[0]

    # inserting the actual scripts on the page
    for module, i in modules
      url = (
        if module[0] is '.' then options.baseUrl else options.hostUrl
      ) + module + ".js"

      # stripping out the '../' and './' things to get the clean module name
      module = modules[i] = modules[i].replace(/^[\.\/]+/, '')

      if !(find_module(module) or find_module(module, Lovely.loading))
        script = document.createElement('script')

        script.src    = url.replace(/([^:])\/\//g, '$1/')
        script.async  = true
        script.type   = "text/javascript"
        script.onload = check_all_waiting_loaders

        header.appendChild(script)

        Lovely.loading[module] = script

  return # nothing

# modules load_listeners registery
modules_load_listeners = []

#
# Checks all the awaiting module loaders in the registery
#
check_all_waiting_loaders = ->
  global.setTimeout ->
    clean_list = []
    for listener, i in modules_load_listeners
      unless listener() # if not yet loaded
        clean_list.push(listener)

    # if some modules were loaded, then check the rest of them again
    if clean_list.length != modules_load_listeners.length
      modules_load_listeners = clean_list
      check_all_waiting_loaders()

    return # nothing
  , 0 # using an async call to let the script run

#
# Builds an event listener that checks if the modules are
# loaded and if so then calls the callback
#
# @param {Array}     modules list
# @param {Function}  callback
# @param {String}    currently awaiting module name
# @return {Function} listener
#
modules_load_listener_for = (modules, callback, name)->
  ->
    packages=[]

    for module in modules
      if (module = find_module(module))
        packages.push(module)
      else
        return false # some modules are not loaded yet

    # registering the current module if needed
    if (result = callback.apply(global, packages)) && name
      # saving the module with the version
      Lovely.modules[name] = result

      delete(Lovely.loading[name])

    return true # successfully loaded everything


#
# Searches for an already loaded module
#
# @param {String} full module name (including the version)
# @param {Object} modules registery
# @param {Object} matching module
#
find_module = (module, registry)->
  registry = registry || Lovely.modules
  version  = (module.match(/\-\d+\.\d+\.\d+.*$/) || [''])[0]
  name     = module.substr(0, module.length - version.length)
  version  = version.substr(1)

  unless module = registry[module]
    versions = [] # tring to find the latest version manually

    for key of registry
      if (match = key.match(/^(.+?)-(\d+\.\d+\.\d+.*?)$/))
        if match[1] is name
          versions.push(key)

    module = registry[versions.sort()[versions.length - 1]]

  module


#
# Searches for the Lovely hosting url from the scripts 'src' attribute
#
# @return {String} location
#
find_host_url = ->
  if global.document
    scripts = document.getElementsByTagName('script')
    re = /^(.*?\/?)core(-.+)?\.js/

    for script in scripts
      if (match = (script.getAttribute('src') || '').match(re))
        return match[1]

  Lovely.hostUrl
