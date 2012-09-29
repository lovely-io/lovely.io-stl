#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Autocompleter extends UI.Menu
  include: core.Options
  extend:
    Options: # default options
      src:       []     # an url to the search query or an Array of
      method:    'get'  # ajax requests default HTTP method
      minLength: 1      # min text length for the autocompleter to start working
      threshold: 200    # the user's typing pause length for the autocompleter to watch
      highlight: true   # autohighlight matching entries
      cache:     true   # cache search results internally

  #
  # Basic constructor
  #
  # @param {Element|HTMLElement|String} the input element reference
  # @param {Object} extra options
  # @return {Autocompleter} this
  #
  constructor: (input, options)->
    options or= {}; opts = {}

    for key, value of options
      if key of @constructor.Options
        opts[key] = value
        delete(options[key])

    @$super(options).addClass('lui-autocompleter')

    @input   = Element.resolve(input).on('keyup', (event)=> @listen(event) )
    @spinner = new UI.Spinner()

    @input.autocompleter = @

    for key, value of options = @input.data('autocompleter') || {}
      opts[key] or= value

    @setOptions(opts)

    @on 'pick', (event)->
      @input.value(event.link.text())
      @emit 'complete', text: event.link.text()

    return @

  #
  # Listens to an input field keyups, waits for it to pause
  #
  # @param {dom.Event} keyboard event
  # @return {Autocompleter} this
  #
  listen: (event)->
    window.clearTimeout @_timeout if @_timeout

    if !(event.keyCode in [37,38,39,40,13,27]) && @input._.value.length >= @options.minLength
      @_timeout = window.setTimeout =>
        if @input._.value.length >= @options.minLength
          @suggest()
        else
          @hide()
      , @options.threshold

    return @

  #
  # Starts the autocompletion search
  #
  # @return {Autocompleter} this
  #
  suggest: ->
    search = '' + @input._.value

    if typeof(@options.src) is 'string'
      unless @ajax
        @ajax = new Ajax(@options.src.replace('{search}', search), method: @options.method)
        @ajax.on 'complete', =>
          if @ajax.responseJSON
            @update(@ajax.responseJSON, search).showAt(@input)
          else
            @hide()

          @ajax = null

        @ajax.send()

    else # assuming it's an array
      @update core.L(@options.src).filter (item)->
        item.toLowerCase().substr(0, search.length) is search.toLowerCase()
      , search

      @showAt(@input)

    return @

  #
  # Updates the element's content
  #
  # @param {String|Array} content
  # @param {String} highlight text
  # @return {Autocompleter} self
  #
  update: (content, highlight)->
    if isArray(content) && highlight isnt undefined
      highlight = String(highlight).toLowerCase()

      content = core.L(content).map (entry)=>

        if @options.highlight && highlight && (index = entry.toLowerCase().indexOf(highlight)) isnt -1
          entry = entry.substr(0, index) + '<strong>' +
            entry.substr(index, index + highlight.length) + '</strong>' +
            entry.substr(index + highlight.length)

        "<a href='#'>#{entry}</a>"

      content = content.join("\n")

    @$super(content)