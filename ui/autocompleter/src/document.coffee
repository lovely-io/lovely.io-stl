#
# Document level hooks for the autocompleters
#
# Copyright (C) 2012 Nikolay Nemshilov
#
$(document).delegate 'input', 'focus', (event)->
  if !@autocompleter && @data('autocompleter')
    new Autocompleter(@)

$(document).on 'keydown', (event)->
  if Autocompleter.current isnt null
    switch event.keyCode
      when 38 then Autocompleter.current.pickPrev()
      when 40 then Autocompleter.current.pickNext()
      when 13 then Autocompleter.current.complete()
      when 27 then Autocompleter.current.hide()
