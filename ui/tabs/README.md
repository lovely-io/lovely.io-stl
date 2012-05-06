# Tabs

This is the standard tabs widget solution for lovely.io UI

## Basic Usage

Just hook it up and make a standard tabs layout like so

    :html
    <div class="lui-tabs" data-tabs="{..options..}">
      <nav>
        <a href="#tab-1">Tab 1</a>
        <a href="#tab-2">Tab 2</a>
        <a href="#tab-3">Tab 3</a>
      </nav>

      <div id="tab-1">Tab 1 body</div>
      <div id="tab-2">Tab 2 body</div>
      <div id="tab-3">Tab 3 body</div>
    </div>

__NOTE__ the hash tags in your links should correspond to the
tab panel ids

You also can use the legacy `UL` based layouts like those

    :html
    <ul class="lui-tabs" data-tabs="{..options..}">
      <ul>
        <li><a href="#tab-1">Tab 1</a></li>
        <li><a href="#tab-2">Tab 2</a></li>
        <li><a href="#tab-3">Tab 3</a></li>
      </ul>

      <li id="tab-1">Tab 1 body</li>
      <li id="tab-2">Tab 2 body</li>
      <li id="tab-3">Tab 3 body</li>
    </ul>

Then hook up the `tabs` module in any standard way and enjoy the widget!


## Options

 * `idPrefix` - `''` - the tab panel ids prefix


## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2012 Nikolay Nemshilov