#
# The forms specific dom-wrapper
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Form extends Element

  #
  # Basic constructor
  #
  #    new Form(raw_dom_form)
  #    new Form(method: 'post', action: '/some.url')
  #
  # @param {HTMLFormElement|Object} raw dom-form or a set of options
  # @param {Object} options
  # @return {Form} this
  #
  constructor: (element, options) ->
    if !element or (!isElement(element) and isObject(element))
      options = element || {}
      element = 'form'
      remote  = 'remote' of options
      delete(options.remote)

    super(element, options)

    @remotize() if remote and @remotize

    return @


# making the methods with Search shortcuts
Form.include = Element.include
Form.include

  #
  # Returns the form elements as an array of extended units
  #
  # @return {dom.Search} list of elements
  #
  elements: ->
    @find('input,button,select,textarea')

  #
  # Returns the list of all the input elements on the form
  #
  # @return {dom.Search} list of elements
  #
  inputs: ->
    @elements().filter (input)->
      !(input._.type in ['submit', 'button', 'reset', 'image', null])

  #
  # Accessing an input by name
  #
  # @param {String} name
  # @return {Input} field
  #
  input: (name)->
    @first "*[name=\"#{name}\"]"

  #
  # Focuses on the first input element on the form (if any)
  #
  # @return {Form} this
  #
  focus: ->
    for element in @inputs()
      element.focus(); break;
    return @

  #
  # Removes focus out of all the form elements
  #
  # @return {Form} this
  #
  blur: ->
    @elements().forEach('blur')
    return @

  #
  # disables all the elements on the form
  #
  # @return {Form} this
  #
  disable: ->
    @elements().forEach('disable')
    return @

  #
  # enables all the elements on the form
  #
  # @return {Form} this
  #
  enable: ->
    @elements().forEach('enable')
    return @

  #
  # returns the list of the form values
  #
  # @return {Object} values
  #
  values: ->
    values = {}

    @inputs().forEach (element)->
      input = element._
      name  = input.name

      if !input.disabled and name and (!(input.type in ['checkbox', 'radio']) || input.checked)
        value = element.value()

        if name.substr(name.length - 2) is '[]'
          value = (values[name] || []).concat([value])

        values[name] = value

    return values

  #
  # Delegating the submit method
  #
  # @return {Form} this
  #
  submit: ->
    @_.submit()
    return @

  #
  # Delegating the 'reset' method
  #
  # @return {Form} this
  #
  reset: ->
    @_.reset()
    return @

