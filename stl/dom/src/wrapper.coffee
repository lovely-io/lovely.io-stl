#
# Defines the common class for all the dom-wrappers
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Wrapper = new Class
  extend:
    Cache: [] # the dom-wrappers registry

    #
    # Tries to find a suitable dom-wrapper
    # for the element. Used by {Element}
    # to perform dynamic typecasting
    #
    # @param {HTMLElement} element
    # @return {Wrapper} suitable wrapper or `undefined`
    #
    Cast: (element) ->
      if element.tagName of Wrapper
        return Wrapper[element.tagName]
      else return undefined

  _: null,

  #
  # Basic constructor
  #
  # @param {mixed} raw dom-unit
  # @return {Wrapper} this
  #
  constructor: (dom_unit) ->
    this._ = dom_unit
    Wrapper.Cache[uid(dom_unit)] = this

