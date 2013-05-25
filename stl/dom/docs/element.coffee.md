Defines the basic dom-element wrapper

Copyright (C) 2011-2013 Nikolay Nemshilov

```coffee-aside
class Element extends Wrapper
```

Basic constructor

@param {String|HTMLElement} tag name or a raw dom-element
@param {Object} new element options
@return {Element} instance

```coffee-aside
  constructor: (element, options)->
    # making a dom-element by the tag-name
    if typeof(element) is 'string'
      element = elements_cache[element] || (elements_cache[element] = document.createElement(element))
      element = element.cloneNode(false)

    Wrapper.call(this, element)

    if `options != null`
      for key of options
        switch key
          when 'id'    then @_.id        = options[key]
          when 'html'  then @_.innerHTML = options[key]
          when 'class' then @_.className = options[key]
          when 'style' then @style         options[key]
          when 'on'    then @on            options[key]
          else              @attr     key, options[key]

    return this
```

making the Element to automatically generate the dom-collection
methods for the {NodeList} class with the following principle

if this is an element's mutating method and it returns a
reference to the element itself, then this method will be called
on all the elements in the collection.

on the other hand, if this is a getter method and it returns
some value that is different from the element itself, then
the collection method will return the result of that method
call on the _first_ element in the collection

```coffee-aside
Element.include = (hash)->
  Class.include.apply(this, arguments)

  for name, method of hash
    do (name)->
      unless name of core.List.prototype
        NodeList.prototype[name] = ->
          for element, i in @
            result = element[name].apply(element, arguments)
            return result if i is 0 and result isnt element

          # returning null if there are no items on the list
          # in case the user asked for data, otherwise returning
          # the search itself so that the user could chain the calls
          return if @length is 0 then null else @
```

Resolves any sort of element's reference into an {Element} instance

    :js
    Element.resolve('#css-rule');
    Element.resolve(document.getElementById('my-element'));
    Element.resolve(new Element('div'));
    Element.resolve($('#css-rule'));

@param {String|HTMLElement|dom.Element|dom.NodeList}
@return {Element} wrapper or `null`

```coffee-aside
Element.resolve = (element)->
  if element instanceof Element
    return element
  else if typeof(element) is 'string'
    element = $(element)[0]
  else if element instanceof NodeList
    element = element[0]
  else if `element != null && element.nodeType === 1`
    return wrap(element)

  return element || null


# private
# the dom-elements cache, for quicker instantiation
elements_cache = {}
```
