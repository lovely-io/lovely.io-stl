#
# This file contains the common use methods
#
# NOTE: some methods, like #show, #hide, etc
# take a visual effect settings, those settings
# will work only if you hook the `fx` module,
# otherwise the element will be immediately switched
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Element.include

  #
  # The basic attributes handling method
  #
  # USAGE:
  #     element.attr('name')          // -> getting attribute
  #     element.attr('name', 'value') // -> setting attribute
  #     element.attr('name', null)    // -> removing attribute
  #     element.attr('name') is null  // -> checking attribute
  #
  #     element.attr
  #       name1: 'value1'
  #       name2: 'value2'
  #       ....
  #
  # @param {String|Object} attribute name or a hash of attributes
  # @param {String|undefined} attribute value
  # @return {String|Element} attribute value or element reference
  #
  attr: (name, value) ->
    if typeof(name) is 'string'

      if value is undefined # reading an attribute
        value = @_[name] || @_.getAttribute(name)
        return if value is '' then null else value

      else if value is null # erazing an attribute
        @_.removeAttribute(name)
        delete @_[name]

      else if name is 'style' # bypassing the styles into the #style method
        @style value

      else # setting an attribute
        element = @_
        element.setAttribute(name, value) unless name of element
        element[name] = value

    else # assuming it's a hash to set
      for value of name
        @attr(value, name[value])

    return @

  #
  # Checks if the element is hidden
  #
  # @return {Boolean} check result
  #
  hidden: ->
    @style('display') is 'none'

  #
  # Checks if the element is visible
  #
  # @return {Boolean} check result
  #
  visible: ->
    !@hidden()

  #
  # Hides an element (optionally with fx)
  #
  # @return {Element} this
  #
  hide: ->
    if @visible()
      @_old_display = @style('display')
      @_.style.display = 'none'

    return @

  #
  # Shows an element (optionally with fx)
  #
  # @return {Element} this
  #
  show: ->
    if @hidden()
      element = @_
      value   = @_old_display

      if !value || value is 'none'
        dummy = new Element(element.tagName).insertTo(HTML)
        value = dummy.style('display') || 'none'
        dummy.remove()

      element.style.display = if value is 'none' then 'block' else value

    return @

  #
  # Toggles an element's visual state (optionally with fx)
  #
  # @return {Element} this
  #
  toggle: ->
    if @hidden() then @show() else @hide()

  #
  # hides all the sibling elements and shows this one (optionally with fx)
  #
  # @return {Element} this
  #
  radio: ->
    @siblings().each('hide')
    @show()

  #
  # Returns the element's owner document reference
  #
  # @return {Document} wrapped owner document
  #
  document: ->
    wrap @_.ownerDocument

  #
  # Returns the element's owner window reference
  #
  # @return {Window} wrapped owner window
  #
  #
  window: ->
    @document().window()