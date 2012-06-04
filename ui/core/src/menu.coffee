#
# The drop-down menu unit
#
# Events:
#   * `show` when the menu is shown
#   * `hide` when the menu is hidden
#   * `pick` when an item in the menu is picked
#   * `select` when an item in the menu is selected
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

    @on 'click', (event)->
      if (link = event.find('a')) && link.parent() is @
        @emit('pick', link: link)

    @on 'mouseover', (event)->
      if (link = event.find('a')) && link.parent() is @
        @emit('select', link: link)

    @on 'pick', 'hide'

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
      @position
        x: element.position().x
        y: element.position().y + element.size().y

      @insertTo(element, 'after').show()

    return @

  #
  # Shows the element and emits the 'show' event
  #
  # @return {Menu} this
  #
  show: ->
    Modal.current = @constructor.current = @$super().emit('show')

  #
  # Making the menu element to get removed out of the DOM
  #
  # @return {Menu} this
  #
  hide: ->
    Modal.current = @constructor.current = null
    @$super().emit('hide').remove()

  #
  # Selects the next link on the menu
  #
  # @return {Menu} this
  #
  selectNext: (step=1)->
    links = @children('a')

    index = links.indexOf(@currentLink) + step
    index = links.length - 1 if index > links.length - 1
    index = 0                if index < 0

    if @currentLink = links[index]
      @currentLink.radioClass('lui-menu-selected')
      @emit 'select', link: @currentLink

    return @



  #
  # Selects the previous link on the menu
  #
  # @return {Menu} this
  #
  selectPrevious: ->
    @selectNext(-1)

  #
  # Picks the currently selected item on the menu
  #
  # @return {Menu} this
  #
  pickCurrent: ->
    @emit('pick', link: @currentLink) if @currentLink
    return @

#
# Making all the hanging menus to get closed on menu clicks
#
dom(document).on 'click', (event)->
  unless event.find('.lui-menu')
    dom('.lui-menu').forEach (menu)->
      menu.hide() if menu.style('position') is 'absolute'

#
# Handling keyboard navigation
#
dom(document).on 'keydown', (event)->
  if Modal.current isnt null

    switch event.keyCode
      when 40 then event.preventDefault(); Modal.current.selectNext()
      when 38 then event.preventDefault(); Modal.current.selectPrevious()
      when 13 then event.preventDefault(); Modal.current.pickCurrent()
      when 27 then                         Modal.current.hide()



