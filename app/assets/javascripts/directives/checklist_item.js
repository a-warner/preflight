angular.module('preflight').directive('checklistItem', ['$http', function($http) {
  return {
    restrict: 'E',
    scope: {
      item: '=',
      toggledEditMode: '&',
      newItemCreated: '&',
      itemDeleted: '&'
    },
    templateUrl: 'checklist_item.html',
    link: function(scope, element, attrs) {
      scope.toggleEditItem = function(event) {
        if (event.target.tagName === 'INPUT') { return }

        scope.item.shouldBeFocused = scope.item.editMode = !scope.item.editMode;
        scope.toggledEditMode({item: scope.item});
      }

      var submitItem = function(opts) {
        scope.item.editMode = false;
        scope.item.submitting = true;

        var req = {
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          data: $.param({'checklist_item[name]' : scope.item.name}),
          url: scope.item.path
        };

        angular.extend(req, opts);

        return $http(req).then(function(response) {
          angular.extend(scope.item, response.data.item);
          return response;
        }).catch(function(response) {
          alert(response);
        }).finally(function() {
          scope.item.submitting = false;
        });
      };

      scope.updateItem = function() {
        submitItem({method: 'PUT'});
      };

      scope.createItem = function() {
        submitItem({method: 'POST'}).then(function(response) {
          scope.newItemCreated({newItem: response.data.new_item});
        });
      };

      scope.deleteItem = function() {
        scope.item.submitting = true;

        $http.delete(scope.item.path).finally(function() {
          scope.item.submitting = false;
        });

        scope.itemDeleted({item: scope.item});
      };
    }
  };
}]);
