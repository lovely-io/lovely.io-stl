A generic Icon class

Copyright (C) 2012 Nikolay Nemshilov

```coffee-aside
class Icon extends Element
```

Basic constructor

@param {String} icon name/type
@param {Object} html options if necessary
@return {Icon} self

```coffee-aside
  constructor: (name, options)->
    options or= {}
    options['class'] or= ''
    options['class'] += ' ' if options['class'] isnt ''
    options['class'] += 'lui-icon-'+ name

    super('i', options)

    @on 'mousedown', (event)-> event.preventDefault()
```
