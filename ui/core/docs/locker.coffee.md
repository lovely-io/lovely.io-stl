A generic locker unit

Copyright (C) 2012 Nikolay Nemshilov

```coffee-aside
class Locker extends Element
```

Basic constructor

@param {Object} html options
@return {Locker} self

```coffee-aside
  constructor: (options)->
    options = merge_options(options, class: 'lui-locker')
    spinner_size = options.size || Spinner.Options.size
    delete(options.size)
    super('div', options)
    @insert(@spinner = new Spinner(size: spinner_size, class: 'lui-inner'))
```
