#
# The main Coookie class
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Cookie
  extend:
    #
    # Sets the coookie
    #
    # @param {String} cookie name
    # @param {mixed} cookie value
    # @param {Object} options
    # @return {Cookie} object
    #
    set: (name, value, options)->
      new Cookie(name, options).set(value)

    #
    # Reads a cookie by name
    #
    # @param {String} cookie name
    # @return {mixed|undefined} cookie value or `undefined` if not set
    #
    get: (name, options)->
      new Cookie(name).get()

    #
    # Removes the cookie
    #
    # @param {String} cookie name
    # @param {Object} options
    # @return {Cookie} object
    #
    remove: (name, options)->
      new Cookie(name, options).remove()

    #
    # Checks if cookies are enabled in the browser
    #
    # @return {Boolean} check result
    #
    enabled: ->
      Cookie.Options.document.cookie = "__t=1"
      Cookie.Options.document.cookie.indexOf("__t=1") isnt -1

    #
    # Default options
    #
    Options:
      document: document
      secure:   false
      domain:   null
      path:     null
      ttl:      null # in days

  #
  # Basic constructor
  #
  # @param {String} cookie name
  # @param {Object} options
  # @return {Cookie} this
  #
  constructor: (name, options)->
    @options = ext(ext({}, Cookie.Options), options)
    @name    = name
    return @

  #
  # Sets the cookie with the name
  #
  # @param {mixed} value
  # @return Cookie this
  #
  set: (data)->
    data = JSON.stringify(data) if typeof(data) is 'object'
    data = escape(data)

    @options.domain && data += '; domain='+ @options.domain
    @options.path   && data += '; path='+   @options.path
    @options.secure && data += '; secure'

    if @options.ttl
      date = new Date()
      date.setTime(date.getTime() + @options.ttl * 24 * 60 * 60 * 1000)
      data += '; expires='+ date.toGMTString()

    @options.document.cookie = "#{escape(@name)}=#{data}"

    return @

  #
  # Searches for a cookie with the name
  #
  # @return {mixed} saved value or `undefined` if nothing was set
  #
  get: ->
    name = escape(@name)
    name = "(?:^|;)\\s*#{name.replace(/([.*+?\^=!:${}()|\[\]\/\\])/g, '\\$1')}=([^;]*)"
    data = @options.document.cookie.match(name)

    if data
      data = unescape(data[1])
      try data = JSON.parse(data) catch e

    data || undefined

  #
  # Removes the cookie
  #
  # @return {Cookie} this
  #
  remove: ->
    unless @get() is undefined
      @options.ttl = -1
      @set('')

    return @