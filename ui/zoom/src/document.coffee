#
# Document level hooks for the widget
#
hide_all_zooms = ->
  $('.lui-zoom').forEach('remove')

default_zoom = new Zoom()

$(document).on
  click: (event)->
    if link = event.find('a[data-zoom]')
      event.stop()
      default_zoom.show(link)
    else if !event.find('div.lui-zoom')
      hide_all_zooms()

  esc: hide_all_zooms
