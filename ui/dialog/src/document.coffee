#
# Document level key hooks
#
# Copyright (C) 2012 Nikolay Nemshilov
#
$(document).on 'enter', (event)->
  dialog = UI.Modal.current
  if dialog isnt null && dialog instanceof Dialog && !(event.target instanceof $.Input)
    dialog.emit('ok')