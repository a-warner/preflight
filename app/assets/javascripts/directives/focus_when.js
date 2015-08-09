angular.module('preflight').directive('focusWhen', ['$timeout', function($timeout) {
  return {
    link: function(scope, element, attrs) {
      scope.$watch(attrs.focusWhen, function(value) {
        if(value === true) {
          element[0].focus();
          scope[attrs.focusWhen] = false;
        }
      });
    }
  };
}]);
