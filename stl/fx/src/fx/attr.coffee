#
# Basic attributes (not styles!) smooth change effect
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Fx.Attr extends Fx

# protected

  prepare: (attrs)->
    @before = {}
    @after  = attrs
    element = @element._

    for key of attrs
      @before[key] = element[key]

    return ;


  render: (delta)->
    element = @element._
    before  = @before
    after   = @after

    for key of before
      element[key] = before[key] + (after[key] - before[key]) * delta

    return;