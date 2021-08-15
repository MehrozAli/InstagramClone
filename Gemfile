source 'https://rubygems.org'

ruby file: '.ruby-version'

gem 'bootsnap', require: false
gem 'carrierwave', '~> 3.1'
gem 'delayed_job_active_record', '~> 4.1'
gem 'devise'
gem 'jquery-rails'
gem 'pg', '~> 1.6'
gem 'puma', '>= 6.0'
gem 'pundit', '~> 2.5'
gem 'rails', '~> 8.1.1'
gem 'sprockets-rails'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'rubocop-rails-omakase', '~> 1.1', require: false
end

group :development do
  gem 'web-console'
end
