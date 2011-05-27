#
# The iframed ajax requests tonnel
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class IFrame
  #
  # Basic constructor
  #
  # @param {Ajax} original ajax request
  # @return void
  #
  constructor: (ajax)->
    @ajax = ajax
    @form = ajax.options.params

    @id   = '__lovely_ajax_'+ new Date().getTime()

    @form.document().first('body').append("<i>
      <iframe name='#{@id}' id='#{@id}' width='0' height='0'
        frameborder='0' src='about:blank'></iframe></i>")

    $(global[@id]).on('load', bind(@onLoad, this))

  send: ->
    @form.attr('target', @id).submit()

  onLoad: ->
    @status       = 200
    @readyState   = 4

    @form.attr('target', '')

    try
      @responseText = global[@id].document.documentElement.innerHTML
    catch e

    @onreadystatechange()

  abort: ->
    $(global[@id]).attr('src', 'about:blank')


  # XMLHttpRequest dummy methods
  open:               ->
  setRequestHeader:   ->
  onreadystatechange: ->