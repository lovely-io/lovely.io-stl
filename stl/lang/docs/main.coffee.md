The JavaScript core extensions module for Lovely

Copyright (C) 2011 Nikolay Nemshilov

```coffee-aside
core    = require('core')
ext     = core.ext
A       = core.A
List    = core.List
isArray = core.isArray

include 'src/array'
include 'src/string'
include 'src/number'
include 'src/function'
include 'src/regexp'
include 'src/math'


exports.version = '%{version}'
```
