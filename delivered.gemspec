# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'delivered/version'

Gem::Specification.new do |s|
  s.name          = 'delivered'
  s.version       = Delivered::VERSION
  s.authors       = ['Joel Moss']
  s.email         = ['joel@developwithstyle.com']
  s.homepage      = 'https://github.com/joelmoss/delivered'
  s.licenses      = ['MIT']
  s.summary       = '[summary]'
  s.description   = '[description]'

  s.files         = Dir.glob('{bin/*,lib/**/*,[A-Z]*}')
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
end
