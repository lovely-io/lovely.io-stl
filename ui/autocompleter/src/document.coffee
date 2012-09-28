#
# Document level hooks for the autocompleters
#
# Copyright (C) 2012 Nikolay Nemshilov
#
$(document).delegate 'input', 'focus', (event)->
  if !@autocompleter && @data('autocompleter')
    new Autocompleter(@)