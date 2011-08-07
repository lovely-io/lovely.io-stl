#
# The Ajax main unit
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Ajax
  include: [core.Options, core.Events]

  extend:
    #
    # default options
    #
    Options:
      method:       'post'   # default request method
      encoding:     'utf-8'  # default request encoding
      evalResponse: false    # forced response eval
      evalJS:       true     # auto-eval text/javascript responses
      evalJSON:     true     # auto-convert text/json data
      urlEncoded:   true     # url-encode params and data
      spinner:      null     # spinner reference a css-rule or an element object
      params:       null     # params to send. string or a hash
      jsonp:        false    # perform a JSONP request
      headers: {             # default headers
        'X-Requested-With': 'XMLHttpRequest'
        'Accept':           'text/javascript,text/html,application/xml,text/xml,*/*'
      }

    #
    # Loads the url address with a GET request
    #
    # @param {String} url-address
    # @param {Object} options
    # @return {Ajax} request
    #
    load: (url, options)->
      options or= {}
      options.method = 'get' unless 'method' of options
      new Ajax(url, options).send()


  # public params
  _:            null # raw XMLHttpRequest object
  url:          null # the url address
  status:       null # HTTP response status code
  responseText: null
  responseXML:  null
  responseJSON: null
  headerJSON:   null # JSON data from the X-JSON header


  #
  # Basic Ajax constructor
  #
  # @param {String} url address
  # @param {Object} options
  # @return {Ajax} this
  #
  constructor: (url, options) ->
    @url = url
    @options = ext({}, Ajax.Options)
    @options = ext(@options, options)

    # attaching the standard listeners
    @on
      success:  'evalScripts'
      create:   'showSpinner'
      complete: 'hideSpinner'
      cancel:   'hideSpinner'

    # catching the event listeners that are specified in the options
    for key, method of @options
      if key in ['success', 'failure', 'complete', 'create', 'request', 'cancel']
        @on key, method

    return @

  #
  # Sets a request header key-value, or reads a response header
  #
  # @param {String} header name
  # @param {String} header value
  # @return {String|Ajax} header value or this request
  #
  header: (name, value)->
    if arguments.length is 1
      try # in case there is no request yet, or the name is bogus
        return @_.getResponseHeader(name)
      catch e
        return undefined
    else
      @options.headers[name] = value
    return @

  #
  # Checks if the status of the request is successful
  #
  # @return {Boolean} check result
  #
  successful: ->
    @status >= 200 && @status < 400

  #
  # Sends the request to the server
  #
  # @return {Ajax} this
  #
  send: ->
    options = @options
    headers = @options.headers
    params  = Ajax_merge(Ajax.Options.params, options.params)
    method  = @options.method.toLowerCase()
    url     = @url

    if method in ['put', 'delete']
      params._method = method
      method = 'post'

    if method is 'post' and options.urlEncoded and !headers['Content-type']
      headers['Content-type'] = 'application/x-www-form-urlencoded;charset='+ options.encoding

    params = Hash.toQueryString(params)

    if method is 'get'
      if params
        url =  url + (if url.indexOf('?') is -1 then '?' else '&')
        url += params

      params = null

    xhr = @_ = if @options.jsonp then new JSONP(@) else new XMLHttpRequest()
    @emit 'create'

    xhr.open(method, url, true) # <- it's always an async request!
    xhr.onreadystatechange = Ajax_state(@)

    for name of headers
      xhr.setRequestHeader(name, headers[name])

    xhr.send(params)
    @emit 'request'

    xhr.onreadystatechange()

    return @

  #
  # Cancels the request
  #
  # @return {Ajax} this
  #
  cancel: ->
    return @ if !@_ or @__canceled

    @_.abort()
    @_.onreadystatechange = ->
    @__canceled = true

    return @emit('cancel')

  #
  # Overloading the original method so that
  # it sent this ajax request and the raw XHR
  # objects to the listner as the default arguments
  # It also fires `ajax:eventname` dom-events on the
  # `document` object so that they could be catched up
  # in there, in case you need to have some global
  # ajax events listener
  #
  # @param {String} event name
  # @return {Ajax} this
  #
  emit: (name)->
    core.Events.emit.call(@, name, @, @_)
    doc.emit("ajax:#{name}", ajax: @)
    return @


# protected

  #
  # Tries to auto-handle JavaScript and JSON responses
  #
  # @return void
  #
  evalScripts: ->
    content_type = @header('Content-type') || ''
    options      = @options

    if options.evalResponse or (options.evalJS && /(ecma|java)script/i.test(content_type))
      $.eval(@responseText)
    else if options.evalJSON and /json/i.test(content_type)
      @responseJSON = JSON.parse(@responseText)

    if (options = @header('X-JSON'))
      this.headerJSON = JSON.parse(options)

    return;

  #
  # Tries to show the current spinner
  #
  # @return void
  #
  showSpinner: ->
    Ajax_spinner(@, 'show')

  #
  # Tries to hide the current spinner
  #
  # @return void
  #
  hideSpinner: ->
    Ajax_spinner(@, 'hide')


# private

# global spinner handling
Ajax_counter = 0
Ajax_spinner = (ajax, operation)->
  spinner = ajax.options.spinner
  spinner = spinner && $(spinner)[0]
  shared  = Ajax.Options.spinner
  shared  = shared && $(shared)[0]

  if spinner
    if spinner is shared
      # counting the number of requests to handle the global spinner correctly
      Ajax_counter += if operation is 'show' then 1 else -1

      if operation is 'show' or Ajax_counter < 1
        spinner[operation]()

    else
      # just show/hide a local spinner
      spinner[operation]()

  return ajax


# merges the data from various formats into a single hash object
Ajax_merge = ->
  hash = {}

  for params in arguments
    if typeof(params) is 'string'
      params = Hash.fromQueryString(params)
    else if params instanceof Form
      params = params.values()

    for key of params
      hash[key] = params[key]

  return hash


# makes an 'onreadystatechange' listener
Ajax_state = (ajax)->
  xhr = ajax._

  return ->
    return undefined if xhr.readyState isnt 4 or xhr.canceled

    try
      ajax.status = xhr.status
    catch e
      ajax.status = 0

    ajax.responseText = xhr.responseText
    ajax.responseXML  = xhr.responseXML

    ajax.emit('complete')
    ajax.emit(if ajax.successful() then 'success' else 'failure')
