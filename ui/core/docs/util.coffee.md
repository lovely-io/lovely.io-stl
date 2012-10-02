Various utility stuff

```coffee-aside

merge_options = (options, defaults)->
  options          or= {}

  for key, value of defaults
    options[key] or= if key is 'class' then '' else value

  options['class'] += if options['class'] then ' ' else ''
  options['class'] += defaults['class']

  options


# checking the css-transform / css-animation support

css_prefixes  = 'WebkitA MozA msA OA a'.split(' ')
css_animation = false

while (css_prefix = css_prefixes.pop())
  if document.body.style[css_prefix + 'nimation'] isnt undefined
    css_animation = css_prefix + 'nimation'
    break

css_prefixes = 'WebkitT MozT msT OT t'.split(' ')
css_transform = false

while (css_prefix = css_prefixes.pop())
  if document.body.style[css_prefix + 'ransform'] isnt undefined
    css_transform = css_prefix + 'ransform'
    break
```
