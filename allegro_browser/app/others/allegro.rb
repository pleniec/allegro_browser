module Allegro
	def self.api
		@@api ||= AllegroAPI.new(Rails.application.config.allegro)
	end

	class AllegroAPI
		def initialize(config)
			@config = config
			update_version_key!
			update_session_handle!
		end

		def categories
			message = {'webapi-key' => @config.api_key, 'country-id' => 1}
			result = soap_client.call(:do_get_cats_data, message: message)
			result.to_hash[:do_get_cats_data_response][:cats_list][:item]
		end

		def auctions(params)
			session_handle_retry do
				message = {'session-handle' => @session_handle,
									 'search-query' => params}
				result = soap_client.call(:do_search, message: message)
				result_hash = result.to_hash[:do_search_response]

				begin # unpredictable allegro api behaviour
					total = result_hash[:search_count].to_i

					if total > 1
						auctions = result_hash[:search_array][:item]
					elsif total == 1
						auctions = [result_hash[:search_array][:item]]
					else
						auctions = []
					end

					if total > 1
						Resque.enqueue(PopulateAutocomplete, auctions.map { |a| slice_to_autocomplete(a) })
					end

					{total: total,
					 auctions: auctions.map { |a| slice_to_view(a) }}
				rescue => e
					{total: 0,
					 auctions: []}
				end
			end
		end

		private

		def slice_to_view(auction)
			auction.slice(:s_it_id, :s_it_name, :s_it_thumb_url, :s_it_buy_now_price,
										:s_it_ending_time, :s_it_price)
		end

		def slice_to_autocomplete(auction)
			auction.slice(:s_it_id, :s_it_name)
		end

		def soap_client
			@soap_client ||= Savon.client(wsdl: 'https://webapi.allegro.pl/uploader.php?wsdl')
		end

		def update_version_key!
			message = {'sysvar' => 4, 'country-id' => 1, 'webapi-key' => @config.api_key}
			result = soap_client.call(:do_query_sys_status, message: message)
			@version_key = result.to_hash[:do_query_sys_status_response][:ver_key]
		end

		def version_key_retry
			begin
				yield
			rescue Savon::SOAPFault => e
				if e.to_hash[:fault][:faultcode] == 'ERR_INVALID_VERSION_CAT_SELL_FIELDS'
					update_version_key!
					yield
				else
					raise e
				end
			end
		end

		def update_session_handle!
			version_key_retry do
				message = {'user-login' => @config.login,
									 'user-hash-password' => Digest::SHA256.base64digest(@config.password),
									 'country-code' => 1,
									 'webapi-key' => @config.api_key,
									 'local-version' => @version_key}
				result = soap_client.call(:do_login_enc, message: message)
				@session_handle = result.to_hash[:do_login_enc_response][:session_handle_part]
			end
		end

		def session_handle_retry
			begin
				yield
			rescue Savon::SOAPFault => e
				if e.to_hash[:fault][:faultcode] == 'ERR_NO_SESSION'
					update_version_key!
					yield
				else
					raise e
				end
			end
		end
	end
end
