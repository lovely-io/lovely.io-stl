#
# Document level hooks for the widget
#

default_zoom = null

$(document).on
  click: (event)->
    if link = event.find('a[data-zoom]')
      event.stop()
      default_zoom or= new Zoom()
      default_zoom.show(link)

    else if Zoom.current && !event.find('.lui-zoom')
      Zoom.current.hide()

dummy   = document.createElement('div')
timeout = new Date()

$(window).on 'resize', ->
  if Zoom.current isnt null && (new Date() - timeout) > 2
    timeout = new Date()
    Zoom.current.limit_size(@size())