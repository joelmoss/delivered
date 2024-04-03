# frozen_string_literal: true

# $:.unshift File.expand_path('lib', __dir__)
require_relative 'lib/delivered/version'

Gem::Specification.new do |s|
  s.name          = 'delivered'
  s.version       = Delivered::VERSION
  s.authors       = ['Joel Moss']
  s.email         = ['joel@developwithstyle.com']
  s.homepage      = 'https://github.com/joelmoss/delivered'
  s.licenses      = ['MIT']
  s.summary       = 'Simple runtime type checking for Ruby method signatures'
  s.required_ruby_version = '>= 3.1'

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = s.homepage
  s.metadata['changelog_uri'] = "#{s.homepage}/releases"

  s.files         = Dir.glob('{bin/*,lib/**/*,[A-Z]*}')
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']

  s.metadata['rubygems_mfa_required'] = 'true'
end
