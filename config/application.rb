require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    # ActionMailer settings
    config.action_mailer.delivery_method = :smtp

    config.action_mailer.perform_deliveries = true

    config.action_mailer.smtp_settings = {
      address: 'box.comandapp.xyz',
      domain: 'comandapp.pe',
      port: 587,
      user_name: 'noresponder@comandapp.pe',
      password: 'patchypatches',
      authentication: 'plain',
      enable_starttls_auto: true
    }

    # Locale settings
    config.i18n.available_locales = [:es, :en]
    config.i18n.default_locale = :es
    config.i18n.fallbacks = [:en]
  end
end
