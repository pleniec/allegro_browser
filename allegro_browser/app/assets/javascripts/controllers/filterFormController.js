(function() {
	var app = angular.module('browse');

	app.controller('filterFormController',
		['$scope', '$rootScope', 'allegroService',
		function($scope, $rootScope, allegroService) {
			$rootScope.filterFormData = {keyword: '', priceFrom: '', priceTo: ''};
			$rootScope.filterFormDataChanged = false;
			$rootScope.isFilterFormDirty = function() {
				return $scope.filterForm.$dirty;
			};

			$scope.searchClicked = function() {
				$rootScope.reloadAuctionsTable();
			};

			$scope.filterFormChanged = function() {
				$rootScope.filterFormDataChanged = true;
			};

			$scope.getAutocomplete = function(viewValue) {
				return allegroService.getAutocomplete(viewValue);
			};
		}]);
})();