class PopulateAutocomplete
	@queue = :populate_autocomplete

	def self.perform(auctions_list)
		auctions_list.to_a.each do |auction|
			auction_id = auction['s_it_id']
			unless Autocomplete.stored?(auction_id)
				Autocomplete.store(auction_id, auction['s_it_name'])
			end
		end
	end
end
