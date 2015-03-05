Rails.application.config.allegro = ActiveSupport::OrderedOptions.new

Rails.application.config.allegro.login = ENV['ALLEGRO_LOGIN']
Rails.application.config.allegro.password = ENV['ALLEGRO_PASSWORD']
Rails.application.config.allegro.api_key = ENV['ALLEGRO_API_KEY']
