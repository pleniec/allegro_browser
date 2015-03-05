(function() {
	var app = angular.module('browse', ['ui.bootstrap', 'ngTable', 'allegro']);

	app.config(function($httpProvider) {
		var csrfToken = $('meta[name=csrf-token]').attr('content');
		$httpProvider.defaults.headers.common['X-CSRF-Token'] = csrfToken;
	});
})();
