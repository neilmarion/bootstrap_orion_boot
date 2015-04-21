# bootstrap_orion_boot
Run all Orion apps with one shell script where app servers and sidekiq servers are run separately. In addition separate tmux windows are created on each servers for better debugging. \m/

1. ``$ wget https://raw.githubusercontent.com/neilmarion/bootstrap_orion_boot/master/bootstrap.sh``
2. ``$ chmod 755 bootstrap.sh``
3. ``$ ./bootstrap.sh```

## Usage ##

### Start ###

#### Checkout master branch ####

``./bootstrap.sh start master``

#### Do not checkout master branch ####

``./bootstrap.sh start``

### Stop - kill all Orion apps ###

``./bootstrap.sh stop``
