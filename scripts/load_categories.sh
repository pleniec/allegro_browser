export ALLEGRO_LOGIN=login
export ALLEGRO_PASSWORD=password
export ALLEGRO_API_KEY=apikey

../allegro_browser/bin/rake -f ../allegro_browser/Rakefile\
	allegro_browser:refresh_categories_tree

