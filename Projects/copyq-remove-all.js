// based on https://github.com/hluk/CopyQ/issues/1397

copyq:
copy('')
copySelection('')
tab(config('clipboard_tab'))
items = Array
  .apply(0, Array(size()))
  .map(function(x,i){return i})
remove.apply(this, items)