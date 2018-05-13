source 'https://rubygems.org'

# TODO can be deleted after upgrading to Bundler 2.0
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.3.7'
gem 'rails', '~> 5.2.0'

# localization
gem 'rails-i18n'
gem 'i18n-js'

# performance
gem 'turbolinks'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# documentation (bundle exec rake doc:rails generates the API under doc/api)
group :doc do
  gem 'sdoc', require: false
end

# security
gem 'devise'
gem 'simple_token_authentication', '~> 1.0'
gem 'pundit'
gem 'actionview-encoded_mail_to'

# asset pipeline
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'

# asset libraries
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'lazyload-rails'
gem 'bootstrap', '~> 4.1.0'
gem 'bootstrap_form'
gem 'bootstrap4-select-rails'
gem 'bootstrap-datepicker-rails'
gem 'photoswipe-rails'
gem 'groupdate'
gem 'chartkick'

# JSON API
gem 'jbuilder'
gem 'jsonapi-resources'
gem 'jsonapi-authorization'
gem 'recaptcha', require: 'recaptcha/rails'

# image management
gem 'mini_magick'
gem 'carrierwave'

# various
# TODO remove the github: when gem is compatible with Rails 5.2
# see https://github.com/maclover7/trix/pull/62 or https://github.com/maclover7/trix/pull/64
gem 'trix', github: 'DRBragg/trix', ref: :c8ca738
gem 'responders'
gem 'premailer-rails'
gem 'nokogiri'
gem 'icalendar'
gem 'friendly_id'
gem 'bootsnap'

# environment
gem 'pg'
gem 'dotenv-rails'
gem 'unicorn'

group :development do
  # Use Capistrano for deployment
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano3-unicorn'

  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'

  gem 'letter_opener'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'simplecov', require: false
  gem 'mutant'
  gem 'mutant-rspec'
end

group :development, :test do
  gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  gem 'rspec-rails'
end

group :production do
  gem 'exception_notification'
end
