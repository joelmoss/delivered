# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

group :development do
  gem 'rubocop'
end

group :test do
  gem 'sus'
end

group :development, :test do
  gem 'amazing_print'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end
