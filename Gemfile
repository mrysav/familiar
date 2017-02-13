source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'
# Use PostgreSQL as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

ruby '2.3.3'

group :production do
    gem 'rails_12factor'
end

# Use bootstrap
gem 'bootstrap-sass'
# Autoprefixer, for use with Bootstrap
gem 'autoprefixer-rails'
# Font Awesome, for lots of icons
gem 'font-awesome-rails'
# Use will_paginate with bootstrap styles
gem 'will_paginate-bootstrap'

# Using Facebook authentication for now
gem 'omniauth-facebook'
# Google too
gem 'omniauth-google-oauth2'
# When all else fails
gem 'omniauth-identity'

# Implementation of the Extended Date and Time Format for ruby
gem 'edtf'
#gem 'gedcom', :path => '../gedcom'
gem 'gedcom', :github => 'mrysav/gedcom', :branch => 'master'
# Required for importing GrampsXML
gem 'nokogiri'
# Date parser, used when importing data
gem 'chronic'

# For job processing - switch this out if necessary...
gem 'delayed_job_active_record'

# Use Carrierwave with S3 extension for production storage
gem 'carrierwave', '~> 1.0'
gem 'mini_magick'
group :production do
    gem 'fog-aws'
end

# Use pg_search for full-text searches
gem 'pg_search'

# Markdown renderer
gem 'redcarpet'

# For content tagging
gem 'acts-as-taggable-on', '~> 4.0'
