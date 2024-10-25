RUBY_CONTAINER = canva-import-ruby
TAIL ?= 50

# Ruby gems bundle install on container
bundle-install:
	@docker exec ${RUBY_CONTAINER} bundle install

# Clears the crontab schedule
cron-clear:
	@docker exec ${RUBY_CONTAINER} whenever -c

# Prints the crontab schedule
cron-list:
	@docker exec ${RUBY_CONTAINER} crontab -l

# Starts the crond deamon in the container
cron-start:
	@docker exec ${RUBY_CONTAINER} crond start

# Appends the content from config/schedule to crontab
cron-update:
	@docker exec ${RUBY_CONTAINER} whenever -i

# Overwrites the crontab schedule replacing the contents
cron-write:
	@docker exec ${RUBY_CONTAINER} whenever -w

# Runs the database creation, migrations and seeds
db-setup:
	docker exec ${RUBY_CONTAINER} rake db:setup

# Drops the current database and creates it again
db-reset:
	@docker exec ${RUBY_CONTAINER} rake db:reset

# Reloads the .env variables to the container
env-update:
	@docker exec --env-file .env ${RUBY_CONTAINER} env

# Shows last N elements of live logs from ruby container
logs:
	@docker logs -f ${RUBY_CONTAINER} --tail $(TAIL)

# Restart the ruby container
restart:
	@docker restart ${RUBY_CONTAINER}

# Enter to the container CLI and working folder
ssh:
	@docker exec -it ${RUBY_CONTAINER} sh
