#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Autocompleter extends UI.Menu
  include: core.Options
  extend:
    Options: # global options
      src: []     #  an url to the search query or an Array of

  constructor: (input, options)->
    options or= {}; opts = {}

    for key, value of options
      if key of @constructor.Options
        opts[key] = value
        delete(options[key])

    @$super(options).addClass('lui-autocompleter')


    @input   = Element.resolve(input)
    @spinner = new UI.Spinner()

    @input.autocompleter = @

    for key, value of options = @input.data('autocompleter') || {}
      opts[key] or= value

    @setOptions(opts)

    return @