/**
 * The top function, handles async modules loading/definition
 *
 * Basic Usage:
 *
 *    Lovely(['module1', 'module2'], function(module1, module2) {
 *      // do stuff
 *    });
 *
 * Modules Definition:
 *
 *    Lovely('module-name', ['dep1', 'dep2'], function(dep1, dep2) {
 *      return { module: 'definition' };
 *    });
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */
function Lovely() {
  var args     = A(arguments),
      module   = isString(args[0])   ? args.shift() : null,
      options  = isObject(args[0])   ? args.shift() : {},
      modules  = isArray(args[0])    ? args.shift() : [],
      callback = isFunction(args[0]) ? args.shift() : function() {},
      header   = document.getElementsByTagName('head')[0],
      deadline = new Date(); // the hang up time

  // setting up the options
  'hostUrl'     in options || (options.hostUrl     = Lovely.hostUrl || find_host_url());
  'baseUrl'     in options || (options.baseUrl     = Lovely.baseUrl || options.hostUrl);
  'waitSeconds' in options || (options.waitSeconds = Lovely.waitSeconds);

  options.hostUrl[options.hostUrl.length - 1] === '/' || (options.hostUrl += '/');
  options.baseUrl[options.baseUrl.length - 1] === '/' || (options.baseUrl += '/');

  deadline.setTime(deadline.getTime() + options.waitSeconds * 1000);

  // inserting the actual scripts on the page
  for (var i=0, script, url; i < modules.length; i++) {
    url = (modules[i][0] === '.' ?
      options.baseUrl : options.hostUrl
    ) + modules[i] + ".js";

    // stripping out the '../' and './' things to get the clean module name
    modules[i] = modules[i].replace(/^[\.\/]+/, '');

    if (!(modules[i] in Lovely.modules || modules[i] in Lovely.loading)) {
      script = document.createElement('script');

      script.src   = url;
      script.async = true;
      script.type  = "text/javascript";

      header.appendChild(script);

      Lovely.loading[modules[i]] = script;
    }
  }


  // waiting for the modules to load
  (function() {
    var packages=[], i=0, result;

    for (; i < modules.length; i++) {
      if (modules[i] in Lovely.modules) {
        packages[i] = Lovely.modules[modules[i]];
      } else if (new Date() < deadline) {
        return setTimeout(arguments.callee, 20);
      } else {
        return null; // giving up
      }
    }

    // making the call
    result = callback.apply(null, packages);

    // registering the module if needed
    if (module) {
      Lovely.modules[module] = result;
      delete(Lovely.loading[module]);
    }
  })();
}

/**
 * Searches for the Lovely hosting url from the scripts 'src' attribute
 *
 * @return {String} location
 */
function find_host_url() {
  var scripts = document.getElementsByTagName('script'),
      re = /(.*?(^|\/))(left(\-src)?\.js)/,
      i = 0, match;

  for (; i < scripts.length; i++) {
    if ((match = (scripts[i].getAttribute('src') || '').match(re))) {
      return match[1];
    }
  }

  return Lovely.hostUrl;
}
