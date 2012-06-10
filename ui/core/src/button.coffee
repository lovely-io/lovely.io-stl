#
# A generic ui-button class
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Button extends Input

  #
  # Basic constructor, can receive some additional HTML options
  #
  # @param {String} caption
  # @param {Object} options
  # @return {Button} self
  #
  constructor: (html, options)->
    options = merge_options(options, {
      type: 'button', html: html, class: 'lui-button'
    })

    super('button', options)

    @on 'mousedown', (event)-> event.preventDefault()


#
# Dropdown menus handling
#
$(document).delegate '.lui-button[data-toggle]', 'mousedown,touchstart', (event)->
  if menu = $(@data('toggle'))[0]
    unless menu instanceof Menu
      menu = new Menu(menu)
      menu.on 'show', => @addClass('lui-active')
      menu.on 'hide', => @removeClass('lui-active')

    if Menu.current
      Menu.current.hide()
    else
      menu.showAt(@, 'bottom-right')

$(document).delegate '.lui-button[data-toggle]', 'click', (event)->
  event.preventDefault()