The `Wrapper` auto-casting extensions
we keep them in a separated file so that
they weren't copied over to the actual wrappers

Copyright (C) 2013 Nikolay Nemshilov

```coffee-aside
ext Wrapper,
  Cache: Wrapper_Cache # the dom-wrappers registry
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

Finds appropriate wrapper for the raw-dom element

```coffee-aside
  find: (element)->
    Wrapper.Tags[element.tagName] || Element
```
