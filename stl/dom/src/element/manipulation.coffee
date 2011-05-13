#
# This file handles the dom-element manipulation
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Element.insert

  #
  # Clones the element with all it's content
  #
  # @return {Element} a clone
  #
  clone: ->
    new Element(this._.cloneNode(true))

  #
  # Removes all the child nodes out of the element
  #
  # @return {Element} this
  #
  clear: ->
    while this._.firstChild
      this._.removeChild(this._.firstChild)
    this

  #
  # Checks if the element doesn't have any actual content in it
  #
  # @return {Boolean} check result
  #
  empty: ->
    /^\s*$/.test(this.html())

  #
  # Sets of gets the html content of the element as a string
  #
  # @param {String} html content if setting
  # @return {String|Element} this element or html content
  #
  html: (content)->
    if content is undefined then this._.innerHTML else this.update(content)

  #
  # Sets of gets the element's content as a plain text
  #
  # @param {String} textual content if setting
  # @return {String|Element} this element or textual content
  #
  text: (text) ->
    if text is undefined then (this._.textContent || this._.innerText)
    else this.update(this.document()._.createTextNode(text))

  #
  # Removes the element out of the dom-tree
  #
  # @return {Element}
  #
  remove: ->
    this._.parentNode && this._.parentNode.removeChild(this._)
    this

  #
  # Replaces the element with coven content
  #
  # @param {String|Element|Iterable} content
  # @return {Element} this
  #
  replace: (content)->
    this.insert(content, 'instead')

  #
  # Replaces the element content
  #
  # @param {String|Element|Iterable} content
  # @return {Element} this
  #
  update: (content) ->
    this.clear().insert(content)

  #
  # Appends the argument elements to this element
  #
  # @param {String|Element} content
  # ....
  # @return {Element} this
  #
  append: (first) ->
    this.insert if typeof(first) is "string" then A(arguments).join('') else arguments

  #
  # Inserts the given content into the given position
  #
  # @param {String|Element|Iterable} content
  # @param {String} optional position 'bottom'/'top'/'before'/'after'/'instead'
  # @return {Element} this
  #
  insert: (content, position) ->
    # TODO me

  #
  # Inserts this element into the given one at given position
  #
  # @param {Element} destination
  # @param {String} optional position
  # @return {Element} this
  #
  insertTo: (element, position) ->
    # TODO me
