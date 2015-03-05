(function() {
	var app = angular.module('allegro', []);

	app.service('allegroService', function($http) {
		function onError() {
			alert('ERROR');
		}

		this.getCategories = function(parentId, callback) {
			$http.get('/ajax/categories', {params: {parent_id: parentId}})
			.success(callback).error(onError);
		};

		this.getAutocomplete = function(prefix) {
			return $http.get('/ajax/autocomplete', {params: {prefix: prefix}})
			.then(function(response) {
				return response.data;
			});
		};

		this.getAuctions = function(params, callback) {
			$http.get('/ajax/auctions', {params: params})
			.success(callback).error(onError);
		};

		this.addToFavourites = function(auctionId) {
			$http.post('/ajax/add_to_favourites', {auction_id: auctionId})
			.error(onError);
		};
	});
})();
