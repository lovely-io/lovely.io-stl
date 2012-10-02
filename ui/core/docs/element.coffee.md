The 'dom' package `Element#on` method overload

Copyright (C) 2011-2012 Nikolay Nemshilov

```coffee-aside
for Unit in [Element, Document, Window]
  do (Unit)->
    original_method = Unit::on

    Unit::on = (name)->
      args = A(arguments)
      name = args[0]

      if typeof(name) is 'string'
        if name.indexOf(',') is -1
          key = name.split(/[\+\-\_ ]+/)
          key = (key[key.length - 1] || '').toUpperCase()

          if key of Event.Keys || /^[A-Z0-9]$/.test(key)
            meta   = /(^|\+|\-| )(meta|alt)(\+|\-| )/i.test(name)
            ctrl   = /(^|\+|\-| )(ctl|ctrl)(\+|\-| )/i.test(name)
            shift  = /(^|\+|\-| )(shift)(\+|\-| )/i.test(name)
            code   = Event.Keys[key] || key.charCodeAt(0)
            orig   = args.slice(1)
            method = orig.shift()

            if typeof(method) is 'string'
              method = this[method] || ->

            # replacing the arguments
            args = ['keydown', (event)->
              if (event.keyCode is code) and
                 (!meta  or event.metaKey or event.altKey) and
                 (!ctrl  or event.ctrlKey) and
                 (!shift or event.shiftKey)

                return method.apply(this, [event].concat(orig))
            ]
        else
          for key in name.split(',')
            args[0] = key; @on.apply(@, args)

      original_method.apply(this, args)
```
