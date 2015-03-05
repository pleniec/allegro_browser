(function() {
	var app = angular.module('browse');

	app.controller('categorySelectController',
		['$scope', '$rootScope', 'allegroService',
		function($scope, $rootScope, allegroService) {
			var dummyCategory = {id: 0, name: '--Wybierz--'};

			$rootScope.currentCategory = dummyCategory;

			$scope.categoriesPath = [{id: 0, name: 'Wszystkie'}];
			$scope.categoriesInSelect = [];

			function getCategoriesCallback(data) {
				$scope.categoriesInSelect = data;
				$scope.categoriesInSelect.unshift(dummyCategory);
				$scope.selectedCategory = dummyCategory;
			}

			allegroService.getCategories(0, getCategoriesCallback);

			$scope.categorySelected = function() {
				$scope.categoriesPath.push($scope.selectedCategory);
				$rootScope.currentCategory = $scope.selectedCategory;
				allegroService.getCategories($scope.selectedCategory.id, getCategoriesCallback);
			};

			$scope.categoryClicked = function(category) {
				var categoryIndex = $scope.categoriesPath.indexOf(category);
				$scope.categoriesPath = $scope.categoriesPath.slice(0, categoryIndex + 1);
				$rootScope.currentCategory = category;

				allegroService.getCategories($rootScope.currentCategory.id, getCategoriesCallback);
			};
		}]);
})();
