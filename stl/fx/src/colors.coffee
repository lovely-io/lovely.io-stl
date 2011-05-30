#
# This file contains utils to handle the color formats conversion
#
# Copyright (C) 2011 Nikolay Nemshilov
#


#
# converts a hex string into an rgb array
#
# @param {String} a hex color
# @param {Boolean} flag if need an array
# @return {String} rgb(R,G,B) or Array [R,G,B]
#
to_rgb = (color, in_array)->
  match = /#([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})/i.exec(to_hex(color)||'');

  if match
    match = (parseInt(bit,16) for bit in match.slice(1))
    match = if in_array then match else 'rgb('+match+')'

  return match


#
# converts a #XXX or rgb(X, X, X) sring into standard #XXXXXX color string
#
# @param {String} color in other formats
# @return {String} hex color
#
to_hex = (color)->
  match = /^#(\w)(\w)(\w)$/.exec(color)

  if match
    match = "#"+ match[1]+match[1]+match[2]+match[2]+match[3]+match[3]
  else if match = /^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/.exec(color)
    value = match.slice(1)
    match = "#"
    for bit in value
      bit = (bit-0).toString(16)
      match += if bit.length is 1 then '0'+bit else bit

  else
    match = COLORS[color] || color

  return match



# a bunch of standard colors map for old browsers
COLORS =
  maroon:  '#800000'
  red:     '#ff0000'
  orange:  '#ffA500'
  yellow:  '#ffff00'
  olive:   '#808000'
  purple:  '#800080'
  fuchsia: '#ff00ff'
  white:   '#ffffff'
  lime:    '#00ff00'
  green:   '#008000'
  navy:    '#000080'
  blue:    '#0000ff'
  aqua:    '#00ffff'
  teal:    '#008080'
  black:   '#000000'
  silver:  '#c0c0c0'
  gray:    '#808080'
  brown:   '#a52a2a'
