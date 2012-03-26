# Slideshow

Slideshow is a little widget to make slideshows from lists

## Basic Usage

In a simple case, you can just add the `lui-slideshow` class to your `UL` element

```html
<ul class="lui-slideshow">
  <li><img src="img1.jpg"></img></li>
  <li><img src="img2.jpg"></img></li>
  <li><img src="img3.jpg"></img></li>
  ....
</ul>
```

You also can instantiate `Slideshow` object existing objects

```javascript
new Slideshow($('#my-list')[0], {... options ...});
```

## Options

You can use the following list of options

* `fxDuration` - the sliding visual effect duration
* `autoplay` - automatically swap the items on the list
* `delay` - delay between switches in the autoplay mode
* `loop` - start from the beginning when finished


## Public API

Besides the standard {dom.Element} API, there is a bunch of methods
available as part of the public API with all the `Slideshow` class instances

* `items()` - returns the list ({dom.NodeList}) of items in the slideshow
* `hasPrevious()` - checks if there is a previous item on the list
* `hasNext()` - checks if there is a next item on the list
* `previous()` - slide to the previous item on the list
* `next()` - slide to the next item on the list
* `slideTo(index)` - slide to an item with the (integer) index
* `play()` - starts the auto-play mode
* `pause()` - stops the auto-play mode


## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2012 Nikolay Nemshilov