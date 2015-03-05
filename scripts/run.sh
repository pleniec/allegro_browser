export ALLEGRO_LOGIN=login
export ALLEGRO_PASSWORD=password
export ALLEGRO_API_KEY=apikey

nohup ../allegro_browser/bin/rails s &
echo $! > ./pids/server.pid

nohup ../allegro_browser/bin/rake -f ../allegro_browser/Rakefile\
	 resque:work QUEUE=populate_autocomplete &
echo $! > ./pids/worker.pid

