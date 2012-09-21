Defines the common class for all the dom-wrappers

Copyright (C) 2011 Nikolay Nemshilov

```coffee-aside
class Wrapper
  extend:
    Cache: [] # the dom-wrappers registry
    Tags:  {} # tags specific wrappers
```

Sets a default dom wrapper for the tag

@param {String} tag name
@param {Element} tag specific dom-wrapper
@return {Wrapper} this

```coffee-aside
    set: (tag, wrapper)->
      Wrapper.Tags[tag.toUpperCase()] = wrapper
      Wrapper
```

Tries to return a tag-specific dom-wrapper for the tag

@param {String} tag name
@return {Element} wrapper of `undefined`

```coffee-aside
    get: (tag)->
      Wrapper.Tags[tag.toUpperCase()]
```

Removes a default tag-specific dom-wrapper for the tag

@param {String} tag name
@return {Wrapper} this

```coffee-aside
    remove: (tag)->
      delete Wrapper.Tags[tag.toUpperCase()]
      Wrapper
```

Tries to find a suitable dom-wrapper
for the element. Used by {Element}
to perform dynamic typecasting

@param {HTMLElement} element
@return {Wrapper} suitable wrapper or `undefined`

```coffee-aside
    Cast: (element) ->
      Wrapper.Tags[element.tagName]


  _: null # the standard raw dom-unit reference
```

Basic constructor

@param {mixed} raw dom-unit
@return {Wrapper} this

```coffee-aside
  constructor: (dom_unit) ->
    this._ = dom_unit
    Wrapper.Cache[uid(dom_unit)] = this
```

Recast the raw dom unit into the new class

@param {Function} new class
@return {Object} of the new class

```coffee-aside
  cast: (Klass)->
    if @ instanceof Klass
      return @
    else
      new Klass(@_)


NodeList::cast = (Klass)->
  @[0].cast(Klass)
```
