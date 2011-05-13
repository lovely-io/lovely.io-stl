#
# Defines the basic dom-element wrapper
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Element = new Class Wrapper,
  extend:
    Wrappers: {} # custom dom-wrappers registry

  #
  # Basic constructor
  #
  # @param {String|HTMLElement} tag name or a raw dom-element
  # @param {Object} new element options
  # @return {Element} instance
  #
  constructor: (element, options) ->
    element = make_element(element, options) if typeof(element) is 'string'

    # handling dynamic typecasting
    cast = Wrapper.Cast(element) if @constructor is Element
    return new cast(element, options) if cast isnt undefined

    this.$super(element)

    if options isnt undefined
      for key of options
        switch key
          when 'id'    then this._.id        = options[key]
          when 'html'  then this._.innerHTML = options[key]
          when 'class' then this._.className = options[key]
          when 'css'   then this.css           options[key]
          when 'on'    then this.on            options[key]
          else              this.attr     key, options[key]

    return this



# private

# a quick elements creation helper
elements_cache = {}
make_element = (tag, options) ->
  unless tag of elements_cache
    elements_cache[tag] = document.createElement(tag)

  elements_cache[tag].cloneNode false


# old IE < 9 browsers have a bug with INPUT elements
# and 'checked' status presets
if Browser_OLD_IE
  make_element = (tag, options) ->
    if tag is 'input' and options isnt undefined
      tag = "<input name=\"#{options.name}\" type=\"#{options.type}\"#{
        if options.checked then ' checked' else ''} />"

    document.createElement(tag)
