#
# Document level hooks for the widget
#
default_zoom = new Zoom()

$(document).on
  click: (event)->
    if link = event.find('a[data-zoom]')
      event.stop()
      default_zoom.show(link)