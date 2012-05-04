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
