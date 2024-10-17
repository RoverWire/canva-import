cron-clear:
	docker exec canva-import-ruby crontab -r

cron-list:
	docker exec canva-import-ruby crontab -l

cron-start:
	docker exec canva-import-ruby crond start

cron-update:
	docker exec canva-import-ruby whenever -i

db-setup:
	docker exec canva-import-ruby rake db:setup

db-reset:
	docker exec canva-import-ruby rake db:reset

env-update:
	docker exec --env-file .env canva-import-ruby env