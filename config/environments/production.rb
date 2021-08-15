require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.public_file_server.headers = { 'cache-control' => "public, max-age=#{1.year.to_i}" }
  config.assets.compile = false

  # Behind a TLS-terminating proxy keep both on; set RAILS_FORCE_SSL=false
  # only for a plain-HTTP local run such as the Compose stack.
  ssl = ENV.fetch('RAILS_FORCE_SSL', 'true') == 'true'
  config.assume_ssl = ssl
  config.force_ssl = ssl

  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.logger($stdout)
  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info')
  config.silence_healthcheck_path = '/up'
  config.active_support.report_deprecations = false

  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: ENV.fetch('APP_HOST', 'localhost') }

  config.i18n.fallbacks = true
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [:id]
end
