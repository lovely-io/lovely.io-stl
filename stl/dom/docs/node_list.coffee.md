DOM-collections handling interface

    new NodeList([raw1, raw2, raw3])

{NodeList} is a subclass of the {core.List} which is a
subclass of plain {Array}, so you can simply iterate
through it

    for element in new NodeList([e1, e2, e3])
      element.addClass('boo-hoo')

You also can use any JavaScript 1.8 methods with it
on any browser

    new NodeList([e1,..]).filter (item)->
      item.hasClas('boo-hoo')

And you can make calls-by-name which are allowed by the
{core.List} unit

    new NodeList([e1, e2, ...])
      .filter('hasClass', 'boo-hoo')
      .each('removeClass', 'trololo')

__NOTE__: all the items on the list will be wrapped with
      the {Element} instances, so it you do `list[0]`
      it will return an {Element} not a raw dom-element
      to access the raw dom element, use the standard
      `_` property. `list[0]._`

Copyright (C) 2011-2012 Nikolay Nemshilov

```coffee-aside
class NodeList extends core.List
```

Basic constructor

@param {Iterable} raw dom nodes list
@param {Boolean} marker if there are raw items only on the list
@return {NodeList} this

```coffee-aside
  constructor: (raw_list, raw_only)->
    if raw_only is true
      `for (var i=0, l=this.length=raw_list.length, key; i < l; i++) {
        this[i] = Wrapper_Cache[raw_list[i][UID_KEY]] || new Element(raw_list[i]);
      }`
    else
      raw_list = [] if raw_list is undefined
      `for (var i=0, l=this.length=raw_list.length, key; i < l; i++) {
        this[i] = raw_list[i] instanceof Element ? raw_list[i] : (Wrapper_Cache[raw_list[i][UID_KEY]] || new Element(raw_list[i]));
      }`

    return this
```

Syntax sugar for elements existance checks

    if $('#my-element').exists()
      console.log("Awesome!")
    else
      console.log("Bumer :/")

@return {Boolean} check result

```coffee-aside
  exists: ->
    @length isnt 0
```
