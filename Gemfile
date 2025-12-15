# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in cleo-ambassador.gemspec
gemspec

group :doc do
  gem "yard", ">= 0.9.38"
end

group :development do
  gem "guard", "~> 2.19"
  gem "guard-minitest", "~> 2.4"
  gem "rake", "~> 13.0"
  gem "rubocop", ">= 1.21"
  gem "rubocop-minitest", ">= 0.38"
  gem "rubocop-rake"
end

group :development, :test do
  gem "debug", "~> 1.11"
end

group :test do
  gem "activerecord", "~> 8.1"
  gem "minitest", ">=  5.27.0"
  gem "mocha", ">= 2.8.2"
  gem "sqlite3", "~> 2.8"
end
