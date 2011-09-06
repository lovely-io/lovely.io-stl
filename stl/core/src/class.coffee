##
# `Class` is the main classes handler for Lovely
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Class = (parent, params) ->
  unless isFunction(parent)
    params = parent
    parent = null

  params or= {}
  Klass = ->
    if   this.$super is undefined then this
    else this.$super.apply(this, arguments)

  Klass = params.constructor if `__hasProp.call(params, 'constructor')`

  if parent # handling the inheritance
    #console.log(parent.toString())
    Super = ->
    Super.prototype = parent.prototype
    Klass.prototype = new Super()
    Klass.__super__ = parent
    Klass.prototype.$super = ->
      this.$super = parent.prototype.$super
      parent.apply(this, arguments)

  Klass.prototype.constructor = Klass  # instances class self-reference

  # loading shared modules
  (Klass.include = Class.include).apply(Klass, ensure_Array(params.include || []))
  (Klass.extend  = Class.extend).apply( Klass, ensure_Array(params.extend  || []))

  delete(params.extend)
  delete(params.include)
  delete(params.constructor)

  # loading the main properties
  Klass.include(params)


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
        unless super_method = this.prototype[key] || false
          parent = this.__super__
          while parent
            if key of parent.prototype
              if isFunction(parent.prototype[key])
                super_method = parent.prototype[key]
              break

            parent = parent.__super__

        method = module[key]

        this.prototype[key] = do (method, super_method)->
          if super_method then ->
            this.$super = super_method
            method.apply(this, arguments)
          else
            method


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
