##
# `Class` is the main classes handler for Lovely
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Class = (parent, params, Klass) ->
  if !isFunction(parent)
    params = parent
    parent = null

  params or= {}
  parent or= Class # <- Class is the default parent!
  Klass  or= -> this.initialize.apply(this, arguments)

  # handling the inheritance
  Super = ->
  Super.prototype = parent.prototype
  Klass.prototype = new Super()
  Klass.__super__ = parent

  # loading shared modules
  ext(Klass, Class)
    .extend.apply( Klass, ensure_Array(params.extend  || []))
    .include.apply(Klass, ensure_Array(params.include || []))

  delete(params.extend)
  delete(params.include)

  # loading the main properties
  Klass.include(params)

  if !('initialize' of Klass.prototype)
    Klass.prototype.initialize = ->

  return Klass

#
# the class-level utils to manipulate class properties
#
# Principles are the same as in Ruby,
#  * 'extend'  - extends the class level
#  * 'include' - extends the prototype level
#
#
ext Class,
  ##
  # Extends the prototype-level attributes
  #
  # @param {Object} module
  # ....
  # @return {Class} this
  #
  include: ->
    for module in arguments
      module or= {}

      for key of module
        parent = this.__super__;
        super_method = false;

        while parent
          if key of parent.prototype
            if isFunction(parent.prototype[key])
              super_method = parent.prototype[key]
            break

          parent = parent.__super__

        this.prototype[key] = Class_make_method(module[key], super_method)

    return this

  ##
  # Adds a class-level attributes
  #
  # @param {Object} module
  # ...
  # @return {Class} this
  #
  extend: ->
    for module in arguments
      ext(this, module)

    return this


# rewraps the supermethod when needed
Class_make_method = (method, super_method) ->
  if super_method then ->
    this.$super = super_method
    method.apply(this, arguments)
  else
    method
