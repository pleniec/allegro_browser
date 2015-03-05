module Autocomplete
	AUTOCOMPLETE_SORTED_SET_KEY = 'autocomplete'
	STORED_ID_SET_KEY = 'ids_stored_in_autocomplete'

	def self.stored?(auction_id)
		Ohm.redis.call('sismember', STORED_ID_SET_KEY, auction_id) == 1
	end

	def self.store(auction_id, auction_name)
		Ohm.redis.call('sadd', STORED_ID_SET_KEY, auction_id)

		words = auction_name.mb_chars.downcase.scan(/\p{Word}+/)
		0.upto(words.length) do |length|
			(words.length - length).times do |offset|
				Ohm.redis.call('zadd', AUTOCOMPLETE_SORTED_SET_KEY, 0,
											 words[offset..(offset + length)].join(' '))
			end
		end
	end

	def self.get(prefix)
		Ohm.redis.call('zrangebylex', AUTOCOMPLETE_SORTED_SET_KEY,
									 "[#{prefix}", "[#{prefix}\xff", 'limit', 0, 5)
	end
end
