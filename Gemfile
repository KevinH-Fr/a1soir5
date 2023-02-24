source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"
gem "rails", "~> 7.0.4", ">= 7.0.4.2"
gem "sprockets-rails"

gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data" #, platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false

gem "simple_calendar", "~> 2.4"
gem "icalendar"

gem 'sassc', '~> 2.2'
gem 'jquery-ui-rails'

gem "ransack", "~> 3.2"
gem 'cloudinary'
gem "pagy", "~> 5.10"

gem 'devise'

gem "letter_opener", group: :development

gem 'wicked_pdf'
gem "wkhtmltopdf-binary", group: :development
gem "wkhtmltopdf-heroku", group: :production

gem "rqrcode", "~> 2.1"
gem 'chartjs-ror', '~> 2.2'

group :development, :test do
   gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "web-console"
  gem "sqlite3", "~> 1.4"

end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

group :production do
  gem 'pg', '~> 1.4', '>= 1.4.1'
end