/**
 * The top function, handles async modules loading/definition
 *
 * Basic Usage:
 *
 *    LeftJS(['module1', 'module2'], function(module1, module2) {
 *      // do stuff
 *    });
 *
 * Modules Definition:
 *
 *    LeftJS('module-name', ['dep1', 'dep2'], function(dep1, dep2) {
 *      return { module: 'definition' };
 *    });
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
function LeftJS() {
  var args     = A(arguments),
      options  = isObject(args[0])   ? args.shift() : {},
      module   = isString(args[0])   ? args.shift() : null,
      modules  = isArray(args[0])    ? args.shift() : [],
      callback = isFunction(args[0]) ? args.shift() : function() {},
      header   = document.getElementsByTagName('head')[0],
      deadline = new Date();

  // setting up the options
  'baseUrl'     in options || (options.baseUrl     = find_base_url());
  'waitSeconds' in options || (options.waitSeconds = LeftJS.waitSeconds);

  deadline.setTime(deadline.getTime() + options.waitSeconds * 1000);

  // inserting the actual scripts on the page
  for (var i=0, script; i < modules.length; i++) {
    if (!(modules[i] in LeftJS.modules || modules[i] in LeftJS.loading)) {
      script = document.createElement('script');

      script.src   = options.baseUrl + modules[i] + ".js";
      script.async = true;

      header.appendChild(script);

      LeftJS.loading[modules[i]] = script;
    }
  }

  // waiting for the modules to load
  (function() {
    var packages=[], i=0, result;

    for (; i < modules.length; i++) {
      if (modules[i] in LeftJS.modules) {
        packages[i] = LeftJS.modules[modules[i]];
      } else if (new Date() < deadline) {
        return setTimeout(arguments.callee, 20);
      } else {
        return null; // giving up
      }
    }

    // making the call
    result = callback.apply(null, packages);

    // registering the module if needed
    if (module && result) {
      LeftJS.modules[module] = result;
      delete(LeftJS.loading[module]);
    }
  })();
}

/**
 * Searches for the scripts main directory
 *
 * @return {String} location
 */
function find_base_url() {
  var scripts = document.getElementsByTagName('script'),
      re = /(.*?(^|\/))(left(\-src)?\.js)/,
      i = 0, match;

  for (; i < scripts.length; i++) {
    if ((match = (scripts[i].getAttribute('src') || '').match(re))) {
      return match[1];
    }
  }

  return LeftJS.baseUrl;
}
