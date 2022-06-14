source 'https://rubygems.org'

ruby '2.7.6'
gem 'rails', '~> 5.2.0'

# localization
gem 'rails-i18n'
gem 'i18n-js', '~> 3.2.1'

# performance
gem 'turbolinks', '~> 5.2.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# documentation (bundle exec rake doc:rails generates the API under doc/api)
group :doc do
  gem 'sdoc', '~> 1.0.0', require: false
end

# security
gem 'devise', '~> 4.6'
gem 'simple_token_authentication', '~> 1.0'
gem 'pundit', '~> 2.0.1'
gem 'actionview-encoded_mail_to', '~> 1.0.9'

# asset pipeline
gem 'sass-rails', '~> 5.0.7' # TODO unmaintained as of 26 March 2019 (alternative: sassc-rails)
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2.2'

# asset libraries
gem 'webpacker', '~> 3.5'
gem 'jquery-rails', '~> 4.3.3'
gem 'jquery-ui-rails', '~> 6.0.1'
gem 'lazyload-rails', '~> 0.3.1'
gem 'bootstrap', '~> 4.1.0'
gem 'bootstrap_form', '~> 4.2.0'
gem 'bootstrap4-select-rails', '~> 2.0.0'
gem 'bootstrap-datepicker-rails', '~> 1.8.0'
gem 'photoswipe-rails', '~> 4.1.2'
gem 'groupdate', '~> 4.1.1'
gem 'chartkick', '~> 3.0.2'

# JSON API
gem 'jbuilder', '~> 2.8.0'
gem 'jsonapi-resources', '~> 0.9.6' #, github: 'cerebris/jsonapi-resources'
gem 'jsonapi-authorization', '~> 3.0.1' # , github: 'venuu/jsonapi-authorization'
gem 'recaptcha', '~> 4.14.0', require: 'recaptcha/rails'

# image management
gem 'mini_magick', '~> 4.9'
gem 'carrierwave', '~> 1.3'

# various
# TODO remove the github: when gem is compatible with Rails 5.2
# see https://github.com/maclover7/trix/pull/62 or https://github.com/maclover7/trix/pull/64
gem 'trix', git: 'https://github.com/DRBragg/trix.git', ref: :c8ca738
gem 'responders', '~> 2.4'
gem 'premailer-rails', '~> 1.10'
gem 'nokogiri', '~> 1.10'
gem 'icalendar', '~> 2.5'
gem 'friendly_id', '~> 5.2'
gem 'bootsnap', '~> 1.4'

# environment
gem 'pg', '~> 1.2.3'
gem 'dotenv-rails', '~> 2.7.2'
gem 'unicorn', '~> 5.5.0'

gem 'delayed_job_active_record', '~> 4.1.3'

gem 'capistrano3-delayed-job', '~> 1.7.6'

group :development do
  # Use Capistrano for deployment
  gem 'capistrano', '~> 3.14'
  gem 'capistrano-rails', '~> 1.6'
  gem 'capistrano-bundler', '~> 2.0'
  gem 'capistrano3-unicorn', '~> 0.2.1'

  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '~> 3.7.0'
  gem 'listen', '~> 3.1'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0.1'

  gem 'letter_opener', '~> 1.7'
  gem 'better_errors', '~> 2.5'
  gem 'binding_of_caller', '~> 0.8'
end

group :test do
  gem 'simplecov', '~> 0.18', require: false
  gem 'mutant', '~> 0.8.24'
  gem 'mutant-rspec', '~> 0.8.24'
  gem 'capybara', '~> 3.16'
  gem 'selenium-webdriver', '~> 3.142'
end

group :development, :test do
  gem 'sqlite3', '~> 1.4.0'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 11.0.1', platform: :mri

  gem 'rspec-rails', '~> 3.8.2'
end

group :production do
  gem 'exception_notification', '~> 4.3.0'
end
