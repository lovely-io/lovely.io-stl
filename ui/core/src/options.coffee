#
# Standard UI options processing module
#
# The point is in auto-matic mergin of the
# set of default options, options from the element's
# `data-something` attributes and element's standard
# options, things like `id`, `class`, etc.
#
# Copyright (C) 2012 Nikolay Nemshilov
#
Options =

  #
  # Sets the options and cleans them up to for being able to be used in `Element#constructor`
  #
  # @param {Object} new options
  # @param {String} widget name (for the `className` and `data-widget-name` attributes)
  # @param {HTMLElement} the widget's original dom-element
  # @return {Object} a clean list of options that can be bypassed into the `Element#constructor`
  #
  setOptions: (options, name, element)->
    options      or= {}
    options_global = {}
    options_html   = {}
    @options       = {}
    klass          = @constructor
    options_data   = if element then get_data(element, name) else {}

    # searching for the global options
    while klass
      if 'Options' of klass
        options_global = klass.Options || {}
        break
      klass = klass.__super__

    # collecting the actual options hash
    for key of options_global
      value = if key of options then options[key] else if key of options_data then options_data[key] else options_global[key]
      @options[key] = if isObject(value) and isObject(options_global[key]) then Hash.merge(options_global[key], value) else value

    # collecting the HTML options
    for key of options
      options_html[key] = options[key] unless key of options_global

    return options_html



# private

# a dummy element's data extractor
get_data = (element, name)->
  element = _: element, data: Element::data
  element.data(name) || {}
