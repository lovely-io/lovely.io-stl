#
# The `Math` unit extensions
#
# Copyright (C) 2011 Nikolay Nemshilov
#
old_Math_random = Math.random

Math.random = (min, max)->

  if arguments.length is 0
    return old_Math_random()
  else if arguments.length is 1
    max = min
    min = 0

  ~~(old_Math_random() * (max-min+1) + ~~min)
