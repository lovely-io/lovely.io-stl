#
# DOM-collections handling interface
#
#     :coffee
#     new NodeList([raw1, raw2, raw3])
#
# {NodeList} is a subclass of the {core.List} which is a
# subclass of plain {Array}, so you can simply iterate
# through it
#
#     :coffee
#     for element in new NodeList([e1, e2, e3])
#       element.addClass('boo-hoo')
#
# You also can use any JavaScript 1.8 methods with it
# on any browser
#
#     :coffee
#     new NodeList([e1,..]).filter (item)->
#       item.hasClas('boo-hoo')
#
# And you can make calls-by-name which are allowed by the
# {core.List} unit
#
#     :coffee
#     new NodeList([e1, e2, ...])
#       .filter('hasClass', 'boo-hoo')
#       .each('removeClass', 'trololo')
#
# __NOTE__: all the items on the list will be wrapped with
#       the {Element} instances, so it you do `list[0]`
#       it will return an {Element} not a raw dom-element
#       to access the raw dom element, use the standard
#       `_` property. `list[0]._`
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
class NodeList extends core.List

  #
  # Basic constructor
  #
  # @param {Iterable} raw dom nodes list
  # @return {NodeList} this
  #
  constructor: (raw_list)->
    `for (var i=0, l=this.length=raw_list.length, key; i < l; i++) {
      if ('_' in raw_list[i]) {
        this[i] = raw_list[i];
      } else {
        key = uid(raw_list[i]);
        this[i] = key in Wrapper.Cache ? Wrapper.Cache[key] : new Element(raw_list[i]);
      }
    }`

    return this