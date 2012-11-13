# Lovely IO

`Lovely IO` is the next-gen front-side development platform.

In a short, it's like rubygems + rails, only for the front-side development.

See [the official site](http://lovely.io) and [screencast](http://lovely.io/show)
for more information and usage examples.


## What's In Here

In this repo you can find the following things

 * `cli/` - the lovely CLI tools, server and so on
 * `stl/` - the STL library of official modules
 * `ui/`  - the official UI library modules


## Bootstrapping

Lovely IO console tools work with `node.js` and available via the `npm` service

```
npm install -g lovely
```

After that, you'll need to run the following

```
lovely bootstrap
```

That will create all the necessary files and directories and auto-install all
the `STL` packages in your `~/.lovely/` folder.

Also, add the following into your `~/.bash_profile` or `~/.bashrc` file

```
export NODE_PATH=/usr/local/share/npm/lib/node_modules:$NODE_PATH
```

This will allow `lovely test` command work correctly

## Uninstalling

You can uninstall all the lovely.io stuff from your computer by calling

```
lovely implode
```

Also, you can do that manually via simple shell command

```
rm ~/.lovelyrc && rm -rf ~/.lovely
```


## License & Copyright

This project is released under the terms of the MIT license

Copyright (C) 2011-2012 Nikolay Nemshilov
