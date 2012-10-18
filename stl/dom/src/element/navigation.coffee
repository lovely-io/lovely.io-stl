#
# This module keeps the dom-navigation methods
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Element.include
  #
  # Finds _all_ matching sub-elements
  #
  # @param {String} css-rule
  # @param {Boolean} marker if you want an Array of raw dom-elements
  # @return {NodeList|Array} matching elements collection
  #
  find: (css_rule, needs_raw)->
    result = @_.querySelectorAll(css_rule||'*')
    if needs_raw is true then result else new NodeList(result, true)

  #
  # Finds the _first_ matching sub-element, or just the first
  # element if no css-rule was specified
  #
  # @param {String} css-rule
  # @return {Element} matching element or `null`
  #
  first: (css_rule)->
    if css_rule is undefined && @_.firstElementChild isnt undefined
      element = @_.firstElementChild
    else
      element = @_.querySelector(css_rule||'*')

    wrap(element)

  #
  # Checks if the element matches given css-rule
  #
  # NOTE: the element should be attached to the page
  #
  # @param {String} css-rule
  # @return {Boolean} check result
  #
  match: (css_rule) ->
    for element in @document().find(css_rule, true)
      if element is @_
        return true
    return false

  #
  # Returns the parent element or the first parent
  # element that match the css-rule
  #
  # @param {String} optional css-rule
  # @return {Element} matching parent or `null`
  #
  parent: (css_rule) ->
    if css_rule
      @parents(css_rule)[0]
    else
      wrap(@_.parentNode)

  #
  # Finds all the parent elements of current element
  # optinally filtered by a css-rule
  #
  # @param {String} optional css-rule
  # @return {NodeList} list of matching elements
  #
  parents: (css_rule) ->
    Element_recursively_collect(@, 'parentNode', css_rule)

  #
  # Returns the list of immediate children of the element
  # optionally filtered by a css-rule
  #
  # @param {String} optional css-rule
  # @return {NodeList} list of matching elements
  #
  children: (css_rule) ->
    @find(css_rule).filter (element)->
      element._.parentNode is @_
    , @

  #
  # Returns a list of the element siblings
  # optionally filtered by a css-rule
  #
  # @param {String} optional css-rule
  # @return {NodeList} list of matching elements
  #
  siblings: (css_rule) ->
    @previousSiblings(css_rule).reverse().concat(@nextSiblings(css_rule).toArray())

  #
  # Returns a list of the next siblings of the element
  # optionally filtered by a css-rule
  #
  # @param {String} optional css-rule
  # @return {NodeList} list of matching elements
  #
  nextSiblings: (css_rule)->
    Element_recursively_collect(@, 'nextSibling', css_rule)

  #
  # Returns a list of the previous siblings of the element
  # optionally filtered by a css-rule
  #
  # @param {String} optional css-rule
  # @return {NodeList} list of matching elements
  #
  previousSiblings: (css_rule)->
    Element_recursively_collect(@, 'previousSibling', css_rule)

  #
  # Returns the next sibling element, optionally
  # the next sibling that matches a css-rule
  #
  # @param {String} optional css-rule
  # @return {Element} sibling element or `null`
  #
  nextSibling: (css_rule) ->
    if css_rule is undefined and @_.nextElementSibling isnt undefined
      wrap(@_.nextElementSibling)
    else
      @nextSiblings(css_rule)[0]

  #
  # Returns the next sibling element, optionally
  # the next sibling that matches a css-rule
  #
  # @param {String} optional css-rule
  # @return {Element} sibling element or `null`
  #
  previousSibling: (css_rule) ->
    if css_rule is undefined and @_.previousElementSibling isnt undefined
      wrap(@_.previousElementSibling)
    else
      @previousSiblings(css_rule)[0]


# private

#
# Recursively collects stuff from the element
# wraps them up with the {Element} instances
# and returns as a standard {NodeList} result
#
# @param {Element} start point
# @param {String} attribute
# @param {String} css-rule
# @return {NodeList} result
#
Element_recursively_collect = (element, attr, css_rule)->
  result   = []; node = element._;
  no_rule  = css_rule is undefined
  css_rule = element.document().find(css_rule, true) unless no_rule
  match    = (node)->
    for element in css_rule
      if element is node
        return true
    return false

  while (node = node[attr]) isnt null
    if node.nodeType is 1 and (no_rule or match(node))
      result.push(node)

  return new NodeList(result)


