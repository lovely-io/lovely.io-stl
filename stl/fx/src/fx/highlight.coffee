#
# The standard highlight visual effect
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Fx.Highlight extends Fx.Style
  extend:
    # additional options
    Options: Hash.merge(Fx.Options, {
      color:      '#FF8'
      transition: 'ease-out'
    })

# protected

  #
  # Prepares the transition
  #
  # @param {String} start color
  # @param {String} optional end color
  # @return {Fx.Highlight} this
  #
  prepare: (start, end)->
    element       = @element
    element_style = element._.style
    style_name    = 'backgroundColor'
    end_color     = end || element.style(style_name)

    if is_transparent(end_color)
      @on 'finish', -> element_style[style_name] = 'transparent'

      # trying to find the end color
      end_color = new List([element])
        .concat(element.parents())
        .map('style', style_name)
        .reject((v) -> !v || is_transparent(v))

      end_color = end_color[0] || '#FFF'

    element_style[style_name] = (start || @options.color)

    super(backgroundColor: end_color)