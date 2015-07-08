web: bin/start-nginx bundle exec unicorn -E $RAILS_ENV -c ./config/unicorn.rb
worker: bundle exec rake jobs:work --trace
