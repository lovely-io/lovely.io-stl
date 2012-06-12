# Dialog

This module provides the standard UI dialog solution

## Basic Usage

Hook up the Dialog in any standard way and use it as a class

    :javascript
    Lovely(['dialog-1.1.0'], function(Dialog) {
      new Dialog(title: "Hello", html: "Hello world!").show();
    });

## Available Options

* `nolock` - `false` - show the screen lock or not
* `showHelp` - `false` - show the help buttons or not
* `showHeader` - `true` - show the header block or not
* `showButtons` - `true` - show the bottom buttons block or not
* `onlyOk` - `false` - show the `Okay` button only
* `title` - `null` - title text
* `html`  - `null` - default html content
* `url` - `null` - an url address to load via ajax
* `ajax` - `null` - ajax options (when the `url` option is specified)

## Events List

The `Dialog` units fire the following events

 * `show` - when the dialog appears
 * `hide` - when the dialog gets hidden
 * `load` - when the dialog gets loaded via ajax

## API reference

The `Dialog` unit is inherited from the `dom.Element` class and has all the standard
methods. The only difference is that all the content changing methods like `Element#append`
`Element#update`, `Element#load` _are redirected_ to the dialog body.

Also `Dialog` units have additional bidirectional method `#title` to work with the
dialog's header caption.

## Standard Dialog Subclasses

Along with the basic `Dialog` class, this package provides a number of standard dialog subclasses

 * `Dialog.Alert`
 * `Dialog.Confirm`
 * `Dialog.Prompt`
 * `Dialog.Info`

All three of them are inherited from the basic `Dialog` class and can be used the same way

    :javascript
    Lovely(['dialog-1.1.0'], function(Dialog) {
      new Dialog.Alert({html: "Danger!"}).show();
      new Dialog.Confirm({html: "Are you sure?"}).show();
      new Dialog.Prompt().show();
    });

The `Dialog.Prompt` class also can accept the `type` option to define the input field type,
it can be one of those `text`, `password` or `textarea`

Also the `ok` event fired from a `Dialog.Prompt` object has additional `value` attribute,
which contains the input field value.

    :javascript
    new Dialog.Prompt().on('ok', function(event) {
      console.log('You entered: '+ event.value);
    });



## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2012 Nikolay Nemshilov