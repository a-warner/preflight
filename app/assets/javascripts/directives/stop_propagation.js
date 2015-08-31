angular.module('preflight').directive('stopPropagation', function() {
  return {
    link: function(scope, element, attrs) {
      element.on(attrs.stopPropagation, function(event) {
        event.stopPropagation();
      });
    }
  };
});
