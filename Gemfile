source 'https://rubygems.org'

ruby '3.4.8'

gem 'rails', '~> 8.1'

# Database — PostgreSQL in every environment (dev/test/production)
gem 'pg', '~> 1.5'

# App server
gem 'puma', '>= 5.0'

# Asset pipeline
gem 'sprockets-rails'
# dartsass-sprockets compiles .scss via the prebuilt Dart Sass binary
# (sass-embedded). Replaces the abandoned sassc/libsass, which segfaults
# during assets:precompile on Ruby 3.4 in the Linux build image.
gem 'dartsass-sprockets'

# JavaScript
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'

# JSON API
gem 'jbuilder'

# Bootsnap speeds up boot time
gem 'bootsnap', require: false

# File uploads (ActiveStorage is built-in; image_processing needed for variants)
gem 'image_processing', '~> 1.2'
gem 'active_storage_validations'

# Auth
gem 'devise', '>= 4.9'

# Windows tzinfo
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :development do
  gem 'web-console'
  gem 'listen'
  gem 'spring'
end
