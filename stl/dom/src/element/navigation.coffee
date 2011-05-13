#
# This module keeps the dom-navigation methods
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Element.include

  #
  # Checks if the element matches given css-rule
  #
  # @param {String} css-rule
  # @return {Boolean} check result
  #
  match: (css_rule) ->
    # TODO implement me

  #
  # Finds all the elements that match given css-rule
  #
  # @param {String} css-rule
  # @return {NodeList} list of matching elements
  #
  find: (css_rule) ->
    # TODO implement me

  #
  # Finds the first matching sub-element
  #
  # @param {String} optional css-rule
  # @return {Element} element or `null`
  #
  first: (css_rule) ->
    # TODO implement me

  #
  # Returns the list of immediate children of the element
  # optionally filtered by a css-rule
  #
  # @param {String} optional css-rule
  # @return {NodeList} list of matching elements
  #
  children: (css_rule) ->
    # TODO implement me

  #
  # Returns the parent element or the first parent
  # element that match the css-rule
  #
  # @param {String} optional css-rule
  # @return {Element} matching parent or `null`
  #
  parent: (css_rule) ->
    # TODO implement me

  #
  # Finds all the parent elements of current element
  # optinally filtered by a css-rule
  #
  # @param {String} optional css-rule
  # @return {NodeList} list of matching elements
  #
  parents: (css_rule) ->
    # TODO implement me

  #
  # Returns the next sibling element, optionally
  # the next sibling that matches a css-rule
  #
  # @param {String} optional css-rule
  # @return {Element} sibling element or `null`
  #
  nextSibling: (css_rule) ->
    # TODO implement me

  #
  # Returns the next sibling element, optionally
  # the next sibling that matches a css-rule
  #
  # @param {String} optional css-rule
  # @return {Element} sibling element or `null`
  #
  prevSibling: (css_rule) ->
    # TODO implement me

  #
  # Returns a list of the element siblings
  # optionally filtered by a css-rule
  #
  # @param {String} optional css-rule
  # @return {NodeList} list of matching elements
  #
  siblings: (css_rule) ->
    # TODO implement me

