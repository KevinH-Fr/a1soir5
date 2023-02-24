source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"
gem "rails", "~> 7.0.4", ">= 7.0.4.2"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data" #, platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false

gem "simple_calendar", "~> 2.4"
gem 'sassc', '~> 2.2'
gem 'jquery-ui-rails'

gem "ransack", "~> 3.2"
gem 'cloudinary'
gem "pagy", "~> 5.10"

gem "letter_opener", group: :development

gem 'wicked_pdf'
gem "wkhtmltopdf-binary", group: :development
gem "wkhtmltopdf-heroku", group: :production

gem "rqrcode", "~> 2.1"
gem 'chartjs-ror', '~> 2.2'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
