#
# Various utility stuff
#

merge_options = (options, defaults)->
  options          or= {}

  for key, value of defaults
    options[key] or= value

  options['class'] += ' ' if options['class']
  options['class'] += defaults['class']

  options

#
# Resolves an element reference to a raw html element
#
raw_element = (element)->
  element = element[0] if element instanceof dom.NodeList
  element = element._  if element instanceof Element

  element if element && element.nodeType is 1