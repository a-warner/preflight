angular.module('preflight').controller('Checklist', ['$scope', '$document', function($scope, $document) {
  var resetItemEditMode = function() {
    $scope.items.forEach(function(item) {
      item.editMode = !item.id;
    });
  };

  $scope.$watchCollection('items', resetItemEditMode);
  $document.on('click', function() {
    $scope.$apply(resetItemEditMode);
  });

  $scope.setChecklist = function(checklist) {
    angular.extend($scope, checklist);
  }

  $scope.enteredEditMode = function(item) {
    $scope.items.forEach(function(i) {
      if (i.id && i.id !== item.id) {
        i.editMode = false;
      }
    });
  }

  $scope.newItemCreated = function(newItem) {
    $scope.items.push(newItem);
  }

  $scope.itemDeleted = function(item) {
    $scope.items.splice($scope.items.indexOf(item), 1);
  }
}]);
