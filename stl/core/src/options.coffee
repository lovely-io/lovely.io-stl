#
# A standard options handling interface mixin
#
# USAGE:
#     MyClass = new Lovely.Class
#       include: Lovely.Options,
#       extend:
#         Options:
#           one:     'thing'
#           another: 'one'
#
#       initialize: (options) ->
#         this.setOptions options
#
#  Copyright (C) 2011 Nikolay Nemshilov
#
Options =
  options: {}  # instance options object

  #
  # Sets the current options
  #
  # NOTE: will deep-merge the Klass.Options
  #
  # @param {Object} options
  # @return {Class} this
  #
  setOptions: (options) ->
    klass    = this.constructor
    defaults = {}

    while klass
      if 'Options' of klass
        defaults = klass.Options
        break

      klass = klass.__super__

    this.options = Hash.merge(defaults, options)

    this