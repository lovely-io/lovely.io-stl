#
# The main Coookie class
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Cookie
  include: Options

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
      new this(name, options).set(value)

    #
    # Reads a cookie by name
    #
    # @param {String} cookie name
    # @return {mixed|undefined} cookie value or `undefined` if not set
    #
    get: (name, options)->
      new this(name).get()

    #
    # Removes the cookie
    #
    # @param {String} cookie name
    # @return {Cookie} object
    #
    remove: (name)->
      new this(name).remove()

    #
    # Checks if cookies are enabled in the browser
    #
    # @return {Boolean} check result
    #
    enabled: ->
      document.cookie = "__t=1"
      document.cookie.indexOf("__t=1") isnt -1

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
    @setOptions(options)
    @name = name
    return @

  #
  # Sets the cookie with the name
  #
  # @param {mixed} value
  # @return Cookie this
  #
  set: (data)->
    data = encodeURIComponent(JSON.stringify(data))

    @options.domain && data += '; domain='+ @options.domain
    @options.path   && data += '; path='+   @options.path
    @options.secure && data += '; secure'

    if @options.ttl
      ttl = new Date()
      ttl.setTime(ttl.getTime() + @options.ttl * 24 * 60 * 60 * 1000)
      data += '; expires='+ ttl.toGMTString()

    @options.document.cookie = "#{encodeURIComponent(@name)}=#{data}"

    return @

  #
  # Searches for a cookie with the name
  #
  # @return {mixed} saved value or `undefined` if nothing was set
  #
  get: ->
    name = decodeURIComponent(@name)
    name = "(?:^|;)\\s*#{name.replace(/([.*+?\^=!:${}()|\[\]\/\\])/g, '\\$1')}=([^;]*)"
    data = @options.document.cookie.match(name)

    if data then JSON.parse(decodeURIComponent(data[1])) else undefined

  #
  # Removes the cookie
  #
  # @return {Cookie} this
  #
  remove: ->
    @options.duration = -1
    @set('')