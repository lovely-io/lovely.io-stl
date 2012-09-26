#
# A smooth styles processing base effect
#
# Copyright (C) 2011-2012 Nikolay Nemshilov
#
class Fx.Style extends Fx

# protected

  prepare: (style)->
    if @options.engine is 'css' and native_fx_prefix isnt null
      @render = ->
      @_native_timer = true
      bind_native_fx_timer(@, @element)
      native_fx_prepare.call(@, style)
    else
      keys   = style_keys(style)
      before = clone_style(@element, keys)
      after  = get_end_style(@element, style, keys)

      clean_styles(@element, before, after)

      @before = parse_style(before)
      @after  = parse_style(after)

    return ;


  render: `function(delta) {
    var before, after, value, style = this.element._.style, round = Math.round, key, i, l;
    for (key in this.after) {
      before = this.before[key];
      after  = this.after[key];

      for (i=0, l = after.length; i < l; i++) {
        value = before[i] + (after[i] - before[i]) * delta;
        if (after.r) {
          value = Math.round(value);
        }
        after.t[i*2 + 1] = value;
      }

      style[key] = after.t.join('');
    }
  }`


############################################################################
# Native css-transitions based implementation
############################################################################
native_fx_prefix = null
for name in ['WebkitT', 'OT', 'MozT', 'MsT', 't']
  if "#{name}ransition" of HTML.style
    native_fx_prefix = name
    break


native_fx_transition = native_fx_prefix     + 'ransition'
native_fx_property   = native_fx_transition + 'Property'
native_fx_duration   = native_fx_transition + 'Duration'
native_fx_function   = native_fx_transition + 'TimingFunction'


bind_native_fx_timer = (fx, element)->
  event_name = native_fx_transition + 'End'
  event_name = event_name[0].toLowerCase() + event_name.slice(1);

  event_name = 'transitionend' if native_fx_prefix is 'MozT' or native_fx_prefix is 't'

  callback = (event)->
    if event.target is element and !fx.__finished
      element.no event_name, callback # unbinding itself immediately
      fx.__finished = true
      fx.finish()
      console.log('fuck')

  element.on event_name, callback


native_fx_prepare    = (style)->
  options       = @options
  element       = @element
  old_style     = element.style("#{native_fx_property},#{native_fx_duration},#{native_fx_function}")
  element_style = element._.style

  reset_transitions_style = ->
    for key of old_style
      element_style[key] = old_style[key]

  @on
    finish: reset_transitions_style
    cancel: ->
      element_style[native_fx_property] = 'none'
      setTimeout(reset_transitions_style, 1)

  # the following should be in a subprocess to work correctly in Chrome
  setTimeout ->
    # setting up the transition
    element_style[native_fx_property] = 'all'
    element_style[native_fx_function] = options.transition
    element_style[native_fx_duration] = (Fx.Durations[options.duration] || options.duration) + "ms"

    # setting the actual end styles
    setTimeout((->element.style(style)), 0)
  , 0


# NOTE: OPERA's css-transitions are a bit jerky so we disable them by default
Fx.Options.engine = if native_fx_prefix is null or Browser is 'Opera' then 'javascript' else 'css'



#########################################################################
# Pure JavaScript based implementation
#########################################################################
directions = ['Top', 'Left', 'Right', 'Bottom']

# adds variants to the style names list
add_variants = (keys, key, variants)->
  for variant in variants
    keys.push(key + variant)
  return;

# creates an appropriate style-keys list out of the user styles
style_keys = (style)->
  keys = []

  for key of style
    if key.substr(0, 6) is 'border'
      for type in ['Style', 'Color', 'Width']
        for direction in directions
          keys.push('border' + direction + type)

    else if key is 'margin' or key is 'padding'
      add_variants(keys, key, directions)
    else if key.substr(0, 10) is 'background'
      add_variants(keys, 'background', ['Color', 'Position', 'PositionX', 'PositionY'])
    else if key is 'opacity' and IE_OPACITY
      keys.push('filter')
    else
      keys.push(key)

  return keys


# checks if the color is transparent
is_transparent = (color)->
  color is 'transparent' or color is 'rgba(0, 0, 0, 0)'

# adjusts the border-styles
check_border_styles = (element, before, after)->
  for direction in directions
    bd_style = "border#{direction}Style"
    bd_width = "border#{direction}Width"
    bd_color = "border#{direction}Color"

    if bd_style of before and before[bd_style] isnt after[bd_style]
      style = element._.style

      style[bd_width] = '0px' if before[bd_style] is 'none'
      style[bd_style] = after[bd_style]

      if is_transparent(before[bd_color])
        style[bd_color] = element.style('Color')


# parses the style hash into a processable format
parse_style = (values)->
  result = {}; re = /[\d\.\-]+/g;

  for key of values
    value = []
    for digit in values[key].match(re)
      value.push(parseFloat(digit))

    value.t = values[key].split(re)
    value.r = value.t[0] is 'rgb('

    value.t.unshift('') if value.t.length is 1

    for v, i in value
      value.t.splice(i*2 + 1, 0, v)

    result[key] = value

  return result

# cleans up and optimizies the styles
clean_styles = (element, before, after)->
  for key of after
    # checking the height/width options
    if (key is 'width' or key is 'height') and before[key] is 'auto'
      key[0] = key[0].toUpperCase()
      before[key] = element._['offset'+key] + 'px'


  # IE opacity filter fix
  if IE_OPACITY and after.filter and !before.filter
    before.filter = 'alpha(opacity=100)'

  # adjusting the border style
  check_border_styles(element, before, after)

  # cleaing up the list
  for key of after
    # proprocessing colors
    if after[key] isnt before[key] and /color/i.test(key)
      after[key]  = to_rgb(after[key])  unless is_transparent(after[key])
      before[key] = to_rgb(before[key]) unless is_transparent(before[key])

      after[key] = before[key] = '' if !after[key] or !before[key]

    # filling up the missing size
    if /\d/.test(after[key]) && !/\d/.test(before[key])
      before[key] = after[key].replace(/[\d\.\-]+/g, '0')

    # removing unprocessable keys
    if after[key] is before[key] or !/\d/.test(before[key]) or !/\d/.test(after[key])
      delete(after[key])
      delete(before[key])


# cloning the element current styles hash
clone_style = (element, keys)->
  result = {}

  for key in keys
    style = element.style(key)

    result[key] = ''+ style if style isnt undefined

    # libwebkit bug fix for in case of languages pack applied
    result[key] = result[key].replace(',', '.') if key is 'opacity'

  return result


# calculating the end styles hash
get_end_style = (element, style, keys)->
  dummy = element.clone()
  dummy.style('position:absolute;z-index:-1;visibility:hidden')
  dummy.size(x: element.size().x)
  dummy.style(style)

  element.insert(dummy, 'before') if element.parent()

  after = clone_style(dummy, keys)
  dummy.remove()

  return after


