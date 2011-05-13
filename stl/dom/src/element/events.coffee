#
# This file provides the standard events handling interface
# basically it uses the `core` module `Lovely.Events` mixin
# but adoptes it for the dom-events handling
#
# Copyright (C) 2011 Nikolay Nemshilov
#
for Klass in [Element, Document, Window]
  Klass.include
    _listeners: null  # the listeners index

    #
    # Attaching an event listener
    #
    on: ->
      this._listeners is null && make_listeners(this)
      Lovely.Events.on.apply(this, arguments)

    #
    # Removes an event listener
    #
    no: ->
      this._listeners is null && make_listeners(this)
      Lovely.Events.no.apply(this, arguments)

    #
    # Checks if an event listener is attached
    #
    ones: Lovely.Events.ones

    #
    # Fires an event on the element
    #
    # NOTE: the event will propogate through
    # the dom structure, up to the document!
    #
    # @param {String} event name
    # @param {Object} event attributes
    # @return {Wrapper} this
    #
    emit: (name, attributes) ->
      # TODO make my day!

#
# Makes a smart event listeners registry
# that will add/remove event listeners autmoatically
# to the real dom-element
#
make_listeners = (instance) ->
  list = []

  list.push = (hash) ->
    # TODO addEventListener in here
    Array.prototype.push.call(this, hash)

  list.splice = (position) ->
    # TODO remove listener in here
    Array.prototype.splice.call(this, position, 1)

  instance._listeners = list




