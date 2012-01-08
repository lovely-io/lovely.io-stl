// trying to find the lovely-callback function
for (var time = new Date().getTime(), i=0, name; i < 100; i++) {
  name = "__lovely_jsonp"+ (time - i);
  if (window[name]) {
    window[name]({some: 'data'});
    break;
  }
}