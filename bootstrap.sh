#!/bin/bash

function start {
  vagrant_directory="/vagrant/"
  apps="g5-inventory g5-integrations-dashboard g5-inventory-etl-service g5-vendor-leads-service g5-jobs"
  declare -a app_nicknames=('inv' 'dash' 'etl' 'vls' 'jobs');
  ports="5777 5774 5779 5775 5778"
  declare -a ports=('5777' '5774' '5779' '5775' '5778');
  no_of_apps=5

  tmux start-server
  tmux new-session -d -s my_server -n orion
  x=2
  for i in $apps
  do
    tmux new-window -t my_server:$x -n ${app_nicknames[x-2]}
    tmux send-keys -t my_server:$x "cd /vagrant/$i; git checkout master; git pull origin master; rake db:migrate; bundle; rails s -p ${ports[x-2]}" C-m
    tmux split-window -h
    tmux send-keys -t my_server:$x "cd /vagrant/$i; bundle exec sidekiq" C-m
    x=$((x+1))
  done

  tmux select-window -t my_server:2
  tmux attach-session -t my_server
}

function stop {
  OUTPUT=$(ps aux | grep "tmux new-session")
  IFS=' ' read -ra ADDR <<< "$OUTPUT"
  x=0
  for i in "${ADDR[@]}"; do
    if [ $x == 1 ]
    then
      kill $i
    fi
    x=$((x+1))
  done
}

function restart {
  tmux detach
  sleep 1
  stop
  sleep 1
  start
}

if [ $1 == "start" ]
then
  start
elif [ $1 == "restart" ]
then
  restart
elif [ $1 == "stop" ]
then
  stop
fi
