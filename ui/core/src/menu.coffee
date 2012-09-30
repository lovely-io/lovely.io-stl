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
  extend:
    current: null # current menu reference

  #
  # Basic constructor
  #
  # @param {Object} html options
  # @return {Menu} this
  #
  constructor: (options)->
    options = options[0] if options instanceof dom.NodeList
    options = options._  if options instanceof Element

    if options && options.nodeType is 1
      @$super options
    else
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
  # @param {String} menu location 'bottom left', 'top-right' and so on
  # @return {Menu} this
  #
  showAt: (element, location)->
    element    = dom(element) if typeof(element) is 'string' or element.nodeType is 1
    element    = element[0] if element instanceof dom.NodeList
    position   = element.position()
    location or= 'bottom left'

    if element
      @style(visibility: 'hidden', display: 'block').insertTo(element, 'after')

      # adjusting the position for specified location
      position.y += element.size().y               if location.indexOf('bottom') isnt -1
      position.x -= (@size().x - element.size().x) if location.indexOf('right')  isnt -1
      position.y -= @size().y                      if location.indexOf('top')    isnt -1

      position.y = 0 if position.y < 0
      position.x = 0 if position.x < 0

      @position(position).style(visibility: 'visible').show()

    return @

  #
  # Shows the element and emits the 'show' event
  #
  # @return {Menu} this
  #
  show: ->
    Menu.current = @constructor.current = @$super.apply(@, arguments).emit('show')

  #
  # Making the menu element to get removed out of the DOM
  #
  # @return {Menu} this
  #
  hide: ->
    Menu.current = @constructor.current = null
    @$super.apply(@, arguments).emit('hide')

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
      @currentLink.radioClass('lui-active')
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
$(document).on 'click', (event)->
  unless event.find('.lui-menu') or event.find('[data-toggle]')
    $('.lui-menu').forEach (menu)->
      menu.hide() if menu.style('position') is 'absolute'

#
# Handling keyboard navigation
#
$(document).on 'keydown', (event)->
  if Menu.current isnt null

    switch event.keyCode
      when 40 then event.preventDefault(); Menu.current.selectNext()
      when 38 then event.preventDefault(); Menu.current.selectPrevious()
      when 13 then event.preventDefault(); Menu.current.pickCurrent()
      when 27 then                         Menu.current.hide()



