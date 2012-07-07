The Function class extensions

Copyright (C) 2011 Nikolay Nemshilov

```coffee-aside
ext Function.prototype,
```

Binds this function to be executed in given context

@param {Object} context
@param {mixed} optional argument to curry
....
@return {Function} the proxy function

```coffee-aside
  bind: Function.prototype.bind || ->
    args    = A(arguments)
    context = args.shift()
    method  = @

    -> method.apply(context, args.concat(A(arguments)))
```

Makes a left-curry proxy function

@param {mixed} value to curry
...
@return {Function} the proxy function

```coffee-aside
  curry: ->
    @bind.apply @, [@].concat(A(arguments))
```

Makes a right-curry proxy function

@param {mixed} value to curry
...
@return {Function} the proxy function

```coffee-aside
  rcurry: ->
    curry  = A(arguments)
    method = @
    -> method.apply(method, A(arguments).concat(curry))
```

Makes a delayed call of the function

@param {Number} delay in ms
@param {mixed} optional argument to curry
...
@return {Number} timer marker

```coffee-aside
  delay: ->
    args = A(arguments)
    ms   = args.shift()
    ext(
      new Number(setTimeout(@bind.apply(this, [this].concat(args)), ms)),
      cancel: -> clearTimeout(@))
```

Makes the function to be periodically called with given interval

@param {Number} calls interval in ms
@param {mixed} optional argument to curry
...
@return {Number} timer marker


```coffee-aside
  periodical: (ms) ->
    args = A(arguments)
    ms   = args.shift()
    ext(
      new Number(setInterval(@bind.apply(this, [this].concat(args)), ms)),
      stop: -> clearInterval(@))
```
