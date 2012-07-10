require File.expand_path('../lib/teacup/version.rb', __FILE__)
require File.expand_path('../lib/teacup/contributors.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'teacup'
  gem.version       = Teacup::VERSION

  gem.authors  = Teacup::CONTRIBUTORS
  gem.summary = 'A community-driven DSL for creating user interfaces on the iphone.'
  gem.description = <<-DESC
Teacup is a community-driven DSL for making CSS-like styling, and layouts for complex, and simple
iOS apps with RubyMotion.

By aiming at making RubyMotion less tedious, Teacup makes RubyMotion feel like interface builder, and
work like a CSS stylesheet.
DESC
  gem.homepage = 'https://github.com/rubymotion/teacup'

  gem.require_paths = ['lib']
  gem.files        = `git ls-files`.split($\)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files  = gem.files.grep(%r{^spec/})

  gem.add_dependency 'rake'
  gem.add_development_dependency 'rspec'

end
