#
# This module keeps the dom-navigation methods
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Element.include

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
  # Finds all the elements that match given css-rule
  #
  # @param {String} css-rule
  # @param {Boolean} a marker if you need raw dom-elements
  # @return {Search|Array} list of matching elements
  #
  find: Search_module.find

  #
  # Finds the first matching sub-element
  #
  # @param {String} optional css-rule
  # @return {Element} element or `null`
  #
  first: Search_module.first

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
  # @return {Search} list of matching elements
  #
  parents: (css_rule) ->
    Element_recursively_collect(@, 'parentNode', css_rule)

  #
  # Returns the list of immediate children of the element
  # optionally filtered by a css-rule
  #
  # @param {String} optional css-rule
  # @return {Search} list of matching elements
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
  # @return {Search} list of matching elements
  #
  siblings: (css_rule) ->
    @previousSiblings(css_rule).reverse().concat(@nextSiblings(css_rule).toArray())

  #
  # Returns a list of the next siblings of the element
  # optionally filtered by a css-rule
  #
  # @param {String} optional css-rule
  # @return {Search} list of matching elements
  #
  nextSiblings: (css_rule)->
    Element_recursively_collect(@, 'nextSibling', css_rule)

  #
  # Returns a list of the previous siblings of the element
  # optionally filtered by a css-rule
  #
  # @param {String} optional css-rule
  # @return {Search} list of matching elements
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
# and returns as a standard {Search} result
#
# @param {Element} start point
# @param {String} attribute
# @param {String} css-rule
# @return {Search} result
#
Element_recursively_collect = (element, attr, css_rule)->
  result = []; node = element._; no_rule = css_rule is undefined

  while node = node[attr]
    if node.nodeType is 1 and (no_rule or wrap(node).match(css_rule))
      result.push(node)

  return new Search(result)