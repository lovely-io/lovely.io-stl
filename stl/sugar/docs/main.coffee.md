The syntax sugar for the 'dom' module of Lovely IO

Copyright (C) 2011 Nikolay Nemshilov

```coffee-aside
core     = require('core')
dom      = require('dom')
A        = core.A
ext      = core.ext
document = global.document

include 'src/string'  # NOTE: should be before the 'src/element' !
include 'src/element'


exports.version = '%{version}'
```
