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

