# -*- encoding: utf-8 -*-
require File.expand_path('../lib/teacup/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'teacup'
  gem.version       = Teacup::VERSION

  gem.authors  = ['the rubymotion community']

  gem.description = <<-DESC
Teacup is a community-driven DSL for making CSS-like styling, and layouts for
complex and simple iOS apps with RubyMotion.

By aiming at making RubyMotion less tedious, Teacup makes RubyMotion feel like
interface builder, and work like a CSS stylesheet.
DESC

  gem.summary = 'A community-driven DSL for creating user interfaces on iOS.'
  gem.homepage = 'https://github.com/rubymotion/teacup'

  gem.files       = `git ls-files`.split($\)
  gem.require_paths = ['lib']
  gem.test_files  = gem.files.grep(%r{^spec/})

  gem.add_dependency 'motion-require'
end
