require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StcKarlsruhe
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.enforce_available_locales = true
    config.i18n.available_locales = [ :en, :de ]
    config.i18n.default_locale = :de
    config.time_zone = 'Berlin'

    CONTACT_FORM_RECIPIENT = 'contact@servethecity-karlsruhe.de'
    NOTIFICATION_RECIPIENT = 'notifications@servethecity-karlsruhe.de'
    NO_REPLY_SENDER = 'Serve the City Karlsruhe <no-reply@servethecity-karlsruhe.de>'

    # autoload lib directory (for Devise::CustomFailure)
    config.autoload_paths << Rails.root.join('lib')
  end
end
