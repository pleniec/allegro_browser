kill $(cat ./pids/server.pid)
rm ./pids/server.pid
kill $(cat ./pids/worker.pid)
rm ./pids/worker.pid

