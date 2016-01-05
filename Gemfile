source 'https://rubygems.org'

ruby '2.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use bootstrap
gem 'bootstrap-sass'
# Autoprefixer, for use with Bootstrap
gem 'autoprefixer-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# mix the two
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Puma as the app server
gem 'puma'

# Using Facebook authentication for now
gem 'omniauth-facebook'
# Google too
gem 'omniauth-google-oauth2'
# When all else fails
gem 'omniauth-identity'

# Use Paperclip with S3 extension for storage
gem 'paperclip'
gem 'aws-sdk', '< 2.0'

# Use pg_search for full-text searches
gem 'pg_search'

# Use will_paginate with bootstrap styles
gem 'will_paginate-bootstrap'

# Implementation of the Extended Date and Time Format for ruby/rails
gem 'edtf-rails'

# Add genealogies to ActiveRecord models easily
gem 'genealogy'

# summernote text editor
gem 'summernote-rails'
gem 'font-awesome-rails'

#gem 'gedcom', :path => '../gedcom'
gem 'gedcom', :github => 'mrysav/gedcom', :branch => 'master'

# Required for importing GrampsXML
gem 'nokogiri'

# Date parser, used when importing data
gem 'chronic'

# For site-wide settings
gem "rails-settings-cached", "~> 0.4.0"

# For job processing - switch this out if necessary...
gem 'delayed_job'
gem 'delayed_job_active_record'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do
  # heroku features gems
  gem 'rails_12factor'
end
