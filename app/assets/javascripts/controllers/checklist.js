angular.module('preflight').controller('Checklist', ['$scope', '$http', '$document', function($scope, $http, $document) {
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

  $scope.toggleEditItem = function(event, item) {
    if (event.target.tagName === 'INPUT') { return }

    $scope.items.forEach(function(i) {
      if (i.id) {
        i.editMode = i.id == item.id && !i.editMode;
      }
    });
  }

  var submitItem = function(item, opts) {
    item.editMode = false;
    item.submitting = true;

    var req = {
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      data: $.param({'checklist_item[name]' : item.name})
    };

    angular.extend(req, opts);

    return $http(req).then(function(response) {
      $scope.items.splice($scope.items.indexOf(item), 1, response.data.item);
      return response;
    }).catch(function(response) {
      alert(response);
    }).finally(function() {
      item.submitting = false;
    });
  };

  $scope.updateItem = function(item) {
    submitItem(item, {
      method: 'PUT',
      url: item.path
    });
  };

  $scope.createItem = function(item) {
    submitItem(item, {
      method: 'POST',
      url: $scope.create_item_path
    }).then(function(response) {
      $scope.items.push(response.data.new_item);
    });
  };

  $scope.deleteItem = function(item) {
    item.submitting = true;

    $http.delete(item.path).finally(function() {
      item.submitting = false;
    });

    $scope.items.splice($scope.items.indexOf(item), 1);
  };
}]);
