#
# This module provides correctly bubbling
# form `submit` and `change` events for old IE browsers
#
# Copyright (C) 2011 Nikolay Nemshilov
#

#
# Tests if there is the event support
#
# @param {String} event name
# @retrun {Boolean} check result
#
no_event_support = (name, tag)->
  e = document.createElement(tag)
  e.setAttribute(name, ';')
  typeof(e[name]) isnt 'function'


if BROWSER_OLD_IE and no_event_support('onsubmit', 'form')
  #
  # Emulates the 'submit' event bubbling for IE browsers
  #
  # @param {HTMLEvent} raw dom-event
  # @return void
  #
  submit_boobler = (event)->
    element = event.srcElement
    type    = element.type
    form    = element.form && wrap(element.form)
    parent  = form && form.parent()

    if parent && (
      (event.keyCode is 13   && (type is 'text'   || type is 'password')) ||
      (event.type is 'click' && (type is 'submit' || type is 'image'))
    )
      event        = wrap(event)
      event.type   = 'submit'
      event.target = form
      parent.emit(event)

  document.attachEvent('onclick',    submit_boobler)
  document.attachEvent('onkeypress', submit_boobler)


if BROWSER_OLD_IE and no_event_support_for('onchange', 'input')
  #
  # Extracts the input field value
  #
  # @param {HTMLInputElement} input field
  # @return {String|Boolean} field value
  #
  get_input_value = (element) ->
    if element.type in ['radio', 'checkbox'] then element.checked
    else element.value

  #
  # Emulates the 'change' event bubbling
  #
  # @param {HTMLEvent} raw dom-event
  # @param {HTMLElement} raw input element
  # @return void
  #
  change_boobler = (event, target) ->
    parent = target.parentNode
    value  = get_input_value(target)

    if parent && ''+target._prev_value isnt ''+value
      target._prev_value = value # saving the value so it didn't fire up again
      event      = wrap(event)
      event.type = 'change'
      wrap(parent).emit(event)

    return #nothing

  #
  # Catches the input field changes
  #
  # @param raw dom-event
  # @return void
  #
  catch_inputs_access = (event) ->
    target = event.srcElement
    type   = target.type
    tag    = target.tagName
    input_is_radio = type in ['radio', 'checkbox']

    if (
      (event.type is 'click'   and (input_is_radio or tag is 'SELECT')) or
      (event.type is 'keydown' and (
        (event.keyCode is 13 and (tag isnt 'TEXTAREA')) or
        type is 'select-multiple'
      ))
    )
      change_boobler(event, target)

  #
  # Catch inputs blur
  #
  # @param {HTMLEvent} raw dom-event
  # @return void
  #
  catch_input_left = (event)->
    target = event.srcElement

    if target.type && target.form # if it's an input field
      change_boobler(event, target)

    return #nothing


  document.attachEvent('onclick',    catch_inputs_access)
  document.attachEvent('onkeydown',  catch_inputs_access)
  document.attachEvent('onfocusout', catch_input_left)

  #
  # storing the input element previous value, so we could figure out
  # if it was changed later on
  #
  document.attachEvent 'onbeforeactivate', (event)->
    element = event.srcElement

    if target.type && target.form # if it's an input field
      element._prev_value = get_input_value(element)

    return #nothing