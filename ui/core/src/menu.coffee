#
# The drop-down menu unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Menu extends Element

  #
  # Basic constructor
  #
  # @param {Object} html options
  # @return {Menu} this
  #
  constructor: (options)->
    @$super 'nav', options
    @addClass 'lui-menu'


  #
  # Shows the menu at the element
  #
  # @param {String|HTMLElement|dom.Element|dom.NodeList} element reference
  # @return {Menu} this
  #
  showAt: (element)->
    element = dom(element) if typeof(element) is 'string' or element.nodeType is 1
    element = element[0] if element instanceof dom.NodeList

    if element
      @insertTo(element, 'after').position
        x: element.position().x
        y: element.position().y + element.size().y

      @show().emit 'show'


    return @

  #
  # Making the menu element to get removed out of the DOM
  #
  # @return {Menu} this
  #
  hide: ->
    @$super().remove()


#
# Making all the hanging menus to get closed on menu clicks
#
dom(document).on 'click', (event)->
  unless event.find('.lui-menu')
    dom('.lui-menu').forEach (menu)->
      menu.hide() if menu.style('position') is 'absolute'
