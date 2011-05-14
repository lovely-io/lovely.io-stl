#
# This module handles the dom-elements styles manipulations
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Element.include
  #
  # Returns the current class-names of the element
  #
  # @return {String} class-names
  #
  getClass: ->
    this._.className

  #
  # Sets the entire `className` property and replaces
  # and currently active css-classes
  #
  # @param {String} class-name
  # @return {Element} this
  #
  setClass: (name) ->
    this._.className = name
    this

  #
  # Checks if current element has the tagName
  #
  # @param {String} class-name
  # @return {Element} this
  #
  hasClass: (name) ->
    " #{this._.className} ".indexOf(" #{name} ") isnt -1

  #
  # Adds the class name to the list
  #
  # @param {String} class-name
  # @return {Element} this
  #
  addClass: (name) ->
    testee = " #{this._.className} "
    if testee.indexOf(" #{name} ") is -1
      this._.className += (if testee is '  ' then '' else ' ') + name
    this

  #
  # Removes the class name out of the list
  #
  # @param {String} class-name
  # @return {Element} this
  #
  removeClass: (name) ->
    this._.className = trim(" #{this._.className} ".replace(" #{name} ", ' '))
    this

  #
  # Toggles the class-name existance in the element
  #
  # @param {String} class-name
  # @return {Element} this
  #
  toggleClass: (name) ->
    if this.hasClass(name) then this.removeClass(name)
    else this.addClass(name)

  #
  # Removes the class name out of all the sibling elements
  # and adds it to the current one
  #
  # @param {String} class-name
  # @return {Element} this
  #
  radioClass: (name) ->
    this.siblings().each('removeClass', name)
    this.addClass(name)

  #
  # Main method to work with the element styles
  #
  # USAGE:
  #     element.style('name')          // -> {String} style value
  #     element.style('name1 name2')   // -> {Object} style values
  #     element.style('name', 'value') // -> {Element} sets the style
  #     element.style('name:value')    // -> {Element} sets the style
  #     element.style(name: value)     // -> {Element} also sets the style
  #
  # @param {String|Hash} style name or style definition
  # @param {String} style value
  # @return {String|Object|Element} style, styles or self reference
  #
  style: (name, value) ->
    if typeof(name) is 'string'
      if name.indexOf(':') isnt -1 # setting style as a string
        return @style(Element_parse_style(name))

      else if name.indexOf(' ') isnt -1 # reading multiple styles
        return Element_read_styles(this, name)

      else if value is undefined # reading a single style
        return Element_clean_style(@_.style, name) or
          Element_clean_style(Element_computed_styles(@_), name)

      else # setting a style
        if name is 'float'
          name = if Browser_OLD_IE then 'styleFloat' else 'cssFloat'
        else
          name = camelize(name)

        if name is 'opacity' and BROWSER_IE_OPACITY
          @_.style.filter = "alpha(opacity=#{value * 100})"
        else
          @_.style[name] = value

    else # assuming it's a hash to set
      for value of name
        @style value, name[value]

    return @


# private

# reads specified element styles into a hash
Element_read_styles = (element, names) ->
  hash = {}

  for name in names.split(/\s+/)
    name = camelize(name)
    hash[name] = element.style(name)

  hash


# parses a string style into a hash of styles
Element_parse_style = (style) ->
  hash = {}

  for chunk in style.split(';')
    unless /^\s+$/.test(chunk)
      [name, value] = chunk.split(':')
      hash[trim(name)] = trim(value)

  hash


# creates a clean version of a style value
Element_clean_style = (style, name) ->
  name = camelize(name)

  if name is 'opacity'
    return if BROWSER_IE_OPACITY then (
      (/opacity=(\d+)/i.exec(style.filter || '') ||
      ['', '100'])[1] / 100
    )+'' else style[name].replace(',', '.')

  else if name is 'float'
    name = if Browser_OLD_IE then 'styleFloat' else 'cssFloat'

  value = style[name]

  # Opera returns named colors with quotes
  value = value.replace(/"/g, '') if /color/i.test(name) && value

  value


# finding computed styles of a dom-element
if 'currentStyle' of HTML
  Element_computed_styles = (element) ->
    element.computedStyle || {}
else if 'runtimeStyle' of HTML
  Element_computed_styles = (element) ->
    element.runtimeStyle || {}
else
  Element_computed_styles = (element) ->
    element.ownerDocument.defaultView.getComputedStyle(element, null)


