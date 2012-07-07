#
# A standard options handling interface mixin
#
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
#  Copyright (C) 2011-2012 Nikolay Nemshilov
#
Options =
  options: {}  # instance options object

  #
  # Sets the current options
  #
  # __NOTE__: this method will _deep-merge_ the klass.Options
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