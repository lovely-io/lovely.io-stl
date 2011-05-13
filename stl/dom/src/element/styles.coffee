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
    # TODO me