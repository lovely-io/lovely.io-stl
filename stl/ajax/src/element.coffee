#
# The DOM Element unit AJAX related extensions
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
Element.include
  #
  # Loads the the url via AJAX and then updates the content
  # of the element with the response text
  #
  # NOTE: will perform a _GET_ request by default
  #
  # @param {String} url address
  # @param {Object} ajax options
  # @return {Element} this
  #
  load: (url, options)->
    @ajax = new Ajax(url, Hash.merge({method: 'get'}, options))
    @ajax.on('success', bind((event)->
      @update event.ajax.responseText
      @emit 'ajax:update'
    , @))
    @ajax.send()

    return @