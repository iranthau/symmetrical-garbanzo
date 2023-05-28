source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.4"

gem "rails", "~> 7.0.4", ">= 7.0.4.3"

gem "bootsnap", require: false
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "sidekiq"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'rspec-rails', '~> 6.0.0'
end

group :test do
  gem 'rspec-sidekiq'
  gem 'shoulda-matchers', '~> 5.0'
end

group :development do
end
