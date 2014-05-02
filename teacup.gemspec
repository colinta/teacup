# -*- encoding: utf-8 -*-
require File.expand_path('../lib/teacup/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'teacup'
  gem.version       = Teacup::VERSION
  gem.licenses      = ['BSD']

  gem.authors  = ['the rubymotion community']

  gem.description = <<-DESC
Teacup is a community-driven DSL for RubyMotion.  It has CSS-like styling, and
helps create complex and simple layouts in iOS and OS X apps.

Teacup aims at making UI develpoment in RubyMotion less tedious.  It's like
Interface Builder for RubyMotion!
DESC

  gem.summary = 'A community-driven DSL for creating user interfaces on iOS and OS X.'
  gem.homepage = 'https://github.com/rubymotion/teacup'

  gem.files       = Dir.glob('lib/**/*.rb')
  gem.files      << 'README.md'
  gem.require_paths = ['lib']
  gem.test_files  = Dir.glob('spec/**/*.rb')
end
