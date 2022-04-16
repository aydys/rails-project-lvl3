setup:
	bin/setup

migrate:
	bin/rails db:migrate

deploy:
	git push heroku main

slim_lint:
	bundle exec slim-lint app/views

rubocop:
	bundle exec rubocop -a

linters: rubocop slim_lint

test:
	NODE_ENV=test bin/rails test

start:
	bin/rails server

seed:
	bin/rails db:seed

copy_env_template:
	cat .env.example > .env

.PHONY: test
