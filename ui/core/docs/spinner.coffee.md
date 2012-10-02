Generic imageless spinner class

Copyright (C) 2012 Nikolay Nemshilov

```coffee-aside
class Spinner extends Element
  include: Options
  extend:
    Options:
      size:   5          # lines size
      type:   'circular' # spinner type, use 'flat' if you want a flat line of bars
      rotate: true       # if you want the spinner to be rotated with CSS3 when possible
      speed:  300        # animation speed
```

Default constructor

NOTE: this constructor can take additional `size` option
      to set how many pieces it should has

@param {Object} html-options
@return {Spinner} self

```coffee-aside
  constructor: (options)->
    @$super('div', @setOptions(options))
    @addClass('lui-spinner')
    @build()
```

Builds the spinner's internals

@return {Spinner} this

```coffee-aside
  build: ->
    @_.innerHTML =  '<div class="lui-spinner-current"></div>'; i=1
    while i < @options.size
      @_.innerHTML += '<div></div>'; i++

    # rotating lines for a circular spinner
    if css_transform && @options.type is 'circular'
      @addClass('lui-spinner-circular')
      @find('div').forEach (div, i)=>
        div._.style.width = (100 / @options.size) + '%'
        div._.style[css_transform] = 'rotate('+Math.round(360/@options.size*i)+'deg) translate(0,-80%) skew(0deg, 20deg)'

    # kicking in CSS3 rotation if needed
    if css_transform && css_animation && @options.type is 'circular' && @options.rotate
      @_.style[css_animation+"Duration"] = @options.speed * 4 + 'ms'
      @addClass('lui-spinner-rotate')

    # fallback spinning in JavaScript for flat spinners
    if !css_transform or !css_animation or @options.type isnt 'circular' or !@options.rotate
      window.setInterval =>
        dot = @first('.lui-spinner-current')
        (dot.nextSibling() || @first()).radioClass('lui-spinner-current')
      , @options.speed

    return @
```
