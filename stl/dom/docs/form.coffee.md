The forms specific dom-wrapper

Copyright (C) 2011-2012 Nikolay Nemshilov

```coffee-aside
class Form extends Element
```

Basic constructor

    :js
    new Form(raw_dom_form)
    new Form(method: 'post', action: '/some.url')

@param {HTMLFormElement|Object} raw dom-form or a set of options
@param {Object} options
@return {Form} this

```coffee-aside
  constructor: (element, options) ->
    if !element or (!isElement(element) and isObject(element))
      options = element || {}
      element = 'form'
      remote  = 'remote' of options
      delete(options.remote)

    super(element, options)

    @remotize() if remote and @remotize

    return @


# making the methods with NodeList shortcuts
Form.include = Element.include

Form.include
```

Returns the form elements as an array of extended units

@return {NodeList} list of elements

```coffee-aside
  elements: ->
    @find('input,button,select,textarea')
```

Returns the list of all the input elements on the form

@return {NodeList} list of elements

```coffee-aside
  inputs: ->
    @elements().filter (input)->
      !(input._.type in ['submit', 'button', 'reset', 'image', null])
```

Accessing an input by name

@param {String} name
@return {Input} field

```coffee-aside
  input: (name)->
    inputs = @find "*[name=\"#{name}\"]"

    if inputs.length isnt 0 && inputs[0]._.type is 'radio'
      inputs
    else
      inputs[0]
```

Focuses on the first input element on the form (if any)

@return {Form} this

```coffee-aside
  focus: ->
    for element in @inputs()
      element.focus(); break;
    return @
```

Removes focus out of all the form elements

@return {Form} this

```coffee-aside
  blur: ->
    @elements().forEach('blur')
    return @
```

disables all the elements on the form

@return {Form} this

```coffee-aside
  disable: ->
    @elements().forEach('disable')
    return @
```

enables all the elements on the form

@return {Form} this

```coffee-aside
  enable: ->
    @elements().forEach('enable')
    return @
```

returns the list of the form values

@return {Object} values

```coffee-aside
  values: ->
    values = {}

    @inputs().forEach (element)->
      input = element._
      name  = input.name
      hash  = values
      keys  = name.match(/[^\[]+/g)

      if !input.disabled and name and (!(input.type in ['checkbox', 'radio']) || input.checked)
        # getting throught the smth[smth][smth][] in the name
        while keys.length > 1
          key  = keys.shift()
          key  = key.substr(0, key.length-1) if key[key.length-1] is ']'
          hash = (hash[key] or= (if keys[0] is ']' then [] else {}))

        key  = keys.shift()
        key  = key.substr(0, key.length-1) if key[key.length-1] is ']'

        if key is '' # an array
          hash.push(element.value())
        else
          hash[key] = element.value()

      return # nothing

    return values
```

Delegating the submit method

@return {Form} this

```coffee-aside
  submit: ->
    @_.submit()
    return @
```

Delegating the 'reset' method

@return {Form} this

```coffee-aside
  reset: ->
    @_.reset()
    return @
```
