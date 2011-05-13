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

  _: undefined,

  #
  # Basic constructor
  #
  # @param {mixed} raw dom-unit
  # @return {Wrapper} this
  #
  constructor: (dom_unit) ->
    this._ = Wrapper.Cache[uid(dom_unit)] = dom_unit

    this


# private

#
# a quick local dom-wrapping interface
#
# @param {mixed} dom-unit
# @return {Wrapper} dom-unit
#
wrap = (value) ->
  key = uid(value) # trying to use an existing wrapper

  if key of Wrapper.Cache
    return Wrapper.Cache[key]
  else if value.nodeType is 1
    return new Element(value)
  else if value.target || value.srcElement
    return new Event(value)
  else if value.nodeType is 9
    return new Document(value)
  else if `value.window == window`
    return new Window(value)



# using a random UID_KEY so we didn't interfere with
# any other librarires, including our owns
UID_KEY = "__lovely_dom_uid_#{new Date().getTime()}"
UID_NUM = 1 # the local uids counter

#
# Generates an UID for a raw dom-unit
#
# @param {mixed} raw dom-unit
# @return {Number} uid
#
uid = (node) ->
  unless UID_KEY of node
    node[UID_KEY] = UID_NUM++

  node[UID_KEY]


# using IE's native 'uniqNumber' sequencer when available
if 'uniqNumber' of HTML
  uid = (node) ->
    if node.nodeType is 1
      return node.uniqNumber
    else
      # document and window objects don't have the `uniqNumber` property
      # so we hack it around by using negative indexes and our own
      # internal random UID_KEY property
      unless UID_KEY of node
        node[UID_KEY] = -1 * UID_NUM++

    node[UID_KEY]
