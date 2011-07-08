#
# CSS search and dom-collections handling interface
#
#     new Search('css-rule')
#     new Search('css-rule', context)
#     new Search([raw1, raw2, raw3])
#     new Search('<div>some html</div>')
#
# `Search` is a subclass of `Lovely.List` which is a
# subclass of plain `Array`, so you can simply iterate
# through it
#
#     for element in new Search('css-rule')
#       element.addClass('boo-hoo')
#
# You also can use any JavaScript 1.8 methods with it
# on any browser
#
#     new Search('css-rule').filter (item)->
#       item.hasClas('boo-hoo')
#
# And you can make calls-by-name which are allowed by the
# `Lovely.List` unit
#
#     new Search('css-rule')
#       .filter('hasClass', 'boo-hoo')
#       .each('removeClass', 'trololo')
#
# NOTE: all the items on the list will be wrapped with
#       the {Element} instances, so it you do `search[0]`
#       it will return an {Element} not a raw dom-element
#
#       to access the raw dom element, use the standard
#       `_` property. `search[0]._`
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Search extends core.List

  #
  # Basic constructor
  #
  # @param {String|Iterable} css-rule or a list of raw dom items
  # @param {HTMLElemnt|Element|document} the search context
  # @return {Search} result
  #
  constructor: (css_rule, context) ->
    if typeof(css_rule) is 'string'

      if css_rule[0] is '<' # '<div>boo hoo</div>' to node-list conversion
        return new Element('div').html(css_rule).children()
      else if /^#[^ \.\[:]+$/i.test(css_rule)
        css_rule = [document.getElementById(css_rule.substr(1))] # quick by-id search
      else
        context  = current_Document  if `context == null`
        context  = wrap(context)     unless context instanceof Wrapper
        css_rule = context.find(css_rule, true)

    @length = css_rule.length

    for element,i in css_rule
      @[i] = if element instanceof Element then element else wrap(element)

    return @

# private


# the standard search interface, used in {Element} and {Document}
Search_module =
  #
  # Finds _all_ matching sub-elements
  #
  # @param {String} css-rule
  # @param {Boolean} marker if you want an Array of raw dom-elements
  # @return {Search|Array} matching elements collection
  #
  find: (css_rule, needs_raw)->
    result = @_.querySelectorAll(css_rule||'*')
    if needs_raw then result else new Search(result)

  #
  # Finds the _first_ matching sub-element, or just the first
  # element if no css-rule was specified
  #
  # @param {String} css-rule
  # @return {Element} matching element or `null`
  #
  first: (css_rule)->
    if css_rule is undefined && @_.firstElementChild isnt undefined
      element = @_.firstElementChild
    else
      element = @_.querySelector(css_rule||'*')

    wrap(element)

