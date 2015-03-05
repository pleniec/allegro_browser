(function() {
	var app = angular.module('browse');

	app.controller('auctionsTableController',
		['$scope', '$rootScope', 'ngTableParams', 'allegroService',
		function($scope, $rootScope, ngTableParams, allegroService) {
			$rootScope.reloadAuctionsTable = function() {
				console.log($rootScope.filterFormDataChanged);
				if($rootScope.filterFormDataChanged) {
					$scope.auctionTable.$params.page = 1;
					$rootScope.filterFormDataChanged = false;
				}
				console.log($scope.auctionTable.$params.page);
				$scope.auctionTable.reload();
			};

			$scope.auctionTableVisible = false;

			$scope.addToFavourites = function(auctionId) {
				allegroService.addToFavourites(auctionId);
			};

			$scope.auctionTable = new ngTableParams({
				page: 1,
				count: 10
			}, {
				total: 0,
				counts: [],
				sorting: {
					price: 'asc',
					date: 'asc',
				},
				getData: function($defer, params) {
					if($rootScope.isFilterFormDirty()) {
						var searchCategory = $rootScope.currentCategory.id === -1 ? null : $rootScope.currentCategory.id;
						allegroService.getAuctions({
							'search-string': $rootScope.filterFormData.keyword,
							'search-price-from': $rootScope.filterFormData.priceFrom,
							'search-price-to': $rootScope.filterFormData.priceTo,
							'search-category': searchCategory,
							'search-limit': 10,
							'search-offset': params.page() - 1,
							'search-order': typeof params.sorting().price === 'undefined' ? 1 : 4,
							'search-order-type': (params.sorting().price || params.sorting().date) === 'asc' ? 0 : 1
						}, function(data) {
							params.total(data.total);
							$defer.resolve(data.auctions);
							$scope.auctionTableVisible = data.total > 0;
						});
					}
				}
			});
		}]);
})();
