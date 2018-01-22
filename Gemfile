source 'https://rubygems.org'

# TODO can be deleted after upgrading to Bundler 2.0
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.3.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.0'

gem 'rails-i18n'

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

# Use SCSS for stylesheets
gem 'sass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'lazyload-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'responders'

gem 'devise'
gem 'simple_token_authentication', '~> 1.0'
gem 'pundit'

gem 'jsonapi-resources'
gem 'jsonapi-authorization'

gem 'mini_magick'
gem 'carrierwave'
gem 'jssorslider-rails', github: 'matthias-g/jssorslider-rails'
gem 'photoswipe-rails'

gem 'bootstrap-sass'
gem 'bootstrap_form'

gem 'bootstrap-select-rails', github: 'matthias-g/bootstrap-select-rails', branch: 'upgrade-1.12.4'
gem 'bootstrap-datepicker-rails'

gem 'trix'

gem 'groupdate'
gem 'chartkick'

gem 'dotenv-rails'

gem 'actionview-encoded_mail_to'
gem 'recaptcha', require: 'recaptcha/rails'

gem 'premailer-rails'
gem 'nokogiri'

gem 'icalendar'

gem 'pg'

gem 'friendly_id'

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
  gem 'codeclimate-test-reporter', require: nil
  gem 'mutant'
  gem 'mutant-rspec'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  gem 'rspec-rails'
end

group :production do
  gem 'exception_notification'
end
