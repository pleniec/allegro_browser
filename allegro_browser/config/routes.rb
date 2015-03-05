Rails.application.routes.draw do
  get '', to: 'allegro_browser#index'
  scope :ajax do
    get '/categories', to: 'allegro_browser_ajax#categories'
    get '/auctions', to: 'allegro_browser_ajax#auctions'
    post '/add_to_favourites', to: 'allegro_browser_ajax#add_to_favourites'
    get '/autocomplete', to: 'allegro_browser_ajax#autocomplete'
  end
end
