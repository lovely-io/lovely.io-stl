The visual effects basic class. It doesn't do anything
practical itself, just defines the common interface
and handles timers and queues

Events that can be used with this one

 * `start`  - when an effect starts
 * `finish` - when an effect finishes
 * `cancel` - when an effect was interrupted manually
 * `stop`   - when all scheduled effects are finished

it also will fire events on the related element
  `fx:start`, `fx:finish`, `fx:cancel`

Copyright (C) 2011-2012 Nikolay Nemshilov

```coffee-aside
class Fx
  include: [core.Options, core.Events]

  extend:
    # default options
    Options:
      duration:   'normal'  # a name or a number in milliseconds
      transition: 'default' # css3 cubic-bezier transition-function
      queue:      true      # auto-stack the fx in a queue
      engine:     'css'     # 'css' for native css3 where it's supported or 'javascript' to
      fps:        60        # FPS for the javascript engine

    # Named durations
    Durations:
      short:  200
      normal: 400
      long:   800
```

Basic constructor

@param {Element|HTMLElement|String} elemnt reference
@param {Object} fx options
@return {Fx} this

```coffee-aside
  constructor: (element, options)->
    @setOptions(options)

    for key of @options
      if key in ['start', 'finish', 'cancel', 'stop']
        @on(key, @options[key])

    @element = $(element)
    @element = @element[0] if typeof(element) is 'string'

    Fx_register(@)
    return @
```

Starts the effect

@return {Fx} this

```coffee-aside
  start: ->
    return @ if Fx_add_to_queue(@, arguments)

    Fx_mark_current @

    @prepare.apply(@, arguments)

    Fx_start_timer(@)

    return @emit('start')
```

Handles the post-effect logic

@return {Fx} this

```coffee-aside
  finish: ->
    Fx_stop_timer @
    Fx_remove_from_queue @
    @emit 'finish'
    Fx_run_next @
    return @
```

Manually interrupts the effect

NOTE: cancels all the scheduled effects

@return {Fx} this

```coffee-aside
  cancel: ->
    Fx_stop_timer @
    Fx_remove_from_queue @
    return @emit('cancel').emit('stop')
```

Overloading the original method

@param {String} event name
@return {Fx} this

```coffee-aside
  emit: (name)->
    core.Events.emit.apply(@, arguments)
    @element.emit "fx:#{name}", fx: @
    return @

# protected

  # those two should be implemented in every subclass
  # prepare: ->
  # render:  ->

# private
```

Utility functions to handle queues and timers

```coffee-aside

# global effects registry
Fx_scheduled = new List()
Fx_running   = new List()
```

Registers the element in the effects queue

@param {Fx} effect
@return void

```coffee-aside
Fx_register = (fx)->
  uid = $.uid((fx.element || {})._ || {})
  fx._ch = (Fx_scheduled[uid] = Fx_scheduled[uid] || new List())
  fx._cr = (Fx_running[uid]   = Fx_running[uid]   || new List())
```

Registers the effect in the effects queue

@param {Fx} fx
@param {Arguments} original arguments list
@return {Boolean} true if it queued and false if it's ready to go

```coffee-aside
Fx_add_to_queue = (fx, args)->
  chain = fx._ch
  queue = fx.options.queue

  return (fx._$ch = false) if !chain || fx._$ch

  chain.push([args, fx]) if queue

  return queue and chain[0][1] isnt fx
```

Puts the fx into the list of currently running effects

@param {Fx} fx
@return void

```coffee-aside
Fx_mark_current = (fx)->
  fx._cr.push(fx) if fx._cr
```

Removes the fx from the queue

@param {Fx} fx
@return void

```coffee-aside
Fx_remove_from_queue = (fx)->
  currents = fx._cr
  currents.splice(currents.indexOf(fx), 1) if currents
```

Tries to invoke the next effect in the queue

@param {Fx} fx
@return void

```coffee-aside
Fx_run_next = (fx)->
  chain = fx._ch
  next  = chain.shift()

  if next = chain[0]
    next[1]._$ch = true;
    next[1].start.apply(next[1], next[0])
  else
    fx.emit('stop')

  return # nothing
```

Cancels all currently running and scheduled effects
on the element

@param {Element} element
@return void

```coffee-aside
Fx_cancel_all = (element)->
  uid = $.uid(element._)

  Fx_running[uid].forEach('cancel') if Fx_running[uid]
  Fx_scheduled_fx[uid].splice(0)    if Fx_scheduled_fx[uid]

  return ;
```

Initializes the fx rendering timer

@param {Fx} fx
@return void

```coffee-aside
Fx_start_timer = (fx, options)->
  options    = fx.options
  duration   = Fx.Durations[options.duration] || options.duration
  steps      = Math.ceil(duration / 1000 * options.fps)
  transition = Bezier_sequence(options.transition, steps)
  interval   = Math.round(1000 / options.fps)
  number     = 0

  fx._timer = setInterval(->
    if number == steps
      fx.finish()
    else
      fx.render(transition[number])
      number++
  , interval)
```

Cancels the Fx rendering timer (if any)

@param {Fx} fx
@return void

```coffee-aside
Fx_stop_timer = (fx)->
  clearInterval(fx._timer) if fx._timer
```

CSS3 Cubic Bezier sequentions emulator
http://st-on-it.blogspot.com/2011/05/calculating-cubic-bezier-function.html

```coffee-aside

# CSS3 cubic-bezier presets
Bezier_presets =
  'default':     '(.25,.1,.25,1)'
  'linear':      '(0,0,1,1)'
  'ease-in':     '(.42,0,1,1)'
  'ease-out':    '(0,0,.58,1)'
  'ease-in-out': '(.42,0,.58,1)'
  'ease-out-in': '(0,.42,1,.58)'

# Bezier loockup tables cache
Bezier_cache = {}

# builds a loockup table of parametric values with a given size
Bezier_sequence = (params, size)->
  params = Bezier_presets[params] || params
  params = params.match(/([\d\.]+)[\s,]+([\d\.]+)[\s,]+([\d\.]+)[\s,]+([\d\.]+)/)
  params = [0, params[1]-0, params[2]-0, params[3]-0, params[4]-0] # cleaning up
  name   = params.join(',') + ',' + size

  unless name of Bezier_cache
    # defining bezier functions in a polynomial form (coz it's faster)
    Cx = 3 * params[1]
    Bx = 3 * (params[3] - params[1]) - Cx
    Ax = 1 - Cx - Bx

    Cy = 3 * params[2]
    By = 3 * (params[4] - params[2]) - Cy
    Ay = 1 - Cy - By

    bezier_x = (t)-> t * (Cx + t * (Bx + t * Ax))
    bezier_y = (t)-> t * (Cy + t * (By + t * Ay))


    # a quick search for a more or less close parametric
    # value using several iterations by Newton's method
    bezier_x_der    = (t) -> Cx + t * (2*Bx + t * 3*Ax) + 1e-3 # bezier_x derivative
    find_parametric = (t) ->
      x=t; i=0; n=5;

      while (i < 5)
        z = bezier_x(x) - t

        break if Math.abs(z) < 1e-3

        x = x - z/bezier_x_der(x)
        i++

      return x

    # building the actual lookup table
    Bezier_cache[name] = sequence = []
    x=0; step=1/size;

    while x < 1.0001 # should include 1.0
      sequence.push(bezier_y(find_parametric(x)))
      x += step


  return Bezier_cache[name]
```
