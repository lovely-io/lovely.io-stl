# Table

Table is the standard tables specific dom wrapper extension
for the [lovely.io](http://lovely.io) project

```javascript
Lovely(['dom', 'table'], function($, Table) {
  // create table instances manually
  var table = new Table({id: 'my-table'});
  table.insertTo(document.body);
  table.sort('column-name');
  table.rows(); // -> NodeList of table rows

  // access any existing table
  $('#my-table').sort('column-name');
});
```

## Basic API

 * `Table#rows()`   -> list of rows without the header
 * `Table#header()` -> the table header row
 * `Table#footer()` -> the table footer row
 * `Table#sort(..)` -> sort the table's content

## Table Sorting

There are few ways how you can sort your tables with this extension

1. You can just specify the column _index_

    ```javascript
    $('#my-table').sort(0);
    $('#my-table').sort(1);

    $('#my-table').sort(0, 'asc');
    $('#my-table').sort(0, 'desc');

    $('#my-table').sort(0, 1);
    $('#my-table').sort(0, -1);
    ```

2. You can specify the `data-sort` attribute in one of the `TH` elements

    ```html
    <table id="my-table">
      <tr>
        <th data-sort="name">Name</th>
        <th data-sort="age">Age</th>
        <th data-sort="osom">Osomeness</th>
      </tr>
      <tr>
        .... row
      </tr>
    </table>
    ```

    After that sorting will kick in automatically. Or you can kick it in
    at any time manually bu using the same names you specified in the
    custom `data-sort` attribute

    ```js
    $('#my-table').sort('name');
    $('#my-table').sort('osom');
    ```

3. Specify your custom sort algorithm

    ```js
    $('#my-table').sort(function(row1, row2) {
      var a = row1.find('td.smth').text();
      var b = row2.find('td.smth').text();

      return a > b ? 1 : a < b ? -1 : 0;
    });
    ```


## Custom Sorting Values

Sometimes column values are not exactly what you need it to be sorted by. In this case
you can specify custom sort values for the columns to be sorted by by using a custom
`data-value` attribute on those cells. For example

```html
<table>
  <tr>
    <th data-sort>Name</th>
    <th data-sort>Osomenes</th>
  </tr>
  <tr>
    <td>lovely.io</td>
    <td data-value="10">total</td>
  </tr>
  <tr>
    <td>jquery</td>
    <td data-value="1">meh..</td>
  </tr>
</table>
```


## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2013 Nikolay Nemshilov
