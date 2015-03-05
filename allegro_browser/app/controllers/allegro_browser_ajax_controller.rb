class AllegroBrowserAjaxController < ApplicationController
	def categories
		render json: Category.find(parent_id: params[:parent_id])
	end

	def auctions
		render json: Allegro.api.auctions(auctions_params)
	end

	def add_to_favourites
		Ohm.redis.call('sadd', 'favourites', params['auction_id'])
		render nothing: true
	end

	def autocomplete
		render json: Autocomplete.get(params[:prefix])
	end

	private

	def auctions_params
		params.permit('search-string', 'search-order', 'search-price-from',
									'search-price-to', 'search-category', 'search-limit',
									'search-offset', 'search-order', 'search-order-type')
	end
end
