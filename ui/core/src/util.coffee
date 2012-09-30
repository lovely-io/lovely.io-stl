#
# Various utility stuff
#

merge_options = (options, defaults)->
  options          or= {}

  for key, value of defaults
    options[key] or= if key is 'class' then '' else value

  options['class'] += if options['class'] then ' ' else ''
  options['class'] += defaults['class']

  options
