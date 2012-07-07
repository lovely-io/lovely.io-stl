#
# This module handles the events delegation API
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
Events_delegation =
  #
  # Attaches a delegative event listener to the element/document
  #
  #     :js
  #     $(element).delegate('#css.rule', 'click', function() {...});
  #     $(element).delegate('#css.rule', 'click', 'addClass', 'boo');
  #     $(element).delegate('#css.rule', 'click', 'hide');
  #
  #     $(element).delegate('#css.rule', {
  #       click: function() {},
  #       focus: 'hide',
  #       blur:  ['addClass', 'boo']
  #     });
  #
  # @param {String} css-rule
  # @param {String|Object} event-name or a hash of event handlers
  # @param {Function} callback
  # @return {Wrapper} this
  #
  delegate: (css_rule, event)->
    if typeof(event) is 'string'
      args     = A(arguments).slice(2)
      callback = args.shift()

      @on event, (event)->
        target = event.find(css_rule)

        if `target != null`
          if typeof(callback) is 'string'
            target[callback].apply(target, args)
          else
            callback.apply(target, [event].concat(args))

        return # nothing

      # adding the css-rule and callback references to the store
      ext @_listeners[@_listeners.length - 1], dr: css_rule, dc: callback

    else # assuming it's a hash of event-handlers
      for args, callback of event
        @delegate.apply(this, [css_rule, args].concat(ensure_array(callback)))

    return @

  #
  # Removes a delegative event listener from the element
  #
  #     :js
  #     $(element).undelegate('#css.rule');
  #     $(element).undelegate('#css.rule', 'click');
  #     $(element).undelegate('#css.rule', 'click', function() {});
  #     $(element).undelegate('#css.rule', 'click', 'addClass', 'boo');
  #     $(element).undelegate('#css.rule', 'click', 'hide');
  #
  #     $(element).undelegate('#css.rule', {
  #       click: function() {},
  #       focus: 'hide',
  #       blur:  ['addClass', 'boo']
  #     });
  #
  # @param {String} css-rule
  # @param {String|Object} event-name or a hash of event handlers
  # @param {Function} callback
  # @return {Wrapper} this
  #
  undelegate: (event)->
    for hash in delegation_listeners(arguments, @)
      @no(hash.e, hash.c)

    return @

  #
  # Checks if there is sucha delegative event listener
  #
  #     :js
  #     $(element).delegates('#css.rule');
  #     $(element).delegates('#css.rule', 'click');
  #     $(element).delegates('#css.rule', 'click', function() {});
  #     $(element).delegates('#css.rule', 'click', 'addClass', 'boo');
  #     $(element).delegates('#css.rule', 'click', 'hide');
  #
  #     $(element).delegates('#css.rule', {
  #       click: function() {},
  #       focus: 'hide',
  #       blur:  ['addClass', 'boo']
  #     });
  #
  # __NOTE__: if several rules are specified then it will check if
  #       _any_ of them are delegateed
  #
  # @param {String} css-rule
  # @param {String|Object} event-name or a hash of event handlers
  # @param {Function} callback
  # @return {Boolean} check result
  #
  delegates: ->
    delegation_listeners(arguments, @).length is 0


#
# Returns the list of delegative listeners that match the conditions
#
# @param {Arguments} raw-arguments
# @param {Element} the element
# @return {Array} list of matching listeners
#
delegation_listeners = (args, object)->
  args     = A(args)
  css_rule = args.shift()
  event    = args.shift()
  callback = args.shift()
  result   = []

  if typeof(event) is 'string'
    for hash in object._listeners
      if hash.dr is css_rule and (!event or hash.e is event)
        if !callback or hash.dc is callback
          result.push(hash)

  else # assuming it's a hash
    for args, callback of event
      result = result.concat(delegation_listeners([css_rule, args]
      .concat(ensure_array(callback)), object))

  result


# hooking the API to the `Element` and `Document`
Element.include  Events_delegation
Document.include Events_delegation