#
# Input fields common dom-wrappers
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
class Input extends Element
  #
  # Constructor
  #
  # __NOTE__: this constructor can be called in several ways
  #
  # Like normal Element
  #
  #     :js
  #     var input = new Input('texarea', {...});
  #     var input = new Input(document.createElement('select'));
  #
  # Or with options only which will make an INPUT element by default
  #
  #     :js
  #     var input = new Input({type: 'password', name: 'password'});
  #
  # @param {HTMLElement|String|Object} raw dom elemnt, tag name or options
  # @param {Object} options
  # @return {Input} this
  #
  constructor: (element, options)->
    # type to tag name conversion
    if !element or (!isElement(element) and isObject(element))
      options = element || {}

      if /textarea|select/.test(options.type || '')
        element = options.type
        delete(options.type)
      else
        element = 'input'

    super element, options


# making the methods with NodeList shortcuts
Input.include = Element.include
Input.include

  #
  # Returns a reference to the input's form
  #
  # @return {Form} wrapped form
  #
  form: ->
    wrap(@_.form)

  #
  # Overloading the method to fix some issues with IE and FF
  #
  # @param {String|HTMLElement|Element|Iterable} content
  # @param {String} optional position
  # @return {Input} this
  #
  insert: (content, position)->
    super content, position

    # manually resetting the selected option in here
    @find('option').forEach (option)->
      option._.selected = !!option.attr('selected')

    return @

  #
  # Overloading the method so it always called the '#insert' method
  #
  # @param {String|HTMLElement|Element|Iterable} content
  # @return {Input} this
  #
  update: (content)->
    @clear().insert(content)


  #
  # The elements value getter/setter
  #
  # @param {String} new value
  # @return {Input|String} self-reference or current value
  #
  value: (value)->
    if value is undefined
      value = @_.value
      if @_.type is 'select-multiple'
        value = []
        @find('option').forEach (option)->
          value.push(option._.value) if option._.selected
          return # nothing

      return value

    else
      if @_.type is 'select-multiple'
        value = L(if isArray(value) then value else [value])

        @find('option').forEach (option)->
          option._.selected = value.indexOf(option._.value) isnt -1

      else
        @_.value = value

    return @


  #
  # Places the focus on this input field
  #
  # @return {Input} this
  #
  focus: ->
    @_.focus()
    @focused = true
    return @

  #
  # Makes the field to loose the focus
  #
  # @return {Input} this
  #
  blur: ->
    @_.blur()
    @focused = false
    return @

  #
  # Focuses on the element and selects its content
  #
  # @return {Input} this
  #
  select: ->
    @_.select()
    @focused = true
    return @

  #
  # Disables the field
  #
  # @return {Input} this
  #
  disable: ->
    @_.disabled = true
    return @emit('disable')

  #
  # Enables this field
  #
  # @return {Input} this
  #
  enable: ->
    @_.disabled = false
    return @emit('enable')

  #
  # A bidirectional method to set/get the disabled status of the input field
  #
  # @param {Boolean} optional value
  # @return {Input} in setter mode boolean in getter
  #
  disabled: (value)->
    if value is undefined
      @_.disabled
    else
      @[if value then 'disable' else 'enable']()

  #
  # A bidirectional method to set/get the checked status of the input field
  #
  # @param {Boolean} optional value
  # @return {Input} in setter mode boolean in getter
  #
  checked: (value)->
    if value is undefined
      return @_.checked
    else
      @_.checked = value
      return @