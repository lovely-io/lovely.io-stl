#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class Tabs extends Element
  include: core.Options
  extend:
    Options: # default options
      idPrefix: ''

  #
  # Default constructor
  #
  constructor: (element, options)->
    options = ext({}, options)

    try
      options = ext(options, JSON.parse(element.getAttribute('data-tabs')))
    catch e

    @setOptions(options)
    for key of Tabs.Options
      delete(options[key])

    super element, options

    @addClass('lui-tabs').style({visibility: 'visible'})

    @nav = @first('nav,ul').on 'click', (event)=>
      if link = event.find('a')
        event.preventDefault()
        @select @nav.find('a').indexOf(link)

    @select(0)

  #
  # Selects a tab by an _integer_ index or panels _string_ ID
  #
  # @param {numeric|String} tab index or ID
  # @return {Tabs} this
  #
  select: (index)->
    links  = @nav.find('a')
    panels = @children()

    switch typeof(index)
      when 'number' then link = links[index]
      when 'string' then link = links.first (i)-> i._.getAttribute('href').substr(1) is index

    if link = (link || links[0])
      id    = @options.idPrefix + link._.getAttribute('href').substr(1)
      panel = panels.filter((p)-> p._.id is id)[0]

      if panel
        @current_link.removeClass('lui-tabs-current')  if @current_link
        @current_panel.removeClass('lui-tabs-current') if @current_panel

        @current_link  = link.addClass('lui-tabs-current')
        @current_panel = panel.addClass('lui-tabs-current')

        @emit 'select', index: links.indexOf(link), link: link, panel: panel

    return @