#
# This module handles the events delegation API
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Events_delegation =
  #
  # Attaches a delegative event listener to the element/document
  #
  #    $(element).delegate('click', '#css.rule', function() {...});
  #    $(element).delegate('click', '#css.rule', 'addClass', 'boo');
  #    $(element).delegate('click', '#css.rule', 'hide');
  #
  #    $(element).delegate('click', {
  #      '#css.rule1': function() {},
  #      '#css.rule3': ['addClass', 'boo'],
  #      '#css.rule4': 'hide'
  #    });
  #
  # @param {String} event name
  # @param {String|Object} css-rule a hash or rules
  # @param {Function} callback
  # @return {Wrapper} this
  #/
  delegate: (event)->
    for list, css_rule of delegation_rules(arguments)
      for entry in list
        # registering the delegative listener
        @on(event, build_delegative_listener(css_rule, entry, @))

        # adding the css-rule and callback references to the store
        ext @_listeners.last[@_listeners.length - 1],
          dr: css_rule, dc: entry[0]

    return @

  #
  # Removes a delegative event listener from the element
  #
  #    $(element).undelegate('click');
  #    $(element).undelegate('click', '#css.rule');
  #    $(element).undelegate('click', '#css.rule', function() {});
  #    $(element).undelegate('click', '#css.rule', 'addClass', 'boo');
  #    $(element).undelegate('click', '#css.rule', 'hide');
  #
  #    $(element).undelegate('click', {
  #      '#css.rule1': function() {},
  #      '#css.rule3': ['addClass', 'boo'],
  #      '#css.rule4': 'hide'
  #    });
  #
  # @param {String} event name
  # @param {String|Object} css-rule or a hash or rules
  # @param {Function} callback
  # @return {Wrapper} this
  #/
  undelegate: (event)->
    for hash in delegation_listeners(arguments, @)
      @no(hash.e, hash.c)

    return @

  #
  # Checks if there is sucha delegative event listener
  #
  #    $(element).delegates('click');
  #    $(element).delegates('click', '#css.rule');
  #    $(element).delegates('click', '#css.rule', function() {});
  #    $(element).delegates('click', '#css.rule', 'addClass', 'boo');
  #    $(element).delegates('click', '#css.rule', 'hide');
  #
  #    $(element).delegates('click', {
  #      '#css.rule1': function() {},
  #      '#css.rule3': ['addClass', 'boo'],
  #      '#css.rule4': 'hide'
  #    });
  #
  # NOTE:
  #    if several rules are specified then it will check if
  #    _any_ of them are delegateed
  #
  # @param {String} event name
  # @param {String|Object} css-rule or a hash of rules
  # @param {Function} callback
  # @return {Boolean} check result
  #
  delegates: ->
    delegation_listeners(arguments, @).length is 0


#
# Builds the actual event listener that will delegate stuff
# to other elements as they reach the element where the listener
# attached
#
# @param {String} String css rule
# @param {Arguments} Arguments the original arguments list
# @param {Wrapper} Object scope
# @return {Function} the actual event listener
#
build_delegative_listener = (css_rule, entry, scope)->
  args = A(entry); callback = args.shift()

  (event)->
    target = event.find(css_rule)

    if target is null
      return target
    else if typeof(callback) is 'string'
      return target[callback].apply(target, args)
    else
      return callback.apply(target, [event].concat(args))

#
# Converts the events-delegation api arguments
# into a systematic hash of rules
#
# @param {Arguments} arguments
# @return {Object} hash of rules
#
delegation_rules = (raw_args)->
  args     = A(raw_args)
  rules    = args[1] || {}
  hash     = {}
  css_rule = null

  if typeof(rules) is 'string'
    hash[rules] = args.slice(2)

    if isArray(hash[rules][0])
      hash[rules] = ensure_array(entry) for entry in hash[rules][0]

  else hash = rules

  # converting everything into a hash of lists of callbacks
  for css_rule of hash
    hash[css_rule] = ensure_array(hash[css_rule])
    hash[css_rule] = if isArray(hash[css_rule][0]) then hash[css_rule] else [hash[css_rule]]

  return hash

#
# Returns the list of delegative listeners that match the conditions
#
# @param {Arguments} raw-arguments
# @param {Element} the element
# @return {Array} list of matching listeners
#
delegation_listeners = (args, object)->
  event = args[0]
  rules = delegation_rules(args)
  rules_are_empty = Lovely.Hash.keys(rules).length is 0

  L(object._listeners || []).filter (hash)->
    hash.dr && hash.e is event && (
      rules_are_empty || do ->
        for css_rule of rules
          if hash.dr is css_rule
            for entry in rules[css_rule]
              if entry.length is 0 or entry[0] is hash.dc
                return true

        return false
    )


# hooking the API to the `Element` and `Document`
Element.include  Events_delegation
Document.include Events_delegation