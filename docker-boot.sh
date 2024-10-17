#!/bin/bash

# Create database, run migrations & seed
rake db:setup

# initializes the cron process || crond -f
# crond start

# initializes the web server
ruby app.rb
