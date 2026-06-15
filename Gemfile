source 'https://rubygems.org'

gem 'rails', '~> 8.1'

# Database
gem 'sqlite3', '~> 2.0'

# App server
gem 'puma', '>= 5.0'

# Asset pipeline
gem 'sprockets-rails'
gem 'sassc-rails'

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

# Bootstrap (v4 via bootstrap-sass, compatible with sassc-rails)
gem 'bootstrap-sass'

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
