var oldStopCallback = Mousetrap.stopCallback
Mousetrap.stopCallback = function(e, element, combo) {
  if (!oldStopCallback.call(Mousetrap, e, element, combo)) {
    return false
  } else {
    return combo != 'command+enter'
  }
}

Mousetrap.bind('command+enter', function(e) {
  var $target = $(e.target)
  if ($target.is('input')) {
    $target.closest('form').submit()
  }
})
